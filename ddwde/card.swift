//
//  card.swift
//  ddwde
//
//  Created by Mohammad Muksith on 5/5/23.
//

import SwiftUI

struct Flip: GeometryEffect{
    var animatableData: Double{
        get { angle }
        set { angle = newValue}
    }
    @Binding var flipped: Bool
    var angle: Double
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        
        DispatchQueue.main.async{
            flipped = angle >= 90 && angle < 270
        }
        let newAngle = flipped ? -180 + angle : angle
        let angleInRadians = CGFloat(Angle(degrees: newAngle).radians)
        var transformed = CATransform3DIdentity
        transformed.m34 = -1/max(size.width, size.height)
        transformed = CATransform3DRotate(transformed, angleInRadians, 0, 1, 0)
        transformed = CATransform3DTranslate(transformed, -size.width / 2, -size.height/2, 0)
        let affineTranform = ProjectionTransform(CGAffineTransform(translationX: size.width/2, y:  size.height/2))
        return ProjectionTransform(transformed).concatenating(affineTranform)
    }
}
struct Card: View{
    var title = ""
    var description = ""
    var icon = ""
    
    var body: some View{
        RoundedRectangle(cornerRadius: 10)
            .fill(LinearGradient(gradient: Gradient(colors: [Color.white,Color.cyan]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .frame(width: 350, height: 650)
            .shadow(radius: 10)
            .overlay(
                VStack(alignment: icon != "" ? .center : .leading, spacing: 10){
                    if icon != "" {
                        Image(icon)
                            .resizable()
                            .scaledToFit()
                            .padding()
                    }
                    Text(title)
                        .font(.title2)
                        .foregroundColor(.white)
                    if description != "" {
                        Text(description)
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
            )
    }
}

struct CustomView: View {
    @State var flippled = false
    @State var flip = false
    var body: some View {
        ZStack{
            Card(title: "Card", description: "Something")
                .opacity(flippled ? 0 : 1)
            Card(title: "card", icon: "a")
                .opacity(flippled ? 1 : 0)
        }
        .modifier(Flip(flipped: $flippled, angle: flip ? 0:180))
        .onTapGesture(count: 1, perform: {
            withAnimation{
                flip.toggle()
            }
        })
    }
}




struct CustomViewsz_Previews: PreviewProvider {
    static var previews: some View {
        CustomView()
    }
}
