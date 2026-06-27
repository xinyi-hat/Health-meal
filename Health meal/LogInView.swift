import SwiftUI
import FirebaseAuth

struct LogInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    @State private var isLogIn: Bool = false
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
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .font(.caption)
            }
            Button{
                logIn()
            } label: {
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                } else {
                    Text("Log in")
                        .bold()
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .navigationDestination(isPresented: $moveToNext) {
            ContentView()
        }
    }
        
        func logIn(){
            if email.isEmpty || password.isEmpty {
                errorMessage = "メールアドレスとパスワードを入力してください"
                return
            }
            isLoading = true
            
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                
            isLoading = false
                
                if let error = error {
                    errorMessage = error.localizedDescription
                    return
                }
                
                print("ログイン成功")
                moveToNext = true
            }
        }
    }

#Preview {
    LogInView()
}
