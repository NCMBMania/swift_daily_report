//
//  ReportRowView.swift
//  daily_report
//
//  Created by Atsushi on 2021/10/05.
//

import SwiftUI
import NCMB

struct ReportRowView: View {
    @State var report:NCMBObject // 表示する日報データ
    @State var imageData : Data = .init(capacity:0) // 日報に紐付いた画像データ
    
    var body: some View {
        // タップした際にの遷移
        NavigationLink(destination: DetailView(obj: report, imageData: $imageData)) {
            HStack(alignment: .top) {
                Spacer().frame(width: 10)
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        VStack {
                            // 画像データの有無を確認
                            if self.imageData.count == 0 {
                                // ないときにはダミー画像
                                Image(systemName: "photo")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .scaledToFit()
                            } else {
                                // 画像があれば表示
                                Image(uiImage: UIImage(data: self.imageData)!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60, height: 60)
                            }
                        }
                        VStack(alignment: .leading) {
                            // 日報本文の一部を表示
                            Text((self.report["text"] ?? "") as! String)
                                .lineLimit(3)
                        }
                    }
                }
                Spacer()
            }
            .onAppear {
                // 画面が表示されたタイミングで画像を読み込む
                loadImage()
            }
        }
    }
    
    // 画像を読み込む関数
    func loadImage() {
        // ファイル名
        let fileName = self.report["fileName"] ?? ""
        // ファイル名の指定があれば続行
        if fileName != "" {
            // ファイルストアのオブジェクトを作成
            let file = NCMBFile(fileName: fileName)
            // データをダウンロード
            file.fetchInBackground(callback: { result in
                // 処理結果を判定
                if case let .success(data) = result {
                    // うまくいっていればメインスレッドでデータを適用
                    DispatchQueue.main.async {
                        self.imageData = data!
                    }
                }
            })
        }
    }
}
