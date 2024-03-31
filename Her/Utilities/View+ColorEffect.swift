//
//  View+ColorEffect.swift
//  LearnMetal
//
//  Created by Jacob Bartlett on 06/11/2023.
//

import SwiftUI

extension View {
    
    func colorShader() -> some View {
        modifier(ColorShader())
    }
    
    func sizeAwareColorShader() -> some View {
        modifier(SizeAwareColorShader())
    }
    
    func timeVaryingColorShader() -> some View {
        modifier(TimeVaryingColorShader())
    }
}

struct ColorShader: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .colorEffect(ShaderLibrary.color())
    }
}

struct SizeAwareColorShader: ViewModifier {
    
    func body(content: Content) -> some View {
        content.visualEffect { content, proxy in
            content
                .colorEffect(ShaderLibrary.sizeAwareColor(
                    .float2(proxy.size)
                ))
        }
    }
}

struct TimeVaryingColorShader: ViewModifier {
    
    private let startDate = Date()
    
    func body(content: Content) -> some View {
        TimelineView(.animation) { _ in
            content.visualEffect { content, proxy in
                content
                    .colorEffect(ShaderLibrary.timeVaryingColor(
                        .float2(proxy.size),
                        .float(startDate.timeIntervalSinceNow)
                    ))
            }
        }
    }
}
