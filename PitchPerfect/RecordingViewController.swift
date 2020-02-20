//
//  RecordingViewController.swift
//  PitchPerfect
//
//  Created by Filipe Degrazia on 20/02/20.
//  Copyright © 2020 FilipeDegrazia. All rights reserved.
//

import UIKit
import AVFoundation

class RecordingViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!

    var audioRecorder: AVAudioRecorder!

    enum RecordingState {
        case record, stop
    }

    func configureUI(_ state: RecordingState) {
        switch state {
            case .record:
                recordingLabel.text = "Recording in Progress"
                recordButton.isEnabled = false
                stopRecordingButton.isEnabled = true
            case .stop:
                recordingLabel.text = "Start Recording"
                stopRecordingButton.isEnabled = false
                recordButton.isEnabled = true
        }
    }
    @IBAction func recordAudio(_ sender: Any) {
        configureUI(.record)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let filePath = URL(string: [dirPath, recordingName].joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(.stop)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Error Recording")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playingVC = segue.destination as! PlayingViewController
            let audioURL = sender as! URL
            playingVC.recordedAudioURL = audioURL
        }
    }
}

