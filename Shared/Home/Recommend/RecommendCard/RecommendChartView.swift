//
//  RecommendChartView.swift
//  saucialApp (iOS)
//
//  Created by kawayuta on 4/30/21.
//

import SwiftUI
import Charts

struct RecommendChartView: UIViewRepresentable {
    
    var reviews: [Review] = []
    let activities = ["清潔感", "接客", "設備", "お客マナー", "コスパ"]
    
    
    func makeUIView(context: Context) -> RadarChartView {
        return RadarChartView()
    }
    
    func updateUIView(_ uiView: RadarChartView, context: Context) {
        
        var cleanlinessAverage:Int = 0
        var customerServiceAverage:Int = 0
        var equipmentAverage:Int = 0
        var customerMannerAverage:Int = 0
        var costPerformanceAverage:Int = 0
        
        reviews.forEach {
            cleanlinessAverage += $0.cleanliness
            customerServiceAverage += $0.customer_service
            equipmentAverage += $0.equipment
            customerMannerAverage += $0.customer_manner
            costPerformanceAverage += $0.cost_performance
        }
        if cleanlinessAverage != 0 {
            cleanlinessAverage /= reviews.count
            customerServiceAverage /= reviews.count
            equipmentAverage /= reviews.count
            customerMannerAverage /= reviews.count
            costPerformanceAverage /= reviews.count
            print(cleanlinessAverage)
            print(customerServiceAverage)
            print(equipmentAverage)
            print(customerMannerAverage)
            print(costPerformanceAverage)
        }
        
        let entries: [RadarChartDataEntry] = [
            RadarChartDataEntry(value: Double(cleanlinessAverage)),
            RadarChartDataEntry(value: Double(customerServiceAverage)),
            RadarChartDataEntry(value: Double(equipmentAverage)),
            RadarChartDataEntry(value: Double(customerMannerAverage)),
            RadarChartDataEntry(value: Double(costPerformanceAverage))
                ]
        let dataSet = RadarChartDataSet(entries: entries)
        uiView.data = RadarChartData(dataSet: dataSet)
        uiView.chartDescription!.enabled = false
        uiView.webLineWidth = 1
        uiView.innerWebLineWidth = 1
        uiView.webColor = Color(hex: "dedede").toUIColor()!
        uiView.innerWebColor = Color(hex: "dedede").toUIColor()!
        uiView.webAlpha = 1
        
        let xAxis = uiView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 12, weight: .light)
        xAxis.xOffset = 0
        xAxis.yOffset = 0
        xAxis.spaceMin = 0
        xAxis.spaceMax = 0
        xAxis.labelTextColor = .black
        xAxis.valueFormatter = IndexAxisValueFormatter(values: activities)
        
        uiView.yAxis.enabled = false
        uiView.legend.enabled = false
        
        formatDataSet(dataSet: dataSet)
    }
    
    func formatDataSet(dataSet: RadarChartDataSet) {
        dataSet.colors = [.blue]
        dataSet.valueColors = [.clear]
        dataSet.fillColor = .blue
        dataSet.fillAlpha = 1
        dataSet.drawFilledEnabled = true
        dataSet.lineWidth = 2
        dataSet.drawHighlightCircleEnabled = false
        dataSet.setDrawHighlightIndicators(false)
        dataSet.label = "サウナ施設評価（リアルタイム） - サウナビ調べ"
    }
}
