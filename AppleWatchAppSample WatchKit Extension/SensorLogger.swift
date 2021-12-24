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
    
    var buckupAccX = 0.0
    var buckupAccY = 0.0
    var buckupAccZ = 0.0
    var buckupGyrX = 0.0
    var buckupGyrY = 0.0
    var buckupGyrZ = 0.0
    
    var isSound = false
    
    private let sound1 = try! AVAudioPlayer(data: NSDataAsset(name: "nc154037")!.data)
    private let sound2 = try! AVAudioPlayer(data: NSDataAsset(name: "nc154038")!.data)
    private let sound3 = try! AVAudioPlayer(data: NSDataAsset(name: "nc154039")!.data)
    private let sound4 = try! AVAudioPlayer(data: NSDataAsset(name: "nc154040")!.data)
    private let sound5 = try! AVAudioPlayer(data: NSDataAsset(name: "nc166939")!.data)
    
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
        
        
        
        if (abs(buckupGyrX - self.gyrX)) >= 1.0
        {
            isSound = true
            print("GyrX: AAAAAAA")
            print("Watch: acc (\(self.accX), \(self.accY), \(self.accZ)), gyr (\(self.gyrX), \(self.gyrY), \(self.gyrZ)) ")
//            sound1.play()
        }
        buckupGyrX = self.gyrX
        if (abs(buckupGyrY - self.gyrY)) >= 1.0
        {
            isSound = true
            print("GyrY: BBBBBBB")
            print("Watch: acc (\(self.accX), \(self.accY), \(self.accZ)), gyr (\(self.gyrX), \(self.gyrY), \(self.gyrZ)) ")
//            sound2.play()
        }
        buckupGyrY = self.gyrY
        if (abs(buckupGyrZ - self.gyrZ)) >= 1.0
        {
            isSound = true
            print("GyrZ: CCCCCCC")
            print("Watch: acc (\(self.accX), \(self.accY), \(self.accZ)), gyr (\(self.gyrX), \(self.gyrY), \(self.gyrZ)) ")
//            sound3.play()
        }
        buckupGyrZ = self.gyrZ
        if (abs(buckupAccX - self.accX)) >= 0.5
        {
            isSound = true
            print("AccX: DDDDDDD")
            print("Watch: acc (\(self.accX), \(self.accY), \(self.accZ)), gyr (\(self.gyrX), \(self.gyrY), \(self.gyrZ)) ")
//            sound4.play()
        }
        buckupAccX = self.accX
        if (abs(buckupAccY - self.accY)) >= 0.5
        {
            isSound = true
            print("AccY: EEEEEE")
            print("Watch: acc (\(self.accX), \(self.accY), \(self.accZ)), gyr (\(self.gyrX), \(self.gyrY), \(self.gyrZ)) ")
//            sound5.play()
        }
        buckupAccY = self.accY
        if (abs(buckupAccZ - self.accZ)) >= 0.5
        {
            isSound = true
            print("AccZ: FFFFFFFF")
            print("Watch: acc (\(self.accX), \(self.accY), \(self.accZ)), gyr (\(self.gyrX), \(self.gyrY), \(self.gyrZ)) ")
//            sound1.play()
        }
        buckupAccZ = self.accZ
        if(isSound){
            let randomInt = Int.random(in: 1..<5)
            switch randomInt {
            case 1:
                sound1.play()
            case 2:
                sound2.play()
            case 3:
                sound3.play()
            case 4:
                sound4.play()
            case 5:
                sound5.play()
            default:
                sound1.play()
            }
            isSound = false
        }
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
