import SwiftUI

struct HomeView: View {
    var body: some View {
        
        NavigationLink{
            AiView()
        } label: {
            Text("AI")
                .font(.title2)
                .fontWeight(.semibold)
                .frame(width: 100, height: 100)
                .background(.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
                .padding(.top, 200)
                
        }
    }
}
#Preview {
    HomeView()
}
