//
//  TabBar.swift
//  PlantManiac
//
//  Created by ASELab on 28.07.2025..
//

import SwiftUI


enum TabItem : String, CaseIterable{
    case home = "HomeIcon"
    case liked = "LikedIcon"
    case scan = "ScanPlantIcon"
    case diary = "DiaryIcon"
    case profile = "UserProfile"
}

struct FloatingTabShape: Shape {
    var centerX: CGFloat
    var curveWidth: CGFloat = 70
    var curveHeight: CGFloat = 30

    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height

        let leftCurveStart = centerX - curveWidth / 2
        let rightCurveEnd = centerX + curveWidth / 2

        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: leftCurveStart, y: 0))

        path.addQuadCurve(
            to: CGPoint(x: rightCurveEnd, y: 0),
            control: CGPoint(x: centerX, y: curveHeight)
        )
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()

        return path
    }
}


struct CustomTabBar: View {
    @Binding var selected: TabItem
    @Namespace private var animation

    var body: some View {
        GeometryReader { geo in
            let tabCount = CGFloat(TabItem.allCases.count)
            let tabWidth = geo.size.width / tabCount

            
            let selectedIndex = CGFloat(TabItem.allCases.firstIndex(of: selected) ?? 0)
            let centerX = tabWidth * selectedIndex + tabWidth / 2

            ZStack(alignment: .bottom){
                Color.clear
                .background(
                    Color.button
                            .clipShape(FloatingTabShape(centerX: centerX))
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: -2)
                )
            }
           
            HStack(spacing: 0) {
                    ForEach(TabItem.allCases, id: \.self) { tab in
                        Button {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                selected = tab
                            }
                        } label: {
                            ZStack {
                                if selected == tab {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(Color.tabSelect)
                                        .frame(width: 60, height: 50)
                                        .offset(y: -5)
                                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                                        .matchedGeometryEffect(id: "background", in: animation)
                                }

                                Image(tab.rawValue)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(selected == tab ? .white : .black)
                                    .offset(y: selected == tab ? -2 : 0)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                .padding(.horizontal)
                .frame(height: 50)
            }
            .frame(height: 70)
            .offset(y: -10)
            .padding(.top, 10)
        }
        .cornerRadius(20)
        .padding()
        .frame(height: 100)
    }

}
