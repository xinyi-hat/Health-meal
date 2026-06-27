import SwiftUI
import FirebaseAILogic
struct AiView: View {
    @State private var image: UIImage?
    @State private var showCamera: Bool = false
    @State private var airesult: String = ""
    @State private var isAnalyzing: Bool = false
    @AppStorage("mealRecords") private var mealRecordsData: Data = Data()
    
    private let model = FirebaseAI
        .firebaseAI(backend: .googleAI())
        .generativeModel(modelName: "gemini-2.5-flash")
    
    private var records: [MealRecord] {
        (try? JSONDecoder().decode([MealRecord].self, from: mealRecordsData)) ?? []
    }
    
    private func saveRsult(){
        let newRecord = MealRecord(
            date: Date(),
            result: airesult
        )
        var current = records
        current.append(newRecord)
        
        if let encoded = try? JSONEncoder().encode(current) {
            mealRecordsData = encoded
        }
    }
    
    
    var body: some View {
        VStack(spacing: 20) {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 300)
                    .overlay(Text("写真を撮ってください"))
            }
            Button("写真を撮る"){
                showCamera = true
            }
            if image != nil {
                Button("AI分析"){
                    Task{
                        await analyzeImage()
                    }
                }
                .disabled(isAnalyzing)
            }
            if isAnalyzing {
                ProgressView("AIが分析しています")
            } else if !airesult.isEmpty {
                ScrollView{
                    Text(airesult)
                        .padding(.leading, 15)
                }
            }
            Button("保存") {
                saveRsult()
                airesult = "保存完了"
            }
            .buttonStyle(.bordered)
        }
        .sheet(isPresented: $showCamera) {
            ImagePicker(image: $image)
                .ignoresSafeArea()
        }
    }
    func analyzeImage() async {
        guard let image = image else { return }
        isAnalyzing = true
        airesult = ""
        
        let prompt = """
            あなたは管理栄養士と食品分析AIです。

            入力される情報は以下です。

            【食事画像】
            ユーザーが撮影した食事写真

            【ユーザー情報】

            * 性別: {{gender}}
            * 年齢: {{age}}
            * 身長(cm): {{height}}
            * 体重(kg): {{weight}}
            * 目標: {{goal}}
              （減量・維持・増量・健康維持など）

            【過去3日間の栄養履歴】
            {{nutrition_history}}

            あなたの役割は、食事画像を分析し、写真に写っている食品を推定し、ユーザー情報に基づいた栄養評価を行うことです。

            重要なルール

            1. 写真だけでは断定できない場合は推定する
            2. 不明な場合は「推定」と明記する
            3. 中学生でも理解できる表現を使う
            4. 厳しい表現や説教はしない
            5. 栄養アドバイスは前向きで具体的にする
            6. 栄養バランスは今回の食事だけでなく過去3日間も考慮する
            7. カロリーや栄養素は推定値として計算する
            8. ユーザーに読ませるための自然な文章で回答する
            9. JSON・Markdown・コードブロックは出力しない
            10. 見出しを使い、読みやすく整理する
            11. 栄養評価は1食単位ではなく、3日間単位で行う
            12. ユーザーが最初に食事を記録した日を起点として3日周期で栄養バランスを管理する
            13. 過去3日間の栄養履歴から不足・過剰な栄養素を分析する
            14. 現在が3日周期の1日目または2日目の場合は、残りの日数でどの栄養素を増やすべきか、または控えるべきかを提案する
            15. 現在が3日周期の最終日の場合は、3日間全体の総合評価を行う
            16. ユーザーの目標（減量・維持・増量・健康維持）に応じてアドバイス内容を調整する
            17. 「次の1日」または「次の2日」で実行できる具体的な食事改善案を提示する
            18. ユーザー情報（性別・年齢・身長・体重・目標）から1食あたりの推奨栄養量を推定する
            19. 推定栄養量の横に「1食の目安量」を表示する
            20. 写真に複数の食品や料理が含まれる場合は、料理ごとの推定を行った上で合計栄養量を算出する
            21. 評価は自然な会話文で記載し、「不足」「過剰」などの強い表現を避ける
            22. 良い点を先に伝え、その後に改善点を1つだけ伝える

            【出力ルール】

            * 回答全体は300文字以内
            * 1項目につき2〜3文まで
            * 箇条書きは最大3個
            * 食品の説明は1文で簡潔に
            * 栄養評価は2文以内
            * アドバイスは最も重要な内容を2つだけ
            * 過去3日間のコメントは1文のみ
            * 専門的な解説は不要
            * 同じ内容の繰り返しは禁止
            * ユーザーが一目で読める短いレポート形式にする
            
            【画像判定ルール】

            最初に画像内に食べ物または飲み物が存在するか確認すること。

            以下の場合は栄養分析を行わず、次の文章のみを返す。

            「食べ物または飲み物が確認できなかったため、栄養分析を行えませんでした。食事が写った写真をもう一度撮影してください。」

            対象例

            * 人物のみ
            * 風景
            * ペット
            * 机や家具
            * 教科書やノート
            * 暗すぎて判別できない画像
            * ピンボケ画像
            * 食べ物が極端に小さく判別不能な画像

            食べ物が写っている確信度が50%未満の場合も同じ文章を返す。

            この場合は推定栄養量、評価、アドバイス、信頼度は出力しない。

            出力形式：

            【食事分析】
            写真から○○（推定○g）と判断しました。

            【【推定栄養量】
            
            合計栄養量

            カロリー：○kcal（目安 ○kcal）
            たんぱく質：○g（目安 ○g）
            脂質：○g（目安 ○g）
            炭水化物：○g（目安 ○g）
            ビタミン：○（目安 ○）
            ミネラル：○（目安 ○）

            【評価】

            今回の食事では○○がしっかり摂れていますね。

            さらにバランスを良くするなら、次回は○○を少し意識してみましょう。

            【3日間の栄養バランス】
            　◎3日周期の進捗状況： ○日目／3日
            
            　◎3日間全体の評価：
            　　今回の食事では○○がしっかり摂れていますね。

            　　さらにバランスを良くするなら、次回は○○を少し意識してみましょう。
            
            　◎今後の調整：
            ・次の1〜2日は○○を多めにしましょう 
            ・次の1〜2日は○○を控えめにしましょう     
            
            【信頼度】
            95%

            """
        do {
            let response = try await model.generateContent(image,prompt)
            airesult = response.text ?? "分析できませんでした"
        } catch {
            airesult = "エラー\(error.localizedDescription)"
        }
        isAnalyzing = false
    }
}
#Preview {
    AiView()
}
