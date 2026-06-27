import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    @State private var moveToNext: Bool = false
    @State private var isLoading = false
    var body: some View {
            VStack{
                TextField("Email", text:$email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .padding(.leading, 15)
                SecureField("password",text:$password)
                    .padding(.leading, 15)
                Button{
                    signUp()
                } label: {
                    if isLoading {
                    ProgressView()
                    .frame(maxWidth: .infinity)
                    } else {
                        Text("Sign Up")
                            .bold()
                            .frame(maxWidth: .infinity)
                    }
                }
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .font(.caption)
                 }
            }
            .navigationDestination(isPresented: $moveToNext) {
                            InformationView()
                        }
    }
    
    func signUp(){
        if email.isEmpty || password.isEmpty {
            errorMessage = "メールアドレスとパスワードを入力してください"
            return
        }
        isLoading = true
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            isLoading = false
            if let error = error {
                errorMessage = error.localizedDescription
                return
            }
            
            print("ユーザー登録成功")
            moveToNext = true
        }
    }
}


#Preview {
    SignUpView()
}
