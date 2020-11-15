//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Sri Harsha Chilakapati on 15/11/20.
//

import UIKit
import AVFoundation

class AudioRecordingViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!

    private var audioRecorder: AVAudioRecorder!

    override func viewWillAppear(_ animated: Bool) {
        stopButton.isEnabled = false
        recordButton.isEnabled = true
        statusLabel.text = "Record"
    }

    @IBAction func onRecordButtonClicked() {
        statusLabel.text = "Recording"
        recordButton.isEnabled = false
        stopButton.isEnabled = true

        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let recordingName = "recordedVoice.wav"
        let paths = [ dir, recordingName ]
        let filePath = URL(string: paths.joined(separator: "/"))

        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func onStopRecordingButtonClicked() {
        statusLabel.text = "Record"
        stopButton.isEnabled = false
        recordButton.isEnabled = true

        audioRecorder.stop()
        try! AVAudioSession.sharedInstance().setActive(false)
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        // TODO: Implement
    }
}

