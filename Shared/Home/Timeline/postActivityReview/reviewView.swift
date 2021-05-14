//
//  secondStepView.swift
//  saucialApp
//
//  Created by kawayuta on 4/23/21.
//

import SwiftUI
import Combine

struct reviewView: View {
    
    @StateObject var viewModel: ReviewViewModel
    
    init(viewModel: ReviewViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        VStack {
            valuationView(viewModel: viewModel)
        }
    }
}

struct valuationView: View {
    let mainColor = Color.Neumorphic.main
    @StateObject var viewModel: ReviewViewModel
    
    init(viewModel: ReviewViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            
            Rectangle().foregroundColor(Color(hex:"ddd")).frame(height: 1)
                .padding(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15))
            cleanliness.padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
            customerService.padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
            equipment.padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
            customerManner.padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
            costPerformance.padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
        }
    }
    
    var cleanliness: some View {
        HStack {
            Text("清潔感").font(.title2, weight: .bold).foregroundColor(Color(hex: "44556b"))
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
            Spacer()
            HStack {
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    viewModel.paramsCleanlinessValue == 1 ? (viewModel.paramsCleanlinessValue = 1) : (viewModel.paramsCleanlinessValue -= 1)
                }) { Image(systemName: "minus").frame(width: 40, height: 40) }
                .foregroundColor(viewModel.paramsCleanlinessValue == 1 ? .white : .white)
                .background(RoundedRectangle(cornerRadius: 20)
                                .fill(viewModel.paramsCleanlinessValue == 1 ? Color.gray : Color.blue)
                                .softOuterShadow())
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                
                Text(String(viewModel.paramsCleanlinessValue)).font(.title, weight: .bold).frame(width: 30)
                
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    viewModel.paramsCleanlinessValue == 5 ? (viewModel.paramsCleanlinessValue = 5) : (viewModel.paramsCleanlinessValue += 1)
                }) { Image(systemName: "plus").frame(width: 40, height: 40) }
                .foregroundColor(viewModel.paramsCleanlinessValue == 5 ? .white : .white)
                .background(RoundedRectangle(cornerRadius: 20)
                                .fill(viewModel.paramsCleanlinessValue == 5 ? Color.gray : Color.blue)
                                .softOuterShadow())
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
            }
        }
        .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
        .background(RoundedRectangle(cornerRadius: 20).fill(mainColor).softOuterShadow())
        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
    }
    
    var customerService: some View {
        HStack {
            Text("接客").font(.title2, weight: .bold).foregroundColor(Color(hex: "44556b"))
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
            Spacer()
            HStack {
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    viewModel.paramsCustomerServiceValue == 1 ? (viewModel.paramsCustomerServiceValue = 1) : (viewModel.paramsCustomerServiceValue -= 1)
                }) { Image(systemName: "minus").frame(width: 40, height: 40) }
                .foregroundColor(viewModel.paramsCustomerServiceValue == 1 ? .white : .white)
                .background(RoundedRectangle(cornerRadius: 20)
                                .fill(viewModel.paramsCustomerServiceValue == 1 ? Color.gray : Color.blue)
                                .softOuterShadow())
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                
                Text(String(viewModel.paramsCustomerServiceValue)).font(.title, weight: .bold).frame(width: 30)
                
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    viewModel.paramsCustomerServiceValue == 5 ? (viewModel.paramsCustomerServiceValue = 5) : (viewModel.paramsCustomerServiceValue += 1)
                }) { Image(systemName: "plus").frame(width: 40, height: 40) }
                .foregroundColor(viewModel.paramsCustomerServiceValue == 5 ? .white : .white)
                .background(RoundedRectangle(cornerRadius: 20)
                                .fill(viewModel.paramsCustomerServiceValue == 5 ? Color.gray : Color.blue)
                                .softOuterShadow())
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
            }
        }
        .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
        .background(RoundedRectangle(cornerRadius: 20).fill(mainColor).softOuterShadow())
        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
    }
    var equipment: some View {
        HStack {
            Text("設備").font(.title2, weight: .bold).foregroundColor(Color(hex: "44556b"))
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
            Spacer()
            HStack {
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    viewModel.paramsEquipmentValue == 1 ? (viewModel.paramsEquipmentValue = 1) : (viewModel.paramsEquipmentValue -= 1)
                }) { Image(systemName: "minus").frame(width: 40, height: 40) }
                .foregroundColor(viewModel.paramsEquipmentValue == 1 ? .white : .white)
                .background(RoundedRectangle(cornerRadius: 20)
                                .fill(viewModel.paramsEquipmentValue == 1 ? Color.gray : Color.blue)
                                .softOuterShadow())
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                
                Text(String(viewModel.paramsEquipmentValue)).font(.title, weight: .bold).frame(width: 30)
                
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    viewModel.paramsEquipmentValue == 5 ? (viewModel.paramsEquipmentValue = 5) : (viewModel.paramsEquipmentValue += 1)
                }) { Image(systemName: "plus").frame(width: 40, height: 40) }
                .foregroundColor(viewModel.paramsEquipmentValue == 5 ? .white : .white)
                .background(RoundedRectangle(cornerRadius: 20)
                                .fill(viewModel.paramsEquipmentValue == 5 ? Color.gray : Color.blue)
                                .softOuterShadow())
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
            }
        }
        .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
        .background(RoundedRectangle(cornerRadius: 20).fill(mainColor).softOuterShadow())
        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
    }
    
    var customerManner: some View {
        HStack {
            Text("お客マナー").font(.title2, weight: .bold).foregroundColor(Color(hex: "44556b"))
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
            Spacer()
            HStack {
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    viewModel.paramsCustomerMannerValue == 1 ? (viewModel.paramsCustomerMannerValue = 1) : (viewModel.paramsCustomerMannerValue -= 1)
                }) { Image(systemName: "minus").frame(width: 40, height: 40) }
                .foregroundColor(viewModel.paramsCustomerMannerValue == 1 ? .white : .white)
                .background(RoundedRectangle(cornerRadius: 20)
                                .fill(viewModel.paramsCustomerMannerValue == 1 ? Color.gray : Color.blue)
                                .softOuterShadow())
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                
                Text(String(viewModel.paramsCustomerMannerValue)).font(.title, weight: .bold).frame(width: 30)
                
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    viewModel.paramsCustomerMannerValue == 5 ? (viewModel.paramsCustomerMannerValue = 5) : (viewModel.paramsCustomerMannerValue += 1)
                }) { Image(systemName: "plus").frame(width: 40, height: 40) }
                .foregroundColor(viewModel.paramsCustomerMannerValue == 5 ? .white : .white)
                .background(RoundedRectangle(cornerRadius: 20)
                                .fill(viewModel.paramsCustomerMannerValue == 5 ? Color.gray : Color.blue)
                                .softOuterShadow())
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
            }
        }
        .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
        .background(RoundedRectangle(cornerRadius: 20).fill(mainColor).softOuterShadow())
        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
    }
    
    var costPerformance: some View {
        HStack {
            Text("コストパフォーマンス").font(.title3, weight: .bold).foregroundColor(Color(hex: "44556b"))
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
            Spacer()
            HStack {
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    viewModel.paramsCostPerformanceValue == 1 ? (viewModel.paramsCostPerformanceValue = 1) : (viewModel.paramsCostPerformanceValue -= 1)
                }) { Image(systemName: "minus").frame(width: 40, height: 40) }
                .foregroundColor(viewModel.paramsCostPerformanceValue == 1 ? .white : .white)
                .background(RoundedRectangle(cornerRadius: 20)
                                .fill(viewModel.paramsCostPerformanceValue == 1 ? Color.gray : Color.blue)
                                .softOuterShadow())
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                
                Text(String(viewModel.paramsCostPerformanceValue)).font(.title, weight: .bold).frame(width: 30)
                
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    viewModel.paramsCostPerformanceValue == 5 ? (viewModel.paramsCostPerformanceValue = 5) : (viewModel.paramsCostPerformanceValue += 1)
                }) { Image(systemName: "plus").frame(width: 40, height: 40) }
                .foregroundColor(viewModel.paramsCostPerformanceValue == 5 ? .white : .white)
                .background(RoundedRectangle(cornerRadius: 20)
                                .fill(viewModel.paramsCostPerformanceValue == 5 ? Color.gray : Color.blue)
                                .softOuterShadow())
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
            }
        }
        .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
        .background(RoundedRectangle(cornerRadius: 20).fill(mainColor).softOuterShadow())
        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
    }
}
