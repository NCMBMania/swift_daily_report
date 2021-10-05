//
//  DetailView.swift
//  daily_report
//
//  Created by Atsushi on 2021/10/05.
//

import SwiftUI
import NCMB

// 日報の詳細表示用View
struct DetailView: View {
    @State var obj: NCMBObject    // 日報用データストアのオブジェクト
    @Binding var imageData : Data // 日報に添付されていた画像データ
    
    var body: some View {
        VStack {
            // 画像データがあれば表示
            if self.imageData.count > 0 {
                Image(uiImage: UIImage(data: self.imageData)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
            }
            // 日報の本文
            Text((obj["text"] ?? "") as! String)
        }
        // タイトルに日付を表示
        .navigationBarTitle(dateTitle(), displayMode: .inline)
    }
    
    // タイトルに出す内容を作成する
    func dateTitle() -> String {
        // 日付フォーマットの作成
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "M月d日の日報"
        // 日報データの日付を使ってタイトルを作成
        return dateFormatter.string(from: (obj["date"] ?? Date()) as! Date)
    }
}
