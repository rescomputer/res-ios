import SwiftUI
import RiveRuntime

struct LaunchScreenView: View {
    @State private var logoOpacity = 0.0
    @State private var showRiveAnimation = false
    @State private var showNextView = false

    @Binding var isAppSettingsViewShowing: Bool
    @Binding var isModalStepTwoEnabled: Bool

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)


            if showRiveAnimation {
                MainViewTeenageEng(isAppSettingsViewShowing: $isAppSettingsViewShowing, isModalStepTwoEnabled: $isModalStepTwoEnabled)
                    .zIndex(0)
                RiveViewModel(fileName: "res_unboxing").view()
                    .edgesIgnoringSafeArea(.all)
                    .zIndex(1)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                            withAnimation {
                                showNextView = true
                            }
                        }
                    }
            } else {
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                showRiveAnimation = true
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    LaunchScreenView(isAppSettingsViewShowing: .constant(false), isModalStepTwoEnabled: .constant(false))
}
