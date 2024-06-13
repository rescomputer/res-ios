//
//  CustomizationView.swift
//  Res
//
//  Created by Steven Sarmiento on 6/10/24.
//

import SwiftUI

struct CustomizationView: View {
    @EnvironmentObject var resAppModel: ResAppModel
    var dismissAction: () -> Void
    @State private var customizationModal: CustomizationModal?
    
    var body: some View {

            ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [Color(red: 0.047, green: 0.071, blue: 0.071), Color(red: 0.047, green: 0.071, blue: 0.071)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .edgesIgnoringSafeArea(.all)

                VStack {
                Spacer()
                    .frame(height: 60)
                
                HStack {
                    Button(action: {
                        withAnimation(.easeOut(duration: 0.1)) {
                            self.dismissAction()                        
                        }
                        let impactMed = UIImpactFeedbackGenerator(style: .soft)
                        impactMed.impactOccurred()
                    }) {
                        HStack {
                            Image(systemName: "chevron.backward")
                                .font(.system(size: 20))
                                .bold()
                                .foregroundColor(.white.opacity(0.3))
                        }
                    }
                    Spacer()
                    
                    Text("Customization")
                        .bold()
                        .font(.system(size: 20, design: .rounded))
                        .foregroundColor(Color.white.opacity(0.8))
                    
                    
                    Spacer()

                    // Button(action: {
                    //     //action
                    //     let impactMed = UIImpactFeedbackGenerator(style: .soft)
                    //     impactMed.impactOccurred()
                    // }) {
                    //     HStack {
                    //         Image(systemName: "info.circle.fill")
                    //             .font(.system(size: 20))
                    //             .bold()
                    //             .foregroundColor(.white.opacity(0.3))
                    //     }
                    // }
                }
                .padding(.bottom, 20)
                
                customizationLinks()
                    
                Spacer()

            }
            .padding()
            .padding(.horizontal, 10)
        }
        .slideLeft()
        .overlay {
            if let customizationModal = customizationModal {
                switch customizationModal {
                case .skinModal:
                    showSkinModal()
                case .iconModal:
                    showIconModal()
                }
            }
        }
    }
}

extension CustomizationView {

    enum CustomizationModal {
        case skinModal
        case iconModal
    }

    enum ModalHeightMultiplier {
        case skinModal
        case iconModal

        var value: CGFloat {
            switch self {
            case .skinModal: return -0.02
            case .iconModal: return -0.02
            }
        }
    }

    private func customizationLinks() -> some View {
        VStack {
                HStack {
                    Text("Tutorials")
                        .bold()
                        .font(.system(size: 12))
                        .foregroundColor(Color.white.opacity(0.7))
                    Spacer()
                }
                CustomLinkView(iconName: "paintbrush.fill", title: "Choose a Skin", action: {
                    self.customizationModal = .skinModal
                }, navigateTo: {
                    self.customizationModal = .skinModal
                }, screenSize: UIScreen.main.bounds.size, offset: 0, minHeight: 100)
                CustomLinkView(iconName: "app.gift.fill", title: "Pick your App Icon", action: {
                    self.customizationModal = .iconModal
                }, navigateTo: {
                    self.customizationModal = .iconModal
                }, screenSize: UIScreen.main.bounds.size, offset: 0, minHeight: 100)
        }
        .padding(.bottom, 20)

    } 

