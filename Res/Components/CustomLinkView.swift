//
//  CustomLinkView.swift
//  Res
//
//  Created by Steven Sarmiento on 3/23/24.
//

import SwiftUI
import CoreHaptics

struct CustomToggle: View {
    let title: String
    let systemImageName: String
    @Binding var isOn: Bool
    var infoAction: (() -> Void)? = nil


    var body: some View {
        HStack {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: systemImageName)
                        .font(.system(size: 16))
                        .bold()
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding(.trailing, 5)
        
             Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .bold()
            if let infoAction: () -> Void = infoAction {
                Button(action: {
                    infoAction()
                    let impactMed = UIImpactFeedbackGenerator(style: .soft)
                    impactMed.impactOccurred()
                }) {
                    Image(systemName: "questionmark.circle")
                        .font(.system(size: 16))
                        .bold()
                        .foregroundColor(.yellow.opacity(0.6))
                        .frame(width: 16, height: 16)
                    }
                }
            Spacer()
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: .yellow.opacity(1)))
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(Color.white.opacity(0.07))
        )
        // .overlay(
        //     RoundedRectangle(cornerRadius: 16)
        //         .stroke(Color.white.opacity(0.1), lineWidth: 1)
        // )
    }
}

struct CustomLinkView: View {
    var iconName: String
    var title: String
    var action: () -> Void
    var navigateTo: () -> Void?
    var screenSize: CGSize
    var offset: CGFloat
    var minHeight: CGFloat
    var chevronIconName: String = "chevron.forward"
    var rotateChevron: Bool = false

    var progress: Double {
        let total = Double(screenSize.height - minHeight)
        let current = Double(offset)
        return current / total
    }
    
    var body: some View {
        Button(action: {
            softHaptic()
            self.navigateTo()
        }) {
        HStack(alignment: .center) {
            HStack(alignment: .center) {
                Image(systemName: iconName)
                    .font(.system(size: 16))
                    .bold()
                    .foregroundColor(.black.opacity(0.3))
                    .padding(.trailing, 5)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .fontDesign(.rounded)
                        .font(.system(size: 16))
                        .foregroundColor(.black.opacity(0.8))
                        .bold()
                }
            }
            
            Spacer()
            
             Image(systemName: chevronIconName)
                .font(.system(size: 16))
                .bold()
                .foregroundColor(.black.opacity(0.3))
                .rotationEffect(rotateChevron ? .degrees(90) : .degrees(0))
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color(hex: "666666"), lineWidth: 1)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 3)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                            .blur(radius: 1)
                            .offset(x: -1, y: -1)
                            .mask(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(LinearGradient(
                                        gradient: Gradient(colors: [Color.clear, Color.white]),
                                        startPoint: .bottomTrailing,
                                        endPoint: .topLeading
                                    ))
                            )
                    )
            )
        }
    }
}

struct CustomPicker<T: Hashable & CaseIterable>: View where T: RawRepresentable, T.RawValue == String {
    let systemImageName: String
    @Binding var selection: T
    let options: [T]
    let descriptions: [T: String]
    let orientation: Orientation
    var disabledOptions: [T] = []

    enum Orientation {
        case horizontal, vertical
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            let layout = orientation == .vertical ? AnyLayout(VStackLayout(spacing: 0)) : AnyLayout(HStackLayout(spacing: 0))
            layout {
                ForEach(options, id: \.self) { option in
                    VStack(spacing: 0) {
                        Button(action: {
                            if !disabledOptions.contains(option) {
                                softHaptic()
                                selection = option
                            }
                        }) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(option.rawValue)
                                        .fontDesign(.rounded)
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                        .bold()
                                    if let description = descriptions[option] {
                                        Text(description)
                                            .fontDesign(.monospaced)
                                            .font(.system(size: 12))
                                            .foregroundColor(.white.opacity(0.6))
                                            .multilineTextAlignment(.leading)
                                    }
                                }
                                Spacer()
                                Image(systemName: selection == option ? "checkmark.circle.fill" : "circle.dashed")
                                    .foregroundColor(selection == option ? .green : .white.opacity(0.3))
                                    .contentTransition(.symbolEffect(.replace.offUp.byLayer))
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 15)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(selection == option ? 0.1 : 0))
                            )
                             .overlay(
                                 RoundedRectangle(cornerRadius: 12)
                                     .stroke(selection == option ? Color.yellow.opacity(1) : Color.clear, lineWidth: 1)
                             )
                        }
                        .disabled(disabledOptions.contains(option))
                        .opacity(disabledOptions.contains(option) ? 0.5 : 1.0)

                        if option != options.last {
                            Divider()
                                .frame(height: 2)
                                .background(Color.white.opacity(0.1))
                                .padding(.horizontal, 15)
                                .cornerRadius(50)
                        }
                    }
                }
            }
        }
    }
}

struct CustomPermissionToggle: View {
    let title: String
    let description: String
    let systemImageName: String
    @Binding var isEnabled: Bool
    var action: () -> Void

    var body: some View {
        Button(action: {
            softHaptic()
            isEnabled.toggle()
            action()
        }) {
            HStack(alignment: .center) {
                HStack(alignment: .top) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 36, height: 36)
                        
                        Image(systemName: systemImageName)
                            .font(.system(size: 16))
                            .bold()
                            .foregroundColor(.white.opacity(0.8))
                            .symbolRenderingMode(.hierarchical)
                    }
                    .padding(.trailing, 5)

                    VStack(alignment: .leading) {
                        Text(title)
                            .fontDesign(.rounded)
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .bold()
                        
                        Text(description)
                            .fontDesign(.monospaced)
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.leading)
                    }
                }

                Spacer()
                
                Image(systemName: isEnabled ? "checkmark.circle.fill" : "circle.dashed")
                    .font(.system(size: 22))
                    .foregroundColor(isEnabled ? Color(red: 0.2, green: 0.898, blue: 0.271) : .black.opacity(0.2))
                    .contentTransition(.symbolEffect(.replace.offUp.byLayer))
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 18)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.black.opacity(isEnabled ? 0.05 : 0.05))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(isEnabled ? Color.black.opacity(0.2) : Color.black.opacity(0.1), lineWidth: 1)
            )
        }
    }
}

extension View {
    func softHaptic() {
        let impact = UIImpactFeedbackGenerator(style: .soft)
        impact.impactOccurred()
    }
}
