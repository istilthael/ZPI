//
//  MainViewController.swift
//  Antybec
//
//  Created by Wiktor Biruk on 04/04/2019.
//  Copyright © 2019 Wiktor Biruk. All rights reserved.
//

import UIKit
import SensingKit
import AudioToolbox

class MainViewController: UIViewController {

    @IBOutlet weak var aFactorIndicator: SliderIndicatorView!
    @IBOutlet weak var bFactorIndicator: SliderIndicatorView!
    //@IBOutlet weak var cFactorIndicator: SliderIndicatorView!
    @IBOutlet weak var indicatorsContainerView: UIStackView!

    let sensingKit = SensingKitLib.shared()
    let recognizer = Recognizer()

    let factorABorders = (0.5, 0.7)
    let factorBBorders = (0.2, 0.4)
    let factorCBorders = (0.3, 0.7)

    var state: WalkState = .normal
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startAccelerometer()
        startGyroscope()
        //startMagnetometer()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let aFactoriViewModel = SliderIndicatorViewModel(indicatorDescription: "Factor A",
                                                         topLevelValue: 0.7,
                                                         bottomLevelValue: 0.5,
                                                         initialLevelValue: 0.75)
        aFactorIndicator.configure(withViewModel: aFactoriViewModel)

        let bFactoriViewModel = SliderIndicatorViewModel(indicatorDescription: "Factor B",
                                                         topLevelValue: 0.6,
                                                         bottomLevelValue: 0.2,
                                                         initialLevelValue: 0.8)
        bFactorIndicator.configure(withViewModel: bFactoriViewModel)

//        let cFactoriViewModel = SliderIndicatorViewModel(indicatorDescription: "Factor C",
//                                                         topLevelValue: 0.7,
//                                                         bottomLevelValue: 0.3,
//                                                         initialLevelValue: 0.85)
//        cFactorIndicator.configure(withViewModel: cFactoriViewModel)
    }

    // MARK: - Sensors
    private func startAccelerometer() {
        try! sensingKit.register(.Accelerometer)

        try! sensingKit.subscribe(to: .Accelerometer) { [weak self] (sensorType, data, error) in
            let accelerometerData = data as! SKAccelerometerData
            let result = self?.recognizer.findPathologyWithNextSensorsLoad(accZ: accelerometerData.acceleration.z, gyrZ: nil, mag: nil) ?? 0.0
            self?.checkResult(result, forBorders: self?.factorABorders)
            self?.aFactorIndicator.setCurrentLevel(result)
        }

        let configuration = SKAccelerometerConfiguration()
        configuration.sampleRate = UInt(Constants.frequency)
        try! sensingKit.setConfiguration(configuration, to: .Accelerometer)
        try! sensingKit.startContinuousSensing(with: .Accelerometer)
    }

    private func startGyroscope() {
        try! sensingKit.register(.Gyroscope)

        try! sensingKit.subscribe(to: .Gyroscope) { [weak self] (sensorType, data, error) in
            let gyroscopeData = data as! SKGyroscopeData
            let result = self?.recognizer.findPathologyWithNextSensorsLoad(accZ: nil, gyrZ: gyroscopeData.rotationRate.z, mag: nil) ?? 0.0
            self?.checkResult(result, forBorders: self?.factorBBorders)
            self?.bFactorIndicator.setCurrentLevel(result)
        }

        let configuration = SKGyroscopeConfiguration()
        configuration.sampleRate = 4
        try! sensingKit.setConfiguration(configuration, to: .Gyroscope)
        try! sensingKit.startContinuousSensing(with: .Gyroscope)
    }

//    private func startMagnetometer() {
//        try! sensingKit.register(.Magnetometer)
//
//        try! sensingKit.subscribe(to: .Magnetometer) { [weak self] (sensorType, data, error) in
//            let magnetometerData = data as! SKMagnetometerData
//            let result = self?.recognizer.findPathologyWithNextSensorsLoad(accZ: nil, gyrZ: nil, mag: magnetometerData.magneticField.z) ?? 0.0
//            self?.checkResult(result, forBorders: self?.factorCBorders)
//            self?.cFactorIndicator.setCurrentLevel(result)
//        }
//
//        let configuration = SKMagnetometerConfiguration()
//        configuration.sampleRate = 4
//        try! sensingKit.setConfiguration(configuration, to: .Magnetometer)
//        try! sensingKit.startContinuousSensing(with: .Magnetometer)
//    }

    private func checkResult(_ result: Double, forBorders borders: (Double, Double)?) {
        guard let borders = borders else { return }
        var state: WalkState = .normal
        if borders.0 ..< borders.1 ~= result {
            state = .warning
        } else if result < borders.0 {
            state = .critical
        }
        if state != self.state {
            self.state = state
            updateScreen(forWalkState: state)
            vibrate()
            ring()
        }
    }

    func updateScreen(forWalkState walkState: WalkState) {
        DispatchQueue.main.async {
            switch walkState {
            case .normal:
                self.view.backgroundColor = Colors.defaultBackgroundColor
            case .warning:
                self.view.backgroundColor = Colors.warningBackgroundColor
            case .critical:
                self.view.backgroundColor = Colors.criticalBackgroundColor
            }
            self.aFactorIndicator.setState(walkState)
            self.bFactorIndicator.setState(walkState)
           // self.cFactorIndicator.setState(walkState)
        }
    }

    func vibrate() {
        switch state {
        case .normal:
            break
        case .warning:
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        case .critical:
            var counter = 0
            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { timer in
                if counter == 3 {
                    timer.invalidate()
                    return
                }
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                counter += 1
            }
        }
    }

    func ring() {
        switch state {
        case .normal:
            break
        case .warning:
            AudioServicesPlaySystemSound(1005);
        case .critical:
            AudioServicesPlaySystemSound(1006);
        }
    }

}
