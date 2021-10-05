//
//  ReportView.swift
//  daily_report
//
//  Created by Atsushi on 2021/10/05.
//

import SwiftUI
import NCMB

struct ReportView: View {
    @State private var date = Date()            // 検索対象の日付
    @State private var ary: [NCMBObject]? = nil // 検索結果のNCMBObject（配列）
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                if self.ary == nil {
                    VStack {
                        // 検索対象を指定（日報の日付）
                        DatePicker("日付を選択してください",
                            selection: $date,
                            displayedComponents: .date
                        )
                        // 検索実行
                        Button(action: {
                            search()
                        }, label: {
                            Text("日報を表示")
                        })
                    }
                } else {
                    // 検索結果をリスト表示
                    List {
                        ForEach(self.ary!, id: \.objectId) { report in
                            ReportRowView(report: report)
                        }
                    }
                }
            }
            .navigationBarTitle("日報検索", displayMode: .inline)
            .toolbar {
                // 日付データを消す（最初の状態に戻す）アイコン
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        self.ary = nil
                    }) {
                        Image(systemName: "xmark.circle")
                    }
                    .disabled(self.ary == nil)
                }
            }

        }
    }
    
    // 指定された日付の日報データを検索する関数
    func search() {
        // 検索対象のデータストアのクラス
        var query = NCMBQuery.getQuery(className: "DailyReport")
        // 日付用
        let calendar = Calendar(identifier: .gregorian)
        // 指定された日付の 00:00:00
        let startAt = calendar.startOfDay(for: self.date)
        // 指定された日付 +1 日
        let endAt = calendar.date(byAdding: .day, value: 1, to: startAt)!
        // 指定された日付の範囲（00:00:00以上〜次の日未満）を指定
        query.where(field: "date", greaterThanOrEqualTo: startAt)
        query.where(field: "date", lessThan: endAt)
        // 検索実行
        query.findInBackground(callback: { result in
            // 処理が成功しているか判定
            if case let .success(ary) = result {
                // メインスレッドでデータを適用
                DispatchQueue.main.async {
                    self.ary = ary
                }
            }
        })
    }
}

