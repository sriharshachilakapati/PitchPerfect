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
    private var recordedFile: URL!

    override func viewWillAppear(_ animated: Bool) {
        stopButton.isEnabled = false
        recordButton.isEnabled = true
        statusLabel.text = "Record"
    }

    private func doRecordAudio() {
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                self.doRecordAudio()
            }

            return
        }

        statusLabel.text = "Recording"
        recordButton.isEnabled = false
        stopButton.isEnabled = true

        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let recordingName = "recordedVoice.wav"
        let paths = [ dir, recordingName ]
        recordedFile = URL(string: paths.joined(separator: "/"))

        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: recordedFile!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func onRecordButtonClicked() {
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
            case .authorized:
                doRecordAudio()

            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .audio) { granted in
                    if granted {
                        self.doRecordAudio()
                    }
                }

            case .denied, .restricted:
                let alertController = UIAlertController(title: "Permission Required",
                                                        message: "We require audio permission for this app. Please go to settings and give the permission to record audio.",
                                                        preferredStyle: .alert)

                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }

                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl) { success in }
                    }
                }

                alertController.addAction(cancelAction)
                alertController.addAction(settingsAction)
                self.present(alertController, animated: true)

            @unknown default:
                return
        }
    }

    @IBAction func onStopRecordingButtonClicked() {
        statusLabel.text = "Record"
        stopButton.isEnabled = false
        recordButton.isEnabled = true

        audioRecorder.stop()
        try! AVAudioSession.sharedInstance().setActive(false)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPlaybackScreen" {
            let destinationController = segue.destination as! AudioPlaybackViewController
            destinationController.recordedFile = recordedFile
        }
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        performSegue(withIdentifier: "toPlaybackScreen", sender: nil)
    }
}

