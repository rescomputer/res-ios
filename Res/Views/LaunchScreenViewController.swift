import SwiftUI
import RiveRuntime

struct LaunchScreenView: View {
    @State private var logoOpacity = 0.0
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            Image("logo-res")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .opacity(logoOpacity)
                .zIndex(1)
                .onAppear {
                    withAnimation(.easeIn(duration: 0.3)) {
                        logoOpacity = 1.0
                    }
                }
        }
    }
}

#Preview {
    LaunchScreenView()
}
