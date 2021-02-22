//
//  AudioService.swift
//  TetViet
//
//  Created by hunglv on 12/16/18.
//  Copyright © 2018 Rikkeisoft. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

enum VoiceType: String {
    case undefined
    case waveNetFemale = "en-US-Wavenet-F"
    case waveNetMale = "en-US-Wavenet-D"
    case standardFemale = "en-US-Standard-E"
    case standardMale = "en-US-Standard-D"
}

let ttsAPIUrl = "https://texttospeech.googleapis.com/v1beta1/text:synthesize"
let APIKey = Constants.gmsTranslateAPIkey

class AudioService: NSObject {
    
    // MARK: - Singleton
    static let shared = AudioService()
    
    // MARK: - Variables
    private var audioPlayer: AVAudioPlayer?
    private var mp3Datas: [Data] = []
    var indexPlaying: Int = 0
    
    // MARK: - Closures
    var audioDidEnd: (() -> Void)?
    var audioDidStop: (() -> Void)?
    
    // MARK: - Initilization
    private override init() {}
    
    // MARK: - Functions
    func speech(with text: String, startIndex: Int = 0, failure: ((Error) -> Void)? = nil) {
        IndicatorViewer.show()
        let textArr = Utils.splitStringWithSentence(text: text, count: 200)
        let apiGroup = DispatchGroup()
        var blocks: [DispatchWorkItem] = []
        var storedError: Error?
        var dataDict: [Int : Data] = [:]
        indexPlaying = startIndex
        
        for i in 0..<textArr.count {
            apiGroup.enter()
            let block = DispatchWorkItem(flags: .inheritQoS) {
                self.requestSpeech(text: textArr[i]) { data, error in
                    if let data = data {
                        dataDict[i] = data
                    }
                    if let error = error {
                        storedError = error
                    }
                    apiGroup.leave()
                }
            }
            blocks.append(block)
            DispatchQueue.main.async(execute: block)
        }
        
        apiGroup.notify(queue: DispatchQueue.main) {
            IndicatorViewer.hide()
            if let error = storedError {
                failure?(error)
            } else {
                self.mp3Datas = dataDict.sorted { $0.0 < $1.0 } .map { $0.1 }
                self.speechSynch(startIndex: startIndex)
            }
        }
    }
    
    func pauseAudioPlayer() {
        audioPlayer?.pause()
    }
    
    func resumeAudioPlayer() {
        audioPlayer?.play()
    }
    
    func isPlay() -> Bool {
        return audioPlayer?.isPlaying ?? false
    }
    
    func stopAudioPlayer() {
        audioPlayer?.pause()
        audioPlayer = nil
        indexPlaying = 0
        audioDidStop?()
    }
    
    //MARK: - Private functions
    private func speechSynch(startIndex: Int) {
        if startIndex > 0 {
            for _ in 0..<startIndex {
                mp3Datas.removeFirst()
            }
        }
        if mp3Datas.isEmpty {
            stopAudioPlayer()
            handleAudioDidEnd()
        } else {
            play(with: mp3Datas[0])
        }
    }
    
    private func playerDidFinishPlaying() {
        if !mp3Datas.isEmpty {
            mp3Datas.removeFirst()
        }
        if mp3Datas.isEmpty {
            stopAudioPlayer()
            handleAudioDidEnd()
        } else {
            play(with: mp3Datas[0])
            self.indexPlaying += 1
        }
    }
    
    private func requestSpeech(text: String,
                       voice: FPTSpeechVoiceType = SharedData.chatBotSpeechVoiceType,
                       completion: @escaping ((Data?, Error?)->Void)) {
        GoogleTTSAPI().excuteWith(text: text) { (data, error) in
            completion(data, error)
        }
    }
    
    private func playAudioPlayerWith(url: URL) {
        print("-> Speech url: \(url.absoluteString)")
        Utils.sleep(0.1, completion: {
            try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try? AVAudioSession.sharedInstance().setActive(true)
            self.audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            self.audioPlayer?.volume = 1.0
            self.audioPlayer?.delegate = self
            self.audioPlayer?.play()
        })
    }
    
    private func play(with data: Data) {
        do {
            print("start play")
            try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try? AVAudioSession.sharedInstance().setActive(true)
            self.audioPlayer = try AVAudioPlayer(data: data)
            self.audioPlayer?.prepareToPlay()
            self.audioPlayer?.volume = 1.0
            self.audioPlayer?.enableRate = true
            self.audioPlayer?.rate = SharedData.speechSpeed.value
            self.audioPlayer?.delegate = self
            self.audioPlayer?.play()
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func startRecordSound(completionBlock: (() -> Void)? = nil) {
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(1110), completionBlock)
    }

    func stopRecordSoundFail() {
        AudioServicesPlayAlertSound(SystemSoundID(1112))
    }

    func stopRecordSoundSuccess(stopSound: Bool = true) {
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        try? AVAudioSession.sharedInstance().setActive(true)
        AudioServicesPlayAlertSound(SystemSoundID(1111))
    }
    
    func readMony() {
        if let path = Bundle.main.path(forResource: "mpga", ofType:nil) {
            let url = URL(fileURLWithPath: path)
            do {
                try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
                try? AVAudioSession.sharedInstance().setActive(true)
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                self.audioPlayer?.prepareToPlay()
                self.audioPlayer?.volume = 1.0
                self.audioPlayer?.enableRate = true
                self.audioPlayer?.rate = SharedData.speechSpeed.value
                self.audioPlayer?.delegate = self
                self.audioPlayer?.play()
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func handleAudioDidEnd(){
        if queueSpeak.count > 0 {
            queueSpeak.remove(at: 0)
        }
        if self.queueSpeak.count == 0 {
            audioDidEnd?()
        } else {
            if let text = queueSpeak.first {
                speech(with: text)
            }
        }
    }
    
    private var queueSpeak: [String] = []
    
    func addToQueue(text: String){
        if !text.isEmpty {
            queueSpeak.append(text)
            if !isPlay(), let text = queueSpeak.first {
                speech(with: text)
            }
        }
    }
    
    func stopSpeakQueue() {
        self.stopAudioPlayer()
        queueSpeak.removeAll()
    }
    
    struct SpeakLanguage {
        var code: String
        var text: String
    }
    func audioSpeakManyLanguage(language: [SpeakLanguage], timeDelay: Double = 0.1, completion: (()->Void)? = nil) {
        var index = 0
        if language.count > 0 {
            AudioService.shared.speech(with: language[0].text) //, inLanguage: language[0].code)
        }
        AudioService.shared.audioDidEnd = {
            index += 1
            if language.count > index {
                Utils.sleep(timeDelay) {
                    AudioService.shared.speech(with: language[index].text) //, inLanguage: language[index].code)
                }
            } else {
                completion?()
                AudioService.shared.audioDidEnd = nil
            }
        }
    }
}

extension AudioService: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playerDidFinishPlaying()
    }
}
