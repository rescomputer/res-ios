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
    func animatedGradient() -> some View {
        self.modifier(AnimatedGradient())
    }
    func wiggle() -> some View {
        self.modifier(Wiggle())
    }
    func slideUp() -> some View {
        self.modifier(SlideUp())
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
    func scaleUpAnimation() -> some View {
        self.modifier(ScaleUpAnimation())
    }
}

struct WiggleEffect: GeometryEffect {
    var isActive: Bool
    var times: CGFloat = 5
    var amplitude: CGFloat = 10.0
    
    var animatableData: CGFloat {
        get { isActive ? 1 : 0 }
        set { }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        guard isActive else { return ProjectionTransform() }
        let wiggle = sin(animatableData * .pi * times) * amplitude
        return ProjectionTransform(CGAffineTransform(translationX: wiggle, y: 0))
    }
}

struct ScaleUpAnimation: ViewModifier {
    @State private var isAnimating = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isAnimating ? 2.0 : 1.0)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                    isAnimating = true
                }
            }
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

struct SlideLeft: ViewModifier {
    @State private var slideLeftAnimation = false
    @State private var isShowing = false

    func body(content: Content) -> some View {
        content
            .offset(x: slideLeftAnimation ? 0 : 20)
            .opacity(isShowing ? 1 : 0)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.easeOut(duration: 0.1)) {
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


struct AnimatedGradient: ViewModifier {
    @State private var isAnimating = false

    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: isAnimating ? [Color.blue, Color.yellow] : [Color.orange, Color.purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .mask(content)
            .onAppear {
                withAnimation(Animation.linear(duration: 2.0).repeatForever(autoreverses: true)) {
                    isAnimating = true
                }
            }
    }
}

struct PressAnimation: ViewModifier {
    @State private var isPressed = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.96 : 1)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
            .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
                withAnimation {
                    isPressed = pressing
                }
            }, perform: {})
    }
}


struct Wiggle: ViewModifier {
    @State private var isAnimating = false

    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(isAnimating ? 10 : -10))
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 0.15).repeatForever(autoreverses: true)) {
                    isAnimating = true
                }
            }
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



