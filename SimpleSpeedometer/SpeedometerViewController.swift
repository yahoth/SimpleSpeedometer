//
//  SpeedometerViewController.swift
//  SimpleSpeedometer
//
//  Created by TAEHYOUNG KIM on 10/12/23.
//

import UIKit
import Combine

class SpeedometerViewController: UIViewController {

    let vm = SpeedometerViewModel()
    var subscriptions = Set<AnyCancellable>()
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var topSpeedLabel: UILabel!
    @IBOutlet weak var averageSpeedLabel: UILabel!
    @IBOutlet weak var currentAltitude: UILabel!


    @IBOutlet weak var unitOfCurrentSpeedLabel: UILabel!
    @IBOutlet weak var unitOfAvgSpeedLabel: UILabel!
    @IBOutlet weak var unitOfTopSpeedLabel: UILabel!
    @IBOutlet weak var unitOfDistanceLabel: UILabel!
    @IBOutlet weak var unitOfCurrentAltitudeLabel: UILabel!
    @IBOutlet weak var unitOfAltitudeLabel: UILabel!


    @IBOutlet weak var containerOfAvgSpeed: UIView!
    @IBOutlet weak var containerOfTopSpeed: UIView!
    @IBOutlet weak var containerOfTime: UIView!
    @IBOutlet weak var containerOfDistance: UIView!
    @IBOutlet weak var containerOfAltitude: UIView!
    @IBOutlet weak var containerOfCurrentAltitude: UIView!
    
    var changeUnitButton: UIBarButtonItem!
    var startAndPauseButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupChangeUnitButton()
        configureContainer()
        setMonospacedFont()
        bind()
    }

    private func bind() {
        vm.$totalElapsedTime
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.timeLabel.text = self.vm.hhmmss
                self.speedLabel.text = self.vm.speed == 0 ? "0" : String(format: "%.0f", self.vm.speed)
                self.distanceLabel.text = String(format: "%.1f", self.vm.distance)
                self.averageSpeedLabel.text = String(format: "%.0f", self.vm.averageSpeed)
                self.topSpeedLabel.text = String(format: "%.0f", self.vm.topSpeed)
                self.altitudeLabel.text = String(format: "%.0f", self.vm.altitude)
                self.currentAltitude.text = String(format: "%.0f", self.vm.currentAltitude)
            }.store(in: &subscriptions)

        vm.$isPaused
            .sink { isPaused in
                self.updateStartAndPauseButton(isPaused)
            }.store(in: &subscriptions)

        vm.$unitOfSpeed
            .sink { unit in
                self.updateUnit(unit ?? .kmh)
            }.store(in: &subscriptions)
        
        vm.$isLocationDisable
            .sink { bool in
                if bool {
                    self.showLocationDisabledAlert()
                }
            }.store(in: &subscriptions)
    }

    private func configureContainer() {
        let containers = [ containerOfAvgSpeed, containerOfTopSpeed, containerOfTime, containerOfDistance, containerOfAltitude, containerOfCurrentAltitude ]
        containers.forEach {

            $0?.backgroundColor = .systemGray6
            $0?.layer.cornerRadius = 10

        }
    }

    private func setupChangeUnitButton() {
        let units = UnitOfSpeed.allCases.map { unit in
            UIAction(title: unit.displayedSpeedUnit) { [weak self] _ in
                self?.vm.updateUnit(unit)
            }
        }

        let menu = UIMenu(title: "Select unit of speed", options: .displayInline, children: units)

        changeUnitButton = UIBarButtonItem(title: vm.unitOfSpeed?.displayedSpeedUnit, menu: menu)

        startAndPauseButton = UIBarButtonItem(title: "StartAndPause", style: .done, target: self, action: #selector(startAndPauseButtonTapped2))

        let stopButton = UIBarButtonItem(title: "Stop", image: UIImage(systemName: "stop.fill"), target: self, action: #selector(stopButtonTapped))

        self.navigationItem.rightBarButtonItems = [stopButton, startAndPauseButton]
        self.navigationItem.leftBarButtonItems = [changeUnitButton]
    }

    private func updateStartAndPauseButton(_ isPaused: Bool) {
        let image = UIImage(systemName: isPaused ? "play.fill" : "pause.fill")
        startAndPauseButton.image = image
    }

    @objc func startAndPauseButtonTapped2() {
        vm.locationManagerDidChangeAuthorization()
    }

    @objc func stopButtonTapped() {
        vm.stop()
    }

    private func showLocationDisabledAlert() {
        let alert = UIAlertController(title: "Location Access Disabled",
                                      message: "In order to measure speed we need your location \nSetting -> SimpleSpeedometer -> Location Service",
                                      preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler:nil)

        let openAction = UIAlertAction(title: "Open Settings", style: .default) { action in
            if let url = URL(string:UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            }
        }

        let actions = [cancelAction, openAction]
        actions.forEach { alert.addAction($0) }
        
        self.present(alert, animated:true, completion:nil)
    }
}

extension SpeedometerViewController {
    func setMonospacedFont() {

        let labels = [
            timeLabel,
            altitudeLabel,
            distanceLabel,
            topSpeedLabel,
            averageSpeedLabel,
            currentAltitude,
        ]

        speedLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 100, weight: .bold)

        labels.forEach {
            let largeTitleFont = UIFont.preferredFont(forTextStyle: .largeTitle).pointSize
            $0?.font = UIFont.monospacedDigitSystemFont(ofSize: largeTitleFont, weight: .regular)
        }
    }

    func updateUnit(_ unit: UnitOfSpeed) {
        self.unitOfCurrentSpeedLabel.text = unit.displayedSpeedUnit
        self.unitOfAvgSpeedLabel.text = unit.displayedSpeedUnit
        self.unitOfTopSpeedLabel.text = unit.displayedSpeedUnit
        self.changeUnitButton.title = unit.displayedSpeedUnit

        self.unitOfDistanceLabel.text = unit.correspondingDistanceUnit

        self.unitOfCurrentAltitudeLabel.text = unit.correspondingAltitudeUnit
        self.unitOfAltitudeLabel.text = unit.correspondingAltitudeUnit
    }
}
