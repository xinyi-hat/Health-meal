import SwiftUI

struct InformationView: View {
    @AppStorage("nickname") var nickname: String = ""
    @AppStorage("age") var age : String = ""
    @AppStorage("gender") var gender : String = ""
    @AppStorage("height") var height : String = ""
    @AppStorage("weight") var weight : String = ""
    @State private var showError: Bool = false
    @State private var moveToNext: Bool = false
    
    var body: some View {
        VStack{
            TextField("nickname", text: $nickname)
                .padding(.leading, 15)
            TextField("age", text: $age)
                .padding(.leading, 15)
            TextField("gender", text: $gender)
                .padding(.leading, 15)
            TextField("height", text: $height)
                .padding(.leading, 15)
            TextField("weight", text: $weight)
                .padding(.leading, 15)
            Button{
                moveToNext = true
            } label: {
                Text("Next")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(width: 200, height: 50)
                    .background(isFormValid ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
            .disabled(!isFormValid)
        }
        .navigationDestination(isPresented: $moveToNext) {
            ContentView()
        }
        .navigationBarBackButtonHidden(true)
    }
    private var isFormValid: Bool {
        !nickname.isEmpty &&
        !age.isEmpty &&
        !gender.isEmpty &&
        !height.isEmpty &&
        !weight.isEmpty
    }
}

#Preview {
    InformationView()
}
