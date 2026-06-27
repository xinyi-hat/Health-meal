import SwiftUI

struct SettingView: View {
    @AppStorage("nickname") var nickname: String = ""
    @AppStorage("age") var age : String = ""
    @AppStorage("gender") var gender : String = ""
    @AppStorage("height") var height : String = ""
    @AppStorage("weight") var weight : String = ""
    @State private var isEditing = false
    var body: some View {
        VStack {
            if isEditing {
                TextField("nickname", text: $nickname)
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .padding(.leading, 10)
                    .padding(.top)
                TextField("age", text: $age)
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .padding(.leading, 10)
                    .padding(.top)
                TextField("gender", text: $gender)
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .padding(.leading, 10)
                    .padding(.top)
                TextField("height", text: $height)
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .padding(.leading, 10)
                    .padding(.top)
                TextField("weight", text: $weight)
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .padding(.leading, 10)
                    .padding(.top)
                Button{
                    isEditing = false
                } label: {
                    Text("Finish")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .frame(width: 200, height: 50)
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                }
            } else {
                Text("nickname \(nickname)")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .padding(.trailing, 290)
                    .padding(.top)
                Text("age \(age)")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .padding(.trailing, 350)
                    .padding(.top)
                Text("gender \(gender)")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .padding(.trailing, 320)
                    .padding(.top)
                Text("height \(height)")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .padding(.trailing, 327)
                    .padding(.top)
                Text("weight \(weight)")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .padding(.trailing, 320)
                    .padding(.top)
                Button{
                    isEditing = true
                } label: {
                    Text("Edit")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .frame(width: 200, height: 50)
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                }
            }
        }
    }
}

#Preview {
    SettingView()
}
