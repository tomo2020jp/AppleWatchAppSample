//
//  SensorLogger.swift
//  GyroSample WatchKit Extension
//
//  Created by Tomohiko Aono on 2021/12/10.
//

import SwiftUI
import Foundation
import CoreMotion
import Combine
import AVFoundation

class SensorLogManager: NSObject, ObservableObject{
    var motionManager: CMMotionManager?
    
    @Published var accX = 0.0
    @Published var accY = 0.0
    @Published var accZ = 0.0
    @Published var gyrX = 0.0
    @Published var gyrY = 0.0
    @Published var gyrZ = 0.0
    
    private var samplingFrequency = 50.0
    
    var timer = Timer()
    
    var bkParam = 0.0
    
    private let sound = try!  AVAudioPlayer(data: NSDataAsset(name: "nc154037")!.data)
    
    override init(){
        super.init()
        self.motionManager = CMMotionManager()
    }
    
    @objc private func startLogSensor(){
        
        if let data = motionManager?.accelerometerData{
            let x = data.acceleration.x
            let y = data.acceleration.y
            let z = data.acceleration.z
            
            self.accX = x
            self.accY = y
            self.accZ = z
        }
        else{
            self.accX = Double.nan
            self.accY = Double.nan
            self.accZ = Double.nan
        }
        
        if let data = motionManager?.deviceMotion{
            let x = data.rotationRate.x
            let y = data.rotationRate.y
            let z = data.rotationRate.z
            
            self.gyrX = x
            self.gyrY = y
            self.gyrZ = z
        }
        else{
            self.gyrX = Double.nan
            self.gyrY = Double.nan
            self.gyrZ = Double.nan
        }
        
        print("Watch: acc (\(self.accX), \(self.accY), \(self.accZ)), gyr (\(self.gyrX), \(self.gyrY), \(self.gyrZ)) ")
        
        if (abs(bkParam - self.gyrY)) >= 1.0
        {
            sound.play()
        }
        bkParam = self.gyrY
    }
    
    func startUpdate(_ freq: Double){
        if motionManager!.isAccelerometerAvailable{
            motionManager?.startAccelerometerUpdates()
        }
        
        // Gyroscopeの生データの代わりにDeviceMotionのrotationRateを取得してるらしい
        if motionManager!.isDeviceMotionAvailable{
            motionManager?.startDeviceMotionUpdates()
        }
        
        self.samplingFrequency = freq
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0 / freq, target: self, selector: #selector(self.startLogSensor), userInfo: nil, repeats: true)
    }
    
    func stopUpdate(){
        self.timer.invalidate()
        
        if motionManager!.isAccelerometerActive{
            motionManager?.stopAccelerometerUpdates()
        }
        
        if motionManager!.isGyroActive{
            motionManager?.stopGyroUpdates()
        }
    }
}
