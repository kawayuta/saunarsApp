//
//  ActivityView.swift
//  saucialApp
//
//  Created by kawayuta on 5/17/21.
//

import SwiftUI
import SwiftUICharts


struct ActivityView: View {
    
    @EnvironmentObject var viewModel:UserViewModel
    
    var body: some View {
        ScrollView {
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    if let user = viewModel.user {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("今月のサ活").font(.title, weight: .bold).foregroundColor(.white)
                                .padding(EdgeInsets(top: 5, leading: 0, bottom: 15, trailing: 0))
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("サ活").foregroundColor(.white)
                                        .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                                        .font(.headline)
                                    HStack(alignment: .bottom) {
                                        Text("\(user.activities_month.count)")
                                            .font(.system(size: 50), weight: .bold)
                                        Text("回").font(.subheadline)
                                    }.foregroundColor(.white)
                                }
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("施設数").foregroundColor(.white)
                                        .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                                        .font(.headline)
                                    HStack(alignment: .bottom) {
                                        Text("\(viewModel.activities_month_sauna.reduce([], { $0.contains($1) ? $0 : $0 + [$1] }).count)")
                                            .font(.system(size: 50), weight: .bold)
                                        Text("施設").font(.subheadline)
                                    }.foregroundColor(.white)
                                }
                                Spacer()
                            }
                        }
                        .padding(15)
                        .background(.blue)
                        .cornerRadius(15)
                        .padding(10)
                        
                    }
                    
                    if let user = viewModel.user {
                        if user.activities_month.count < 3 {
                            HStack(alignment: .center, spacing: 0) {
                                Text("サ活の投稿が少ないようです").font(.title3, weight: .bold).foregroundColor(.white)
                                Spacer()
                            }
                            .padding(15)
                            .background(.red)
                            .cornerRadius(15)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 15, trailing: 10))
                        }
                    }
                    
                    ActivityInfo
                }
        }
        .onAppear() {
            viewModel.fetchUser()
        }
       
    }
    
    
    var ActivityInfo: some View {
        VStack {
            if let user = viewModel.user {
                VStack(alignment: .leading, spacing: 0) {
                    Text("ととのいルーティン").font(.title, weight: .bold).foregroundColor(.black)
                        .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
                    
                    ScrollView(.horizontal) {
                        HStack(alignment: .bottom) {
                            if let activities_month = user.activities_month.reversed() {
                                ForEach(activities_month.indices, id: \.self) { index in
                                    VStack(spacing: 0) {
                                        ForEach(0..<activities_month[index].rest_count, id: \.self) { cindex in
                                            BarView(count: CGFloat(5), color: .orange)
                                                .overlay(RoundedRectangle(cornerRadius: 0).stroke(Color(hex:"ddd"), lineWidth: 1))
                                        }
                                        ForEach(0..<activities_month[index].mizuburo_count, id: \.self) { cindex in
                                            BarView(count: CGFloat(5), color: .blue)
                                                .overlay(RoundedRectangle(cornerRadius: 0).stroke(Color(hex:"ddd"), lineWidth: 1))
                                        }
                                        ForEach(0..<activities_month[index].sauna_count, id: \.self) { cindex in
                                            BarView(count: CGFloat(5), color: .red)
                                                .overlay(RoundedRectangle(cornerRadius: 0).stroke(Color(hex:"ddd"), lineWidth: 1))
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                .background(.white)
                .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color(hex:"ddd"), lineWidth: 1))
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
            }
            
            HStack {
                LineView(data: viewModel.activities_month_sauna.count > 0 ? viewModel.activities_month_sauna : [0.0], title: "サ室の温度",
                         legend: "サ活済みのサ室の温度推移",
                         style: ChartStyle(backgroundColor: .white,
                                           accentColor: .red,
                                           gradientColor: GradientColor(start: .red, end: .orange),
                                           textColor: .red,
                                           legendTextColor: .black,
                                           dropShadowColor: .black)
                ).frame(height: 350)
                .clipped()
                
                Rectangle().foregroundColor(Color(hex:"eff2f5")).frame(width: 1)
                
                LineView(data: viewModel.activities_month_mizu.count > 0 ? viewModel.activities_month_mizu : [0.0], title: "水風呂の温度",
                         legend: "サ活済みの水風呂の温度推移",
                         style: ChartStyle(backgroundColor: .white,
                                           accentColor: .blue,
                                           gradientColor: GradientColor(start: .blue, end: .purple),
                                                             textColor: .blue,
                                                             legendTextColor: .black,
                                                             dropShadowColor: .black)
                ).frame(height: 350)
                .clipped()
            }.frame(height: 350)
            .padding(10)
            .background(.white)
            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color(hex:"ddd"), lineWidth: 1))
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
            
            Spacer()
        }
    }
}

struct BarView: View {
    let count: CGFloat
    let color: Color
    init(count: CGFloat, color: Color) {
        self.count = count
        self.color = color
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle().frame(width: 30, height: count)
                .foregroundColor(color)
           
        }
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
