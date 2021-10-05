//
//  daily_reportApp.swift
//  daily_report
//
//  Created by Atsushi on 2021/10/04.
//

import SwiftUI
import NCMB

@main
struct daily_reportApp: App {
    var body: some Scene {
            WindowGroup {
                VStack {
                    ContentView()
                }.onAppear() {
                    let applicationKey = "e76f28a5942879acca4ee786a8a56eb6ecd27235f9fa14bd030a3a1f19203916"
                    let clientKey = "a1ce27c976764780a05c39033d27de52598a8276abafc340eb01d17f751183ca"
                    NCMB.initialize(applicationKey: applicationKey, clientKey: clientKey)
                }
            }
    }
}
