//
//  TimerViewController.swift
//  CustomTimer
//
//  Created by Eldor Makkambayev on 16.12.2023.
//

import UIKit
import AudioToolbox

class TimerViewController: UIViewController {
    
    var selectedSecs: Int = 0
    var countdownTimerDidStart = false
    
    lazy var countdownTimer: CountdownTimer = {
        let countdownTimer = CountdownTimer()
        return countdownTimer
    }()
    
    @IBOutlet weak var progressBar: ProgressBar!
    private var timeLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .light)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    private var stopButton: UIButton = {
        var button = UIButton()
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.contentMode = .scaleToFill
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
        button.setTitle("STOP", for: .normal)
        return button
    }()
    private var startButton: UIButton = {
        var button = UIButton()
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.contentMode = .scaleToFill
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
        button.setTitle("SET", for: .normal)
        return button
    }()
    private var timePicker: TimePickerView = {
        var picker = TimePickerView()
        picker.isHidden = true
        picker.backgroundColor = .white
        picker.layer.cornerRadius = 30
        picker.layer.masksToBounds = true
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureButtons()
        countdownTimer.delegate = self
        timePicker.output = self
        countdownTimer.stopTimer()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        [
            timeLabel,
            stopButton,
            startButton,
            timePicker
        ].forEach { subview in
            view.addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            
            timeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeLabel.widthAnchor.constraint(equalToConstant: 300),
            timeLabel.heightAnchor.constraint(equalToConstant: 40),
            
            stopButton.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -20),
            stopButton.widthAnchor.constraint(equalToConstant: 170),
            stopButton.heightAnchor.constraint(equalToConstant: 50),
            stopButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            
            startButton.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 20),
            startButton.widthAnchor.constraint(equalToConstant: 170),
            startButton.heightAnchor.constraint(equalToConstant: 50),
            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            
            timePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            timePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configureButtons() {
        stopButton.isEnabled = false
        stopButton.alpha = 0.5
        stopButton.addTarget(self, action: #selector(stopAction), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(startAction), for: .touchUpInside)
    }
        
    @objc func startAction() {
        if selectedSecs == 0 {
            timePicker.isHidden = false
            startButton.setTitle("START",for: .normal)
            return
        }

        stopButton.isEnabled = true
        stopButton.alpha = 1.0
        timePicker.isHidden = true
        
        if !countdownTimerDidStart {
            countdownTimer.startTimer()
            progressBar.start()
            countdownTimerDidStart = true
            startButton.setTitle("PAUSE",for: .normal)
        } else {
            countdownTimer.pauseTimer()
            progressBar.pause()
            countdownTimerDidStart = false
            startButton.setTitle("RESUME",for: .normal)
        }
    }
    
    @objc func stopAction() {
        selectedSecs = 0
        countdownTimer.stopTimer()
        progressBar.stop()
        countdownTimerDidStart = false
        stopButton.isEnabled = false
        stopButton.alpha = 0.5
        startButton.setTitle("SET",for: .normal)
    }
}

extension TimerViewController: CountdownTimerDelegate {
    func countdownTimerDone() {
        selectedSecs = 0
        countdownTimerDidStart = false

        stopButton.isEnabled = false
        stopButton.alpha = 0.5
        startButton.setTitle("SET",for: .normal)
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    func countdownTime(time: String) {
        timeLabel.text = time
    }
}

extension TimerViewController: TimePickerViewOutput {
    func updateTime(hour: Int, minute: Int, seconds: Int) {
        let hoursToSeconds = hour * 3600
        let minutesToSeconds = minute * 60
        let secondsToSeconds = seconds
        selectedSecs = hoursToSeconds+minutesToSeconds+secondsToSeconds
        countdownTimer.setTimer(hours: hour, minutes: minute, seconds: seconds)
        progressBar.setProgressBar(hours: hour, minutes: minute, seconds: seconds)
    }
}
