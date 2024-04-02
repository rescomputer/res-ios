//
//  AnimationUtility.swift
//  Her
//
//  Created by Steven Sarmiento on 3/21/24.
//

import Foundation
import SwiftUI

protocol CommonViewModifier: ViewModifier { }

extension View {
    func fadeInEffect() -> some View {
        self.modifier(FadeInEffect())
    }
    func slideUp() -> some View {
        self.modifier(SlideUp())
    }
    func slideDown() -> some View {
        self.modifier(SlideDown())
    }
    func slideLeft() -> some View {
        self.modifier(SlideLeft())
    }
    func slideRight() -> some View {
        self.modifier(SlideRight())
    }
    func pressAnimation() -> some View {
        self.modifier(PressAnimation())
    }
}

struct FadeInEffect: ViewModifier {
    @State private var isShowing = false

    func body(content: Content) -> some View {
        content
            .opacity(isShowing ? 1 : 0)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isShowing = true
                }
            }
    }
}

struct SlideUp: ViewModifier {
    @State private var slideUpAnimation = false
    @State private var isShowing = false

    func body(content: Content) -> some View {
        content
            .offset(y: slideUpAnimation ? 0 : 10)
            .opacity(isShowing ? 1 : 0)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.easeOut(duration: 0.1)) {
                        self.slideUpAnimation = true
                        isShowing = true

                    }
                }
            }
    }
}

struct SlideDown: ViewModifier {
    @State private var slideDownAnimation = false
    @State private var isShowing = false

    func body(content: Content) -> some View {
        content
            .offset(y: slideDownAnimation ? 0 : -20)
            .opacity(isShowing ? 1 : 0)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.easeIn(duration: 0.1)) {
                        self.slideDownAnimation = true
                        isShowing = true

                    }
                }
            }
    }
}

struct SlideLeft: ViewModifier {
    @State private var slideLeftAnimation = false
    @State private var isShowing = false

    func body(content: Content) -> some View {
        content
            .offset(x: slideLeftAnimation ? 0 : 20)
            .opacity(isShowing ? 1 : 0)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    withAnimation(.easeIn(duration: 0.1)) {
                        self.slideLeftAnimation = true
                        isShowing = true

                    }
                }
            }
        }
    }

struct SlideRight: ViewModifier {
    @State private var slideRightAnimation = false
    @State private var isShowing = false

    func body(content: Content) -> some View {
        content
            .offset(x: slideRightAnimation ? 0 : -20)
            .opacity(isShowing ? 1 : 0)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.easeOut(duration: 0.1)) {
                        self.slideRightAnimation = true
                        isShowing = true
                    }
                }
            }
        }
    }


struct PressAnimation: ViewModifier {
    @State private var isPressed = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.98 : 1)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
            .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
                withAnimation {
                    isPressed = pressing
                }
            }, perform: {})
    }
}


struct AnimationUtility {

    static let sunriseDuration: Double = 3.0
    static let fadeDuration: Double = 1.0

    static func sunriseAnimation() -> Animation {
        return Animation.easeInOut(duration: sunriseDuration)
    }

    static func fadeAnimation() -> Animation {
        return Animation.easeInOut(duration: fadeDuration).delay(sunriseDuration)
    }
}



