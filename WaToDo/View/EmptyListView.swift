//
//  EmptyListView.swift
//  WaToDo
//
//  Created by Ronald on 21/7/21.
//

import SwiftUI

struct EmptyListView: View {
    
    @State private var isAnimated: Bool = false
    
    let images: [String] = [
        "illustration-no1",
        "illustration-no2",
        "illustration-no3"
    ]
    
    let tips: [String] = [
        "Use your time wisely.",
        "Slow and steady wins the race.",
        "Keep it short and sweet.",
        "Put hard tasks first.",
        "Reward yourself after work."
    ]
    
    //Theme
    @ObservedObject var theme = ThemeSettings()
    let themes: [Theme] = themeData
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 20) {
                Image(images.randomElement() ?? self.images[0])
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 256, idealWidth: 280, maxWidth: 360, minHeight: 256, idealHeight: 280, maxHeight: 360, alignment: .center)
                    .layoutPriority(1)
                    .foregroundColor(themes[self.theme.themeSettings].themeColor)
                //layout priority will allow image to get bigger on iPad screen
                Text(tips.randomElement() ?? self.tips[0])
                    .layoutPriority(0.5)
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(themes[self.theme.themeSettings].themeColor)
            } //VStack
            .padding(.horizontal)
            .opacity(isAnimated ? 1 : 0)
            .offset(y: isAnimated ? 0 : -50)
            .onAppear(perform: {
                DispatchQueue.main.async {
                    withAnimation(.easeOut(duration: 1.0)) {
                        self.isAnimated.toggle()
                    }
                }
            })
        }//ZStack
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color("ColorBase"))
        .edgesIgnoringSafeArea(.all)
    }
}

struct EmptyListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyListView()
    }
}
