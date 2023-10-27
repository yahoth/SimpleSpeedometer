//
//  Stopwatch.swift
//  Stopwatch
//
//  Created by TAEHYOUNG KIM on 10/18/23.
//

import Foundation
import Combine

class Stopwatch: ObservableObject {

    private var timer: AnyCancellable?
    @Published var count = 0
//    @Published var isDisplayingTimeInHHMMSS: Bool = true
//    @Published var isPaused: Bool = true

    /// hh:mm:ss
    var hhmmss: String {
        let hours = count / 3600
        let minutes = (count % 3600) / 60
        let seconds = (count % 3600) % 60

        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    /// 1시간
    /// 1시간 1분
    /// 1분 48초
    /// 1분
    /// 48초
    var resultTime: String {
        let hours = count / 3600
        let minutes = (count % 3600) / 60
        let seconds = (count % 3600) % 60

        if hours > 0 && minutes > 0 {
            return "\(hours)시간 \(minutes)분"
        } else if hours > 0 {
            return "\(hours)시간"
        } else if minutes > 0 && seconds > 0 {
            return "\(minutes)분 \(seconds)초"
        } else if minutes > 0 {
            return "\(minutes)분"
        } else {
            return "\(seconds)초"
        }
    }

    func start() {
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.count += 1
            }
//        isPaused = false
    }

    func pause() {
        timer?.cancel()
//        isPaused = true
    }

    func stop() {
        timer?.cancel()
        timer = nil
        count = 0
//        isDisplayingTimeInHHMMSS = true
//        isPaused = true
    }
}
