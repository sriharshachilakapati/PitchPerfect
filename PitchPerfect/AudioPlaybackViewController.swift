//
//  AudioPlaybackViewController.swift
//  PitchPerfect
//
//  Created by Sri Harsha Chilakapati on 15/11/20.
//

import UIKit
import AVFoundation

class AudioPlaybackViewController: UIViewController {

    var recordedFile: URL!

    internal var audioFile: AVAudioFile!
    internal var audioEngine: AVAudioEngine!
    internal var audioPlayerNode: AVAudioPlayerNode!
    internal var stopTimer: Timer!

    @IBOutlet weak var stopButton: UIButton!

    private weak var lastActivePlayButton: UIButton?

    enum ButtonType: Int {
        case slow = 0
        case fast
        case highPitch
        case lowPitch
        case echo
        case reverb
    }

    override func viewWillAppear(_ animated: Bool) {
        stopButton.isEnabled = false
        setupAudio()
    }

    override func viewWillDisappear(_ animated: Bool) {
        stopAudio()
    }

    @IBAction func onPlayButtonClicked(_ sender: UIButton) {
        lastActivePlayButton = sender
        lastActivePlayButton?.isEnabled = false
        stopButton.isEnabled = true

        switch ButtonType(rawValue: sender.tag)! {
            case .slow:      playSound(rate: 0.5)
            case .fast:      playSound(rate: 1.5)
            case .highPitch: playSound(pitch: 1000)
            case .lowPitch:  playSound(pitch: -1000)
            case .echo:      playSound(echo: true)
            case .reverb:    playSound(reverb: true)
        }
    }

    func onAudioStopped() {
        lastActivePlayButton?.isEnabled = true
        stopButton.isEnabled = false
        lastActivePlayButton = nil
    }

    @IBAction func onStopButtonClicked() {
        stopAudio()
    }
}
