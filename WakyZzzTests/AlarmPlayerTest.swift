//
//  AlarmPlayerTest.swift
//  WakyZzzTests
//
//  Created by Bjørn Lau Jørgensen on 11/08/2020.
//  Copyright © 2020 Olga Volkova OC. All rights reserved.
//

import XCTest
@testable import WakyZzz

class AlarmPlayerTests: XCTestCase {

    func testPlay() {
        let player = AlarmPlayer()
        
        player.playSound(.low)
        XCTAssert(player.player?.isPlaying == true)
        
        player.playSound(.high)
        XCTAssert(player.player?.isPlaying == true)
        
        player.playSound(.evil)
        XCTAssert(player.player?.isPlaying == true)
    }
    
    func testStop() {
        let player = AlarmPlayer()
        player.playSound(.evil)
        XCTAssert(player.player?.isPlaying == true)
        
        player.stopSound()
        XCTAssert(player.player?.isPlaying == false)
    }

}
