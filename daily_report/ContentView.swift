//
//  ContentView.swift
//  daily_report
//
//  Created by Atsushi on 2021/10/04.
//

import SwiftUI
import NCMB

struct ContentView: View {
    var body: some View {
        TabView {
            InputView()
                .tabItem {
                    VStack {
                        Image(systemName: "pencil")
                        Text("入力")
                    }
            }.tag(1)
            ReportView()
                .tabItem {
                    VStack {
                        Image(systemName: "list.bullet")
                        Text("レポート")
                    }
            }.tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
