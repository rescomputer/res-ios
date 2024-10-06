//
//  AppIconView.swift
//  Res
//
//  Created by Steven Sarmiento on 9/16/24.
//

import SwiftUI

struct AppIconView: View {
    @Binding var isActive: Bool
    @EnvironmentObject var resAppModel: ResAppModel


    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 0)) {
                        isActive = false
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.orange)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                }
                Spacer()
                Text("App Icon")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(Color(red: 0.271, green: 0.267, blue: 0.2))
                Spacer()
                Button(action: {
                    // feedback flow
                }) {
                    HStack {
                        Image(systemName: "heart")
                        // Text("RES")
                    }
                    .foregroundColor(.orange)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                }
            }
            .padding()
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

                    ScrollView {
                        VStack {
                            let columns = [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ]

                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(["AppIcon", "retro", "simple", "vaporwave", "testflight", "classic", "futurism", "apple-retro", "intelligence", "bit"], id: \.self) { icon in
                                    VStack {
                                        Image(uiImage: UIImage(named: icon) ?? UIImage())
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 100, height: 100)
                                            .clipShape(RoundedRectangle(cornerRadius: 22))
                                            .shadow(color: Color.black.opacity(0.2), radius: 3)
                                            .background(
                                                RoundedRectangle(cornerRadius: 22)
                                                    .stroke(resAppModel.activeAppIcon == icon ? Color.orange : Color.clear, lineWidth: 8)
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
                    }             
                    
            }
            Spacer()
        }
        .background(Color(red: 0.945, green: 0.945, blue: 0.918))
    }
}
