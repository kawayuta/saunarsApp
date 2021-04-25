//
//  ReviewChartView.swift
//  saucialApp
//
//  Created by kawayuta on 4/26/21.
//

import SwiftUI
import Charts

struct ReviewChartView: UIViewRepresentable {
    
    typealias UIViewType = RadarChartView
    
    func makeUIView(context:UIViewRepresentableContext<ReviewChartView>) -> RadarChartView {
        let chartView = RadarChartView()
        
            let entries = [
                        RadarChartDataEntry(value: 40),
                        RadarChartDataEntry(value: 30),
                        RadarChartDataEntry(value: 20),
                        RadarChartDataEntry(value: 40),
                    ]
        let set = RadarChartDataSet(entries: entries, label: "Data")
        chartView.data = RadarChartData(dataSet: set)
        return chartView
    }
    
    func updateUIView(_ uiView: RadarChartView, context: Context) {
    }
}
