import SwiftUI

enum ButtonType {
    case red, orange, gray
}

struct PrimaryButton: View {
    var title: String
    var type: ButtonType = .gray
    var action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }) {
            Text(title)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(
                    Group {
                        switch type {
                        case .red:
                            LinearGradient(gradient: Gradient(colors: [Color(red: 1.0, green: 0.4, blue: 0.4), Color(red: 0.9, green: 0.0, blue: 0.0)]), startPoint: .top, endPoint: .bottom)
                                .cornerRadius(40)
                                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(Color(red: 0.8, green: 0.0, blue: 0.0), lineWidth: 1)
                                )
                        case .orange:
                            LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]), startPoint: .top, endPoint: .bottom)
                                .cornerRadius(40)
                                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(Color(red: 0.8, green: 0.4, blue: 0.0), lineWidth: 1)
                                )
                        case .gray:
                            LinearGradient(gradient: Gradient(colors: [Color.gray, Color.black]), startPoint: .top, endPoint: .bottom)
                                .cornerRadius(40)
                                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 40)
                                        .stroke(Color(red: 0.4, green: 0.4, blue: 0.4), lineWidth: 1)
                                )
                        }
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(Color.black.opacity(0.2), lineWidth: 1)
                        .blur(radius: 1)
                        .offset(x: 0, y: 1)
                        .mask(RoundedRectangle(cornerRadius: 40).fill(LinearGradient(gradient: Gradient(colors: [Color.black, Color.clear]), startPoint: .top, endPoint: .bottom)))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        .blur(radius: 1)
                        .offset(x: 0, y: -1)
                        .mask(RoundedRectangle(cornerRadius: 40).fill(LinearGradient(gradient: Gradient(colors: [Color.clear, Color.white]), startPoint: .top, endPoint: .bottom)))
                )
        }
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            PrimaryButton(title: "Call", type: .orange, action: { print("Call action") })
            PrimaryButton(title: "End Call", type: .red, action: { print("End call action") })
            PrimaryButton(title: "Cancel", type: .gray, action: { print("Cancel action") })
        }
        .padding()
    }
}
