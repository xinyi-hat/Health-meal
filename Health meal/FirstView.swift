import SwiftUI

struct FirstView: View {
    var body: some View {
            
        VStack {
            Text("Welcome to Health App\n      Let's keep healthy")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            NavigationLink{
                SignUpView()
            } label: {
                Text("Sign up")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(width: 200, height: 50)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
            NavigationLink{
                LogInView()
            } label: {
                Text("Log in")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(width: 200, height: 50)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
            .padding()
        }
    }
}

#Preview {
    FirstView()
}
