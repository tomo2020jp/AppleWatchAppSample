//
//  ContentView.swift
//  AppleWatchAppSample WatchKit Extension
//
//  Created by tomohiko on 2021/12/19.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var logStarting = false
    
    @ObservedObject var sensorLogger = SensorLogManager()
    
    private let beginSound = try!  AVAudioPlayer(data: NSDataAsset(name: "nc154033")!.data)
    private let endSound = try!  AVAudioPlayer(data: NSDataAsset(name: "nc154034")!.data)
    
    var body: some View {
        VStack{
            Button(action: {
                self.logStarting.toggle()
                
                if self.logStarting{
                    self.sensorLogger.startUpdate(50.0)
                    beginSound.play()
                }
                else{
                    self.sensorLogger.stopUpdate()
                    endSound.play()
                }
            }){
                if self.logStarting{
                    Image(systemName: "pause.circle")
                }
                else{
                    Image(systemName: "play.circle")
                }
            }
            
            VStack{
                VStack{
                    Text("Accelerometer").font(.headline)
                    HStack{
                        Text(String(format: "%.2f", self.sensorLogger.accX))
                        Spacer()
                        Text(String(format: "%.2f", self.sensorLogger.accY))
                        Spacer()
                        Text(String(format: "%.2f", self.sensorLogger.accZ))
                    }.padding(.horizontal)
                }
                VStack{
                    Text("Gyroscope").font(.headline)
                    HStack{
                        Text(String(format: "%.2f", self.sensorLogger.gyrX))
                        Spacer()
                        Text(String(format: "%.2f", self.sensorLogger.gyrY))
                        Spacer()
                        Text(String(format: "%.2f", self.sensorLogger.gyrZ))
                    }.padding(.horizontal)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
