//
//  AnimationUtility.swift
//  Res
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
    func applyScrollViewEdgeFadeDark() -> some View {
        self.modifier(ScrollViewEdgeFadeDark())
    }
    func applyScrollViewEdgeFadeLight() -> some View {
        self.modifier(ScrollViewEdgeFadeLight())
    }
    func scaleUpAnimation() -> some View {
        self.modifier(ScaleUpAnimation())
    }
}

struct FadeInEffect: ViewModifier {
    @State private var isShowing = false

    func body(content: Content) -> some View {
        content
            .opacity(isShowing ? 1 : 0)
            .onAppear {
                withAnimation(.easeIn(duration: 0.1)) {
                    isShowing = true
                }
            }
    }
}

struct ScaleUpAnimation: ViewModifier {
    @State private var isAnimating = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isAnimating ? 1.0 : 0)
            .onAppear {
                withAnimation(Animation.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0)) {
                    isAnimating = true
                }
            }
    }
}

struct SlideUp: ViewModifier {
    @State private var slideUpAnimation = false
    @State private var isShowing = false
    @State private var blurAmount: CGFloat = 10

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .offset(y: slideUpAnimation ? 0 : 50)
                .blur(radius: blurAmount)
                .opacity(isShowing ? 1 : 0)
                .onAppear {
                    withAnimation(Animation.spring(response: 0.18, dampingFraction: 0.60, blendDuration: 0)) {
                        self.slideUpAnimation = true
                        self.isShowing = true
                        self.blurAmount = 0
                    }
                }
        }
    }
}

struct SlideDown: ViewModifier {
    @State private var slideDownAnimation = false
    @State private var isShowing = false
    @State private var blurAmount: CGFloat = 10

    func body(content: Content) -> some View {
        content
            .offset(y: slideDownAnimation ? 0 : -50)
            .opacity(isShowing ? 1 : 0)
            .onAppear {
                    withAnimation(Animation.spring(response: 0.18, dampingFraction: 0.60, blendDuration: 0)) {
                        self.slideDownAnimation = true
                        self.blurAmount = 0
                        isShowing = true

                    }
            }
    }
}

struct SlideLeft: ViewModifier {
    @State private var slideLeftAnimation = false
    @State private var isShowing = false
    @State private var blurAmount: CGFloat = 10

    func body(content: Content) -> some View {
        content
            .offset(x: slideLeftAnimation ? 0 : 50)
            .opacity(isShowing ? 1 : 0)
            .onAppear {
                    withAnimation(Animation.spring(response: 0.18, dampingFraction: 0.60, blendDuration: 0)) {
                        self.slideLeftAnimation = true
                        self.blurAmount = 0
                        isShowing = true
                }
            }
        }
    }

struct SlideRight: ViewModifier {
    @State private var slideRightAnimation = false
    @State private var isShowing = false
    @State private var blurAmount: CGFloat = 10

    func body(content: Content) -> some View {
        content
            .offset(x: slideRightAnimation ? 0 : -50)
            .opacity(isShowing ? 1 : 0)
            .onAppear {
                withAnimation(Animation.spring(response: 0.18, dampingFraction: 0.60, blendDuration: 0)) {
                    self.slideRightAnimation = true
                    self.blurAmount = 0
                    isShowing = true
                }
                }
            }
        }


struct PressAnimation: ViewModifier {
    @State private var isPressed = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.90 : 1)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
            .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
                withAnimation { isPressed = pressing }
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

//scrollViewfades

struct ScrollViewEdgeFadeDark: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .black, location: 0),
                        .init(color: .black.opacity(0.05), location: 0.05),
                        .init(color: .black.opacity(0.05), location: 0.95),
                        .init(color: .black, location: 1)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .allowsHitTesting(false),
                alignment: .center
            )
    }
}

struct ScrollViewEdgeFadeLight: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .white, location: 0),
                        .init(color: .white.opacity(0.05), location: 0.05),
                        .init(color: .white.opacity(0.05), location: 0.95),
                        .init(color: .white, location: 1)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .allowsHitTesting(false),
                alignment: .center
            )
    }
}

struct HorizontalEdgeFade: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay(
                HStack(spacing: 0) {
                    LinearGradient(
                        gradient: Gradient(colors: [Color(red: 0.094, green: 0.094, blue: 0.094), Color.clear]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: 77)
                    
                    Spacer()
                    
                    LinearGradient(
                        gradient: Gradient(colors: [Color.clear, Color(red: 0.094, green: 0.094, blue: 0.094)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: 77)
                }
                .allowsHitTesting(false)
            )
    }
}

struct HorizontalEdgeBlackFade: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay(
                HStack(spacing: 0) {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black, Color.clear]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: 57)
                    
                    Spacer()
                    
                    LinearGradient(
                        gradient: Gradient(colors: [Color.clear, Color.black]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: 57)
                }
                .allowsHitTesting(false)
            )
    }
}



