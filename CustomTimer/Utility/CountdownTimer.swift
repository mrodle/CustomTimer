//
//  CountdownTimer.swift
//  CustomTimer
//
//  Created by Eldor Makkambayev on 16.12.2023.
//

import UIKit

protocol CountdownTimerDelegate: AnyObject {
    func countdownTimerDone()
    func countdownTime(time: String)
}

class CountdownTimer {
    
    weak var delegate: CountdownTimerDelegate?
    
    private var mainQueue = DispatchQueue.main
    private var queue: DispatchQueue?
    private var seconds = 0
    private var duration = 0
    
    public func setTimer(hours: Int, minutes: Int, seconds: Int) {
        let hoursToSeconds = hours * 3600
        let minutesToSeconds = minutes * 60
        let secondsToSeconds = seconds
        
        let seconds = secondsToSeconds + minutesToSeconds + hoursToSeconds
        self.seconds = seconds
        self.duration = seconds
        
        delegate?.countdownTime(time: formatTime(seconds: seconds))
    }
    
    public func startTimer() {
        queue = mainQueue
        updateTimer()
    }
    
    public func stopTimer() {
        queue = nil
        delegate?.countdownTime(time: formatTime(seconds: 0))
    }
    
    public func pauseTimer() {
        queue = nil
    }
    
    private func timerTick() {
        duration -= 1
        if duration <= 0 {
            timerDone()
        }
    }
    
    private func timerDone() {
        stopTimer()
        delegate?.countdownTimerDone()
    }
    
    private func updateTimer() {
        queue?.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self, self.queue != nil else { return }
            self.timerTick()
            self.delegate?.countdownTime(time: self.formatTime(seconds: self.duration))
            self.updateTimer()
        }
    }
    
    private func formatTime(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = seconds % 60
        
        let formattedTime = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        return formattedTime
    }
    
    private func timeToSeconds(hours: Int, minutes: Int, seconds: Int) -> Int {
        return hours * 3600 + minutes * 60 + seconds
    }
}
