//
//  ContentView.swift
//  LiquidMenu
//
//  Created by Kush on 05/02/23.
//

import SwiftUI

struct LiquidMenuButtons: View {
    
    // - Properties -
    @State var offsetOne: CGSize = .zero
    @State var offsetTwo: CGSize = .zero
    @State private var isCollapsed: Bool = false
    
    // - Body -
    var body: some View {
        ZStack {
            BackgroundView()
            LiquidMenu()
        }
    }
}


extension LiquidMenuButtons {
    
    private func BackgroundView() -> some View {
        Rectangle()
            .fill(.linearGradient(colors: [.black.opacity(0.9), .black, .black.opacity(0.9)], startPoint: .topLeading, endPoint: .bottomTrailing))
            .edgesIgnoringSafeArea(.all)
    }
    
    private func LiquidMenu() -> some View {
        ZStack {
            Rectangle()
                .fill(.linearGradient(colors: [.purple, .pink], startPoint: .top, endPoint: .bottom))
                .mask {
                    Canvas { context, size in
                        //Adding Filters
                        context.addFilter(.alphaThreshold(min: 0.8, color: .black))
                        context.addFilter(.blur(radius: 8))

                        //Drawing Layers
                        context.drawLayer { ctx in
                            //Placing symbols
                            for index in [1,2,3] {
                                if let resolvedView = context.resolveSymbol(id: index) {
                                    ctx.draw(resolvedView, at: CGPoint(x: size.width/2, y: size.height/2))
                                }
                            }
                        }
                    } symbols: {
                        Symbol(diameter: 120)
                            .tag(1)

                        Symbol(offset: offsetOne)
                            .tag(2)
                        
                        Symbol(offset: offsetTwo)
                            .tag(3)
                    }
                }
            
            CancelButton().blendMode(.softLight).rotationEffect(Angle(degrees: isCollapsed ? 90 : 0))
            SettingsButton().offset(offsetOne).blendMode(.softLight).opacity(isCollapsed ? 1 : 0)
            HomeButton().offset(offsetTwo).blendMode(.softLight).opacity(isCollapsed ? 1 : 0)
        }
        .frame(width: 120, height: 500)
        .contentShape(Circle())
    }
    
    private func Symbol(offset: CGSize = .zero, diameter: CGFloat = 75) -> some View {
        Circle()
            .frame(width: diameter, height: diameter)
            .offset(offset)
    }
    
    func HomeButton() -> some View {
        ZStack {
            Image(systemName: "house")
                .resizable()
                .frame(width: 25, height: 25)
        }
        .frame(width: 65, height: 65)
    }
    
    func CancelButton() -> some View {
        ZStack {
            Image(systemName: "xmark")
                .resizable()
                .frame(width: 35, height: 35)
                .aspectRatio(.zero, contentMode: .fit).contentShape(Circle())
        }
        .frame(width: 100, height: 100)
        .contentShape(Rectangle())
        .onTapGesture {
            debugPrint("-- Cancel Tapped --")
            
            withAnimation { isCollapsed.toggle() }
            withAnimation(.interactiveSpring(response: 0.35, dampingFraction: 0.8, blendDuration: 0.1).speed(0.5)) {
                offsetOne  = isCollapsed ? CGSize(width: 0, height: -120) : .zero
                offsetTwo  = isCollapsed ? CGSize(width: 0, height: -205) : .zero
            }
        }
    }

    func SettingsButton() -> some View {
        ZStack {
            Image(systemName: "gear")
                .resizable()
                .frame(width: 28, height: 28)
        }
        .frame(width: 65, height: 65)
    }
}


#if DEBUG
struct LiquidMenuButtons_Previews: PreviewProvider {
    static var previews: some View {
        LiquidMenuButtons()
    }
}
#endif
