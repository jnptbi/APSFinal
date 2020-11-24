//
//  ButtonStyle.swift
//  APS Security
//
//  Created by Vishal Patel on 18/09/20.
//  Copyright © 2020 Vishal Patel. All rights reserved.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.font(.headline)
            //.padding()
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(Capsule().fill(Color("clrPrimary")))
            .foregroundColor(Color("clrSecondary"))
            //.foregroundColor(.white)
            .opacity(configuration.isPressed ? 0.4 : 1)
    }
}

struct MyButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.font(.headline)
            //.padding()
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Capsule().fill(Color("clrLogout").opacity(1.5)))
            .foregroundColor(Color("clrSecondary"))
            .opacity(configuration.isPressed ? 0.4 : 1)
    }
}

struct LogoutBtnStyle: ButtonStyle {
    
    let clr1 = Color.black.opacity(0.3)
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.font(.headline)
            //.padding()
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Capsule().fill(LinearGradient(gradient: Gradient(colors: [clr1,.black]), startPoint: .topLeading, endPoint: .bottomTrailing)).opacity(0.4))
            .foregroundColor(Color("clrSecondary"))
            .opacity(configuration.isPressed ? 0.4 : 1)
    }
}

struct EllipseButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.font(.headline)
            //.padding()
            .padding(.horizontal, 100)
            .padding(.top, 90)
            .padding(.bottom, 20)
            //.background(Ellipse().fill(Color("clrLogout").opacity(1.5)))
            .background(TransformedShape(shape: Ellipse(), transform: CGAffineTransform(scaleX: 1.0, y: 1.5)).fill(Color("clrLogout").opacity(1.5)))
            .foregroundColor(Color("clrSecondary"))
            .opacity(configuration.isPressed ? 0.4 : 1)
    }
}

struct CornerButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.font(.headline)
            //.padding()
            .padding(.horizontal, 30)
            .padding(.vertical, 30)
            .background(Color("clrLogout").opacity(1.5))
            .foregroundColor(Color("clrSecondary"))
            .cornerRadius(30)
            .opacity(configuration.isPressed ? 0.4 : 1)
    }
}

