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

final class ASRBeepPlayer {
    private let beepQueue = DispatchQueue(label: "com.sktelecom.romaine.beep_player")
    private lazy var startBeepPlayer: AVAudioPlayer? = {
        guard let startBeepUrl = Bundle.main.url(forResource: BeepType.start.fileName, withExtension: BeepType.start.extention) else { return nil }
        return try? AVAudioPlayer(contentsOf: startBeepUrl, fileTypeHint: BeepType.start.fileTypeHint)
    }()
    private let successBeepPlayer: AVAudioPlayer? = {
        guard let successBeepUrl = Bundle.main.url(forResource: BeepType.success.fileName, withExtension: BeepType.success.extention) else { return nil }
        return try? AVAudioPlayer(contentsOf: successBeepUrl, fileTypeHint: BeepType.success.fileTypeHint)
    }()
    private let failBeepPlayer: AVAudioPlayer? = {
        guard let failBeepUrl = Bundle.main.url(forResource: BeepType.fail.fileName, withExtension: BeepType.fail.extention) else { return nil }
        return try? AVAudioPlayer(contentsOf: failBeepUrl, fileTypeHint: BeepType.fail.fileTypeHint)
    }()
    private let focusManager: FocusManageable
    
    init(focusManager: FocusManageable) {
        self.focusManager = focusManager
        
        focusManager.add(channelDelegate: self)
    }
    
    // MARK: ASRBeepPlayer
    
    private var player: AVAudioPlayer?
    
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
            switch self {
            case .start:
                return "listening_start"
            case .success:
                return "listening_end"
            case .fail:
                return "responsefail"
            }
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
        play(type: type)
        focusManager.requestFocus(channelDelegate: self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            guard let self = self else { return }
            
            self.focusManager.releaseFocus(channelDelegate: self)
        }
    }
}

// MARK: Private (play / stop)

private extension ASRBeepPlayer {
    func play(type: BeepType) {
        beepQueue.async { [weak self] in
            switch type {
            case .fail:
                if self?.failBeepPlayer?.isPlaying == false {
                    self?.failBeepPlayer?.play()
                }

            case .start:
                if self?.startBeepPlayer?.isPlaying == false {
                    self?.startBeepPlayer?.play()
                }
            case .success:
                if self?.successBeepPlayer?.isPlaying == false {
                    self?.successBeepPlayer?.play()
                }
            }
        }
    }
}

// MARK: FocusChannelDelegate

extension ASRBeepPlayer: FocusChannelDelegate {
    func focusChannelPriority() -> FocusChannelPriority {
        return .beep
    }
    
    func focusChannelDidChange(focusState: FocusState) {
        log.debug(focusState)
    }
}
