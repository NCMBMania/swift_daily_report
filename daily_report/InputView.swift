//
//  InputView.swift
//  daily_report
//
//  Created by Atsushi on 2021/10/05.
//

import SwiftUI
import NCMB

struct InputView: View {
    @State private var date = Date()     // 日報の日付
    @State private var text = ""         // 日報の本文
    @State private var showAlert = false // アラート表示用のフラグ
    @State private var message = ""      // アラートのメッセージ
    
    @State var imageData : Data = .init(capacity:0) // // 選択された写真データ
    @State var source:UIImagePickerController.SourceType = .photoLibrary // カメラまたはフォトライブラリ
    @State var isImagePicker = false // 写真ピッカーを表示する際のフラグ
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                // 画像モーダルへの遷移用
                NavigationLink(
                    destination: Imagepicker(
                        show: $isImagePicker,
                        image: $imageData,
                        sourceType: source
                    ),
                    isActive:$isImagePicker,
                    label: {
                        Text("")
                    })
                // 日報の日付を選択
                DatePicker("日付",
                    selection: $date,
                    displayedComponents: .date
                )
                // 日報の内容を記述するTextEditor
                TextEditor(text: $text)
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: 200)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.blue, lineWidth: 2)
                    )
                // 画像が指定されれば、サムネイル表示
                if imageData.count != 0 {
                    Image(uiImage: UIImage(data: self.imageData)!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 100)
                        .cornerRadius(15)
                        .padding()
                }
                // 写真選択モーダルの表示
                Button(action: {
                    self.source = .photoLibrary
                    self.isImagePicker.toggle()
                }, label: {
                    Text("写真を選択")
                })
            }
            .navigationBarTitle("日報入力", displayMode: .inline)
            .toolbar {
                // 右上のアイコンで保存しょりを実行
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        save()
                    }) {
                        Image(systemName: "icloud.and.arrow.up")
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(self.message))
        }
    }
    
    // 日報を保存する処理
    func save() {
        // DailyReportクラス（DBでいうテーブル相当）のインスタンス（DBでいう行相当）を準備
        let obj = NCMBObject(className: "DailyReport")
        // 指定されている値をセット
        obj["text"] = self.text
        obj["date"] = self.date
        // 画像があるか判断
        if self.imageData.count > 0 {
            // 画像があれば、ファイルストアへ保存する
            // ファイル名はUUIDで生成
            let fileName = "\(UUID()).jpg"
            // ファイルストアのインスタンスを準備
            let file = NCMBFile(fileName: fileName)
            // 保存（ファイルストアへのアップロード）
            _ = file.save(data: self.imageData)
            // ファイル名をDailyReportクラスのインスタンスに紐付ける
            obj["fileName"] = fileName
        }
        // データを保存（データストアにアップロード）
        let result = obj.save()
        // 結果を判定
        switch result {
        case .success(): // 保存がうまくいったら、入力内容をリセット
            self.text = ""
            self.imageData.count = 0
            self.date = Date()
            // メッセージを設定
            self.message = "保存しました"
            break
        case let .failure(err): // エラーの場合はエラーメッセージをセット
            self.message = err.localizedDescription
            break
        }
        // アラートを表示
        self.showAlert = true
    }
}
