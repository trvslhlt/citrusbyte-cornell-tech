//
//  SpeechToTextTranslator.swift
//  Scribe
//
//  Created by trvslhlt on 10/21/16.
//  Copyright © 2016 travis holt. All rights reserved.
//

import Foundation
import Speech


class SpeechToTextTranslator: NSObject {
    static let sharedInstance = SpeechToTextTranslator()
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    private override init() {
        super.init()
        self.speechRecognizer.delegate = self
    }
    
    var isAuthorized: Bool {
        let authStatus = SFSpeechRecognizer.authorizationStatus()
        switch authStatus {
        case .authorized:
            return true
        case .denied:
            return false
        case .restricted:
            return false
        case .notDetermined:
            return false
        }
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> ()) {
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            switch authStatus {
            case .authorized:
                completion(true)
            case .denied:
                completion(false)
            case .restricted:
                completion(false)
            case .notDetermined:
                completion(false)
            }
        }
    }
    
    func startRecording(updatedTranscription: @escaping (String) -> (), completion: @escaping (Bool) -> () = { _ in }) {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }

        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }

        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }

        recognitionRequest.shouldReportPartialResults = true

        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { result, error in
            var isFinal = false
            if result != nil {
                updatedTranscription(result?.bestTranscription.formattedString ?? "")
                isFinal = (result?.isFinal)!
            }

            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                completion(true)
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)  //11
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()  //12
        
        do {
            try audioEngine.start()
        } catch {
            completion(false)
            print("audioEngine couldn't start because of an error.")
        }
    }
    
    func stopRecording() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
        }
    }
}


extension SpeechToTextTranslator: SFSpeechRecognizerDelegate {

    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        print("(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool)")
    }
    
}
