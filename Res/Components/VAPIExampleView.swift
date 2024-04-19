import SwiftUI
import Vapi
import Combine

struct VAPIExampleView: View {
    @StateObject private var callManager = CallManager()
    
    var body: some View {
        ZStack {
            
            VStack(spacing: 20) {
                Text("Vapi Call Interface")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(callManager.callStateText)
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .background(callManager.callStateColor)
                    .cornerRadius(10)
                
                Spacer()
                
                Button(action: {
                    Task {
                        await callManager.handleCallAction()
                    }
                }) {
                    Text(callManager.buttonText)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(callManager.buttonColor)
                        .cornerRadius(10)
                }
                .disabled(callManager.callState == .loading)
                .padding(.horizontal, 40)
                
                Spacer()
            }
        }
        .onAppear {
            callManager.setupVapi()
        }
    }
}

#Preview {
    VAPIExampleView()
}
