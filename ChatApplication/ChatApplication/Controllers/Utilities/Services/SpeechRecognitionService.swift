//
//  SpeechRecognitionService.swift
//  TetViet
//
//  Created by vinhdd on 12/31/18.
//  Copyright © 2018 Rikkeisoft. All rights reserved.
//

import UIKit
import AVFoundation

class SpeechRecognitionService: NSObject {

    // MARK: - Singleton
    static let instance = SpeechRecognitionService()
    
    // MARK: - Variables
    private var audioRecorder: AVAudioRecorder?
    private var metersTimer: Timer?
    private var currentInterval: CGFloat = 0
    private var gotDecimalCounter: Int = 0
    private var recentDecibel = [Float]()
    private var requestApiAfterStop = true
    
    // MARK: - Closures
    var didReceiveMessages: ((_ messages: [String?]) -> Void)?
    var didStopRecording: (() -> Void)?
    var didGetDecibel: ((_ decibel: CGFloat) -> Void)?
    
    // google cloud speech
    var didReceiveCloudMessages: ((_ messages: String?) -> Void)?
    
    // MARK: - Init & deinit
    override init() {
        super.init()
        setupAudioSession()
    }
    
    // MARK: - Setup
    private func setupAudioSession() {
        let soundFileURL = getAudioFileUrl()
        let recordSettings =
            [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
             AVEncoderBitRateKey: 16,
             AVNumberOfChannelsKey: 1,
             AVSampleRateKey: 16000.0] as [String: Any]
        do {
            try audioRecorder = AVAudioRecorder(url: soundFileURL,
                                                settings: recordSettings as [String : AnyObject])
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.prepareToRecord()
        } catch let error as NSError {
            print("-> [Speech Recognition] AudioSession error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Action
    func startRecording() {
        setSessionPlayer(on: true)
        requestApiAfterStop = true
        audioRecorder?.record()
        audioRecorder?.updateMeters()
        startMetersTimer()
    }
    
    func stopRecording(requestAPIAfterStop: Bool) {
        self.requestApiAfterStop = requestAPIAfterStop
        stopMetersTimer()
        if audioRecorder?.isRecording == true {
            audioRecorder?.stop()
        }
    }
    
    private func startMetersTimer() {
        stopMetersTimer()
        metersTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                           target: self,
                                           selector: #selector(metersTimerAction(timer:)),
                                           userInfo: nil,
                                           repeats: true)
    }
    
    private func stopMetersTimer() {
        metersTimer?.invalidate()
        metersTimer = nil
        gotDecimalCounter = 0
        currentInterval = 0
    }
    
    @objc private func metersTimerAction(timer: Timer) {
        guard let recorder = audioRecorder else { return }
        currentInterval += 0.1
        recorder.updateMeters()
        let decibels = recorder.averagePower(forChannel: 0)
        didGetDecibel?(CGFloat(decibels))
        print("-> [Speech Recognition] Decibels: \(decibels)")
        
        let maxCount = 5
        gotDecimalCounter += 1
        recentDecibel.append(decibels)
        
        // Equal after 0.1 * 5
        if gotDecimalCounter >= maxCount {
            gotDecimalCounter = 0
            recentDecibel = Array(recentDecibel.suffix(maxCount))
            let _decibel = Int(recentDecibel.max()!)
            
            if currentInterval >= 2 && _decibel > -120  && _decibel < -30 {
                stopRecording(requestAPIAfterStop: true)
            }
        }
    }
    
    private func setSessionPlayer(on: Bool) {
        if on {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [])
            } catch _ { }
            do {
                try AVAudioSession.sharedInstance().setActive(true)
            } catch _ { }
            do {
                try AVAudioSession.sharedInstance().overrideOutputAudioPort(.none)
            } catch _ { }
        } else {
            do {
                try AVAudioSession.sharedInstance().setActive(false)
            } catch _ { }
        }
    }
    
    
    // MARK: - Builder
    func startSpeechAnalyzingWithAudioFrom(url: URL) {
        print("-> [Speech Recognition] File url path: \(url)")
        if FileManager.default.fileExists(atPath: url.path) {
            if let data = try? Data(contentsOf: url) {
                
            }
        }
    }
    
    func startCloudSttAnalyzingWithAudioFrom(url: URL) {
        print("-> [Speech Recognition] File url path: \(url)")
        if FileManager.default.fileExists(atPath: url.path) {
            if let data = try? Data(contentsOf: url) {
            
            }
        }
    }

    func getAudioFileUrl() -> URL {
        let fileMgr = FileManager.default
        let dirPaths = fileMgr.urls(for: .documentDirectory,
                                    in: .userDomainMask)
        return dirPaths[0].appendingPathComponent("speech_recog.wav")
    }
}

extension SpeechRecognitionService: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if requestApiAfterStop {
            startCloudSttAnalyzingWithAudioFrom(url: recorder.url)
        }
        didStopRecording?()
        setSessionPlayer(on: false)
    }
}
