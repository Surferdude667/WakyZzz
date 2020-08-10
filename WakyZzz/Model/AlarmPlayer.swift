//
//  AlarmPlayer.swift
//  WakyZzz
//
//  Created by Bjørn Lau Jørgensen on 10/08/2020.
//  Copyright © 2020 Olga Volkova OC. All rights reserved.
//

import AVFoundation

enum AlarmSound: String {
    case low = "alarm_low"
    case high = "alarm_high"
    case evil = "alarm_evil"
}

class AlarmPlayer {
    
    var player: AVAudioPlayer?

    func playSound(_ soundName: AlarmSound) {
        guard let url = Bundle.main.url(forResource: soundName.rawValue, withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            player.numberOfLoops = 10
            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopSound() {
        player?.stop()
    }
    
}
