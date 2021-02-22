//
//  GoogleTTSAPI.swift
//  TetViet
//
//  Created by QuangLH on 3/29/19.
//  Copyright © 2019 Rikkeisoft. All rights reserved.
//

import Foundation
import Alamofire

class GoogleTTSAPI {
    
    private let apiKey = Constants.gmsTranslateAPIkey
    private var apiURL: URL {
        return URL(string: "https://texttospeech.googleapis.com/v1/text:synthesize")!
    }
    
    func excuteWith(text: String, completion: @escaping (Data?, Error?)->()) {
        callGoogleTextToSpeech(with: text, completion: completion)
    }
    
    private func callGoogleTextToSpeech(
        with text: String,
        completion:  @escaping (Data?, Error?)->()) {
        
        let voiceParams: [String: Any] = [
            // All available voices here: https://cloud.google.com/text-to-speech/docs/voices
            "languageCode": "vi-VN",
            "name": "vi-VN-Standard-C"
        ]
        
        let parameters: Parameters = [
            "input": [
                "text": text
            ],
            "voice": voiceParams,
            "audioConfig": [
                // All available formats here: https://cloud.google.com/text-to-speech/docs/reference/rest/v1beta1/text/synthesize#audioencoding
                "audioEncoding": "LINEAR16"
            ]
        ]
        
        let headers = ["X-Goog-Api-Key": APIKey,
                       "X-Ios-Bundle-Identifier": Bundle.main.bundleIdentifier ?? "",
                       "Content-Type": "application/json; charset=utf-8"]
        
        Alamofire.request(
            apiURL,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers)
            .responseJSON(completionHandler: { (response) in
                guard
                    let result = response.result.value as? [String : AnyObject],
                    let audioContent = result["audioContent"] as? String,
                    let audioData = Data(base64Encoded: audioContent)
                    else {
                        completion(nil,response.result.error)
                        return
                }
                
                completion(audioData,nil)
            })
    }
    
}
