//
//  ASRBeepPlayer.swift
//  SampleApp
//
//  Created by jin kim on 2019/12/09.
//  Copyright (c) 2019 SK Telecom Co., Ltd. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import AVFoundation

import NuguCore

final class ASRBeepPlayer: NSObject {
    private let focusManager: FocusManageable
    
    init(focusManager: FocusManageable) {
        self.focusManager = focusManager
        super.init()
        
        focusManager.add(channelDelegate: self)
    }
    
    // MARK: ASRBeepPlayer
    
    private var player: AVAudioPlayer?
    
    // MARK: FocusChannelPriority
    
    private let channelPriority = FocusChannelPriority(requestPriority: 0, maintainPriority: 0)
    
    // MARK: CurrentBeepType
    
    private var requestedBeepType: BeepType?
    
    // MARK: BeepType
    
    enum BeepType: String {
        case start
        case success
        case fail
        
        fileprivate var isEnabled: Bool {
            switch self {
            case .start: return UserDefaults.Standard.useAsrStartSound
            case .success: return UserDefaults.Standard.useAsrSuccessSound
            case .fail: return UserDefaults.Standard.useAsrFailSound
            }
        }
        
        fileprivate var fileName: String {
            return "asr\(rawValue.capitalized)"
        }
            
        fileprivate var extention: String {
            return "wav"
        }
        
        fileprivate var fileTypeHint: String {
            return AVFileType.wav.rawValue
        }
    }
    
    // MARK: Internal (beep)
    
    func beep(type: BeepType) {
        requestedBeepType = type
        focusManager.requestFocus(channelDelegate: self)
    }
}

// MARK: Private (play / stop)

private extension ASRBeepPlayer {
    func play(type: BeepType) {
        guard let url = Bundle.main.url(forResource: type.fileName, withExtension: type.extention) else {
            log.error("Can't find sound file")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: type.fileTypeHint)
            player?.play()
        } catch {
            log.error("Failed to play local beep file : \(error.localizedDescription)")
        }
    }
}

// MARK: FocusChannelDelegate

extension ASRBeepPlayer: FocusChannelDelegate {
    func focusChannelPriority() -> FocusChannelPriority {
        return channelPriority
    }
    
    func focusChannelDidChange(focusState: FocusState) {
        log.debug("focusChannelDidChange = \(focusState)")
        guard let requestedBeepType = requestedBeepType else {
            log.error("focus channel has been changed while requested beepType is nil")
            return
        }
        switch focusState {
        case .foreground, .background:
            play(type: requestedBeepType)
            focusManager.releaseFocus(channelDelegate: self)
        case .nothing:
            break
        }
    }
}
