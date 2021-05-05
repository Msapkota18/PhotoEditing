//
//  MotionVC.swift
//  PhotoEditing
//
//  Created by Mahesh Sapkota, Sarad Poudel and Kritartha Kafle on 04/25/21.

import UIKit

import CoreMotion

class MotionVC: UIViewController {

    @IBOutlet weak var aX: UILabel!
    @IBOutlet weak var aY: UILabel!
    @IBOutlet weak var aZ: UILabel!
    @IBOutlet weak var gX: UILabel!
    @IBOutlet weak var gY: UILabel!
    @IBOutlet weak var gZ: UILabel!
    @IBOutlet weak var mX: UILabel!
    @IBOutlet weak var mY: UILabel!
    @IBOutlet weak var mZ: UILabel!
    
    let motionManager = CMMotionManager()
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        motionManager.startAccelerometerUpdates()
        motionManager.startGyroUpdates()
        motionManager.startMagnetometerUpdates()
        motionManager.startDeviceMotionUpdates()
        update()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    @objc func update() {
        if let accelerometerData = motionManager.accelerometerData {
            aX.text = "\(accelerometerData.acceleration.x)"
            aY.text = "\(accelerometerData.acceleration.y)"
            aZ.text = "\(accelerometerData.acceleration.z)"
        }
        if let gyroData = motionManager.gyroData {
            gX.text = "\(gyroData.rotationRate.x)"
            gY.text = "\(gyroData.rotationRate.y)"
            gZ.text = "\(gyroData.rotationRate.z)"
        }
        if let magnetometerData = motionManager.magnetometerData {
            mX.text = "\(magnetometerData.magneticField.x)"
            mY.text = "\(magnetometerData.magneticField.y)"
            mZ.text = "\(magnetometerData.magneticField.z)"
        }
        
        if let deviceMotion = motionManager.deviceMotion {
            print(deviceMotion)
        }
    }

}
