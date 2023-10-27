//
//  SpeedometerViewModel.swift
//  SimpleSpeedometer
//
//  Created by TAEHYOUNG KIM on 10/18/23.
//

import Foundation
import Combine
import CoreLocation

class SpeedometerViewModel {
    private let locationManager = LocationManager()
    private let settingManager = SettingManager()
    private let stopwatch = Stopwatch()
    private var subscriptions = Set<AnyCancellable>()

    var speed: Double {
        locationManager.speed.speedToSelectedUnit(unitOfSpeed ?? .kmh)
    }

    var distance: Double {
        locationManager.distance.distanceToSelectedUnit(unitOfSpeed ?? .kmh)
    }

    var topSpeed: Double {
        locationManager.topSpeed.speedToSelectedUnit(unitOfSpeed ?? .kmh)
    }

    var averageSpeed: Double {
        locationManager.averageSpeed.speedToSelectedUnit(unitOfSpeed ?? .kmh)
    }

    var currentAltitude: Double {
        locationManager.currentAltitude.altitudeToSelectedUnit(unitOfSpeed ?? .kmh)
    }

    var altitude: Double {
        locationManager.altitude.altitudeToSelectedUnit(unitOfSpeed ?? .kmh)
    }

    @Published var isPaused: Bool = true
    @Published var unitOfSpeed: UnitOfSpeed?
    @Published var isLocationDisable = false

    @Published var totalElapsedTime = 0

    var hhmmss: String {
        stopwatch.hhmmss
    }

    var resultTime: String {
        stopwatch.resultTime
    }

    init() {
        bind()
    }

    private func bind() {
        stopwatch.$count
            .sink { count in
                self.totalElapsedTime = count
            }.store(in: &subscriptions)

        settingManager.$unit
            .sink { unit in
                self.unitOfSpeed = unit
            }.store(in: &subscriptions)
    }


    func updateUnit(_ unit: UnitOfSpeed) {
        settingManager.updateUnit(unit)
    }

    func startAndPause() {
        if isPaused {
            locationManager.start()
            stopwatch.start()
            isPaused = false
        } else {
            locationManager.stop()
            stopwatch.pause()
            isPaused = true
        }
    }

    func stop() {
        locationManager.stop()
        stopwatch.stop()
        locationManager.speed = 0
        locationManager.speeds = []
        locationManager.altitude = 0
        locationManager.distance = 0
        locationManager.topSpeed = 0
        locationManager.averageSpeed = 0
        locationManager.currentAltitude = 0
        isPaused = true
    }

    func locationManagerDidChangeAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:  // Location services are available.
            startAndPause()
            break

        case .restricted, .denied:  // Location services currently unavailable.
            isLocationDisable = true
            break

        case .notDetermined:        // Authorization not determined yet.
            locationManager.requestAuthorization()
            break

        default:
            break
        }
    }

   func calculateDistance() -> CLLocationDistance {
        let totalDistance = averageSpeed * Double(stopwatch.count) / 3600
       print("distance: \(distance)")
       print("calculat: \(totalDistance)")
       return totalDistance
    }
}