    private func showSkinModal() -> some View {

        HalfModalView(isShown: Binding<Bool>(
            get: { self.customizationModal == .skinModal },
            set: { newValue in
                if !newValue {
                    self.customizationModal = nil
                }
            }
        ), onDismiss: {
            withAnimation(.easeInOut(duration: 0.15)) {
                self.customizationModal = nil
            }
        }, modalHeightMultiplier: CustomizationView.ModalHeightMultiplier.skinModal.value
        ) {
            VStack{
                ZStack {
                    HStack {
                        ZStack {
                            HStack {
                                Image(systemName: "theatermask.and.paintbrush.fill")
                                    .resizable()
                                    .foregroundColor(.black.opacity(0.05))
                                    .frame(width: 85, height: 85)
                                Spacer()
                            }
                            .offset(x: 10, y: -15)

                        
                            VStack(alignment: .leading) {
                                Text("Skins, skins, skins!")
                                    .font(.system(size: 20, design: .rounded))
                                    .bold()
                                    .foregroundColor(Color.black.opacity(1))
                                    .padding(.bottom, 2)
                                Text("Custom RES with custom skins, choose any skin and give RES a facelift.")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color.black.opacity(0.5))

                            }
                            .offset(x: UIScreen.isLargeDevice ? -20 : 0)
                            .padding(.horizontal, 20)

                        }
                    }
                }
                .overlay(
                    XMarkButton {
                        withAnimation(.easeOut(duration: 0.15)) {
                            self.customizationModal = nil
                        }
                    }
                    .offset(x: -20, y: 0),
                    alignment: .topTrailing
                    )
                
                        VStack(alignment:.leading, spacing: 10) {
                             Text("""
                                Skins is coming soon!
                                """)
                            .font(.footnote)
                            .bold()
                            .foregroundColor(.black.opacity(0.6))
                         }
                         .frame(height: 150)
                         .padding(.horizontal, 20)
                    
            }
            .padding(.vertical)
            .background(
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color.white)
            )
        }
    }

    private func showIconModal() -> some View {

        HalfModalView(isShown: Binding<Bool>(
            get: { self.customizationModal == .iconModal },
            set: { newValue in
                if !newValue {
                    self.customizationModal = nil
                }
            }
        ), onDismiss: {
            withAnimation(.easeInOut(duration: 0.15)) {
                self.customizationModal = nil
            }
        }, modalHeightMultiplier: CustomizationView.ModalHeightMultiplier.iconModal.value
        ) {
            VStack{
                ZStack {
                    HStack {
                        ZStack {
                            HStack {
                                Image(systemName: "app.gift.fill")
                                    .resizable()
                                    .foregroundColor(.black.opacity(0.05))
                                    .frame(width: 85, height: 85)
                                Spacer()
                            }
                            .offset(x: 10, y: -15)

                        
                            VStack(alignment: .leading) {
                                Text("Choose an App Icon!")
                                    .font(.system(size: 20, design: .rounded))
                                    .bold()
                                    .foregroundColor(Color.black.opacity(1))
                                    .padding(.bottom, 2)
                                Text("Custom RES on your homescreen, choose any icon and set it as your app icon")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color.black.opacity(0.5))

                            }
                            .offset(x: UIScreen.isLargeDevice ? -20 : 0)
                            .padding(.horizontal, 20)

                        }
                    }
                }
                .overlay(
                    XMarkButton {
                        withAnimation(.easeOut(duration: 0.15)) {
                            self.customizationModal = nil
                        }
                    }
                    .offset(x: -20, y: 0),
                    alignment: .topTrailing
                    )

                            VStack {
                                let columns = [
                                    GridItem(.adaptive(minimum: 80))
                                ]

                                LazyVGrid(columns: columns, spacing: 10) {
                                    ForEach(["AppIcon", "retro", "simple", "vaporwave", "testflight", "classic", "futurism", "8-bit", "apple-retro"], id: \.self) { icon in
                                        VStack {
                                            Image(uiImage: UIImage(named: icon) ?? UIImage())
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 70, height: 70)
                                                .clipShape(RoundedRectangle(cornerRadius: 17))
                                                .shadow(color: Color.black.opacity(0.2), radius: 3)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 17)
                                                        .stroke(resAppModel.activeAppIcon == icon ? Color.blue : Color.clear, lineWidth: 4)
                                                )
                                                .onTapGesture {
                                                    if icon == "AppIcon" {
                                                        UIApplication.shared.setAlternateIconName(nil)
                                                    } else {
                                                        UIApplication.shared.setAlternateIconName(icon)
                                                    }
                                                    resAppModel.activeAppIcon = icon
                                                }
                                            Text(icon)
                                                .font(.caption)
                                        }
                                    }
                                }
                                .padding()
                            }
                            .frame(height: 290)
                
                        // VStack(alignment:.leading, spacing: 10) {
                        //     NavigationStack {
                        //         Picker("Choose an Icon", selection: $resAppModel.activeAppIcon) {
                        //             let customIcons: [String] = ["AppIcon", "retro", "simple", "vaporwave", "testflight", "classic", "futurism"]
                        //             ForEach(customIcons, id: \.self) { icon in
                        //                 Text(icon).tag(icon)
                        //             }
                        //         }
                        //         .navigationTitle("Choose an Icon")
                        //         .onChange(of: resAppModel.activeAppIcon) { newValue in
                        //             if newValue == "AppIcon" {
                        //                 UIApplication.shared.setAlternateIconName(nil)
                        //             } else {
                        //                 UIApplication.shared.setAlternateIconName(newValue)
                        //             }
                        //         }
                        //     }

                        //  } 
                        //  .frame(height: 150)
                        //  .padding(.horizontal, 20)
                    
            }
            .padding(.vertical)
            .background(
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color.white)
            )
            .clipped()
        }
    }
    

}


#Preview {
    CustomizationView(dismissAction: {})
}
