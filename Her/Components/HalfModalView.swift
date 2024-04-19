//
//  HalfviewModal.swift
//  Res
//
//  Created by Steven Sarmiento on 3/21/24.
//

import SwiftUI

class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            DispatchQueue.main.async {
                self.currentHeight = keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        DispatchQueue.main.async {
            self.currentHeight = 0
        }
    }
}

struct HalfModalView<Content: View>: View {
    @StateObject private var keyboard = KeyboardResponder()
    @Environment(\.presentationMode) var presentationMode
    @Binding var isShown: Bool
    @State private var offset: CGFloat = UIScreen.main.bounds.height / 2

    var modalHeightMultiplier: CGFloat


    let onDismiss: () -> Void
    let content: Content
    
    init(isShown: Binding<Bool>, onDismiss: @escaping () -> Void, modalHeightMultiplier: CGFloat, @ViewBuilder content: () -> Content) {
        self._isShown = isShown
        self.onDismiss = onDismiss
        self.modalHeightMultiplier = modalHeightMultiplier
        self.content = content()
    }

    var body: some View {
        let screenSize = UIScreen.main.bounds.size
        let minHeight: CGFloat = screenSize.height * (keyboard.currentHeight > 0 ? 0.14 : modalHeightMultiplier)

        GeometryReader { geometry in 
            VStack {
                    VStack {
                        VStack{
                            content
                            }
                            .padding(.bottom, max(offset, 0))
                    }
                    .clipped()
                    .frame(width: screenSize.width * 0.92, height: geometry.size.height, alignment: .bottom)
                    .gesture(
                        DragGesture().onChanged { value in
                            let yOffset = value.translation.height
                            if yOffset > 0 {
                                offset = yOffset
                            }
                        }
                        .onEnded { value in
                            let threshold = minHeight * 0.2
                            if value.translation.height > threshold {
                                withAnimation(.easeOut(duration: 0.1)) {
                                    offset = UIScreen.main.bounds.height
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    isShown = false
                                    onDismiss()
                                }
                            } else {
                                withAnimation(.easeOut(duration: 0.1)) {
                                    offset = 0
                                }
                            }
                        }
                    )
                    .onAppear {
                        withAnimation(.easeOut(duration: 0.2)) {
                            offset = 0
                        }
                    }
                    .onDisappear {
                        offset = UIScreen.main.bounds.height / 2
                    }                
                    .offset(y: geometry.size.height - (screenSize.height - max(minHeight + offset, minHeight)))
                    .animation(.spring(response: 0.2, dampingFraction: 0.8), value: keyboard.currentHeight)
                    


            }
            .offset(y: max(minHeight + offset, minHeight))
            .frame(width: screenSize.width, height: screenSize.height)
            .edgesIgnoringSafeArea(.all)
            .background(isShown ? Color.black.opacity(0.4) : Color.clear)
            .animation(.spring(response: 0.2, dampingFraction: 0.8), value: offset)    
        }
    }
}
