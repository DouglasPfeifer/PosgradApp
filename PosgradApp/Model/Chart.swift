//
//  Chart.swift
//  PosgradApp
//
//  Created by Douglas Toneto Pfeifer on 16/02/19.
//  Copyright © 2019 Douglas Tonetto Pfeifer. All rights reserved.
//

import Foundation
import UIKit
import Charts

struct DefaultMissions {
    static let order = ["Missão Discovery",
                        "Missão Startup",
                        "Missão Passport",
                        "Missão Curiosity"]
}

class Chart: NSObject {
    
    var chartBackgroundColor = UIColor.white
    var chartLineColor = UIColor.green
    var chartCircleColor = UIColor.white
    var chartCircleHoleColor = UIColor.green
    var topGradientHexColor = "#434343"
    var bottomGradientHexColor = "#FFFFFF"
    var axisTextColor = UIColor.black
    var leftAxisFont = UIFont.systemFont(ofSize: 11)
    var xAxisFont = UIFont.systemFont(ofSize: 11)
    
    var chartBarColor = UIColor.black
    var chartBorderColor = UIColor.green
    var chartValueColor = UIColor.black
    
    let sliderX = 4
    var sliderY = [String: Double]()
    
    var lineChartShouldBeActive = true
    
    func initLineChartView(chartBackgroundColor: UIColor, chartLineColor: UIColor, chartCircleColor: UIColor, chartCircleHoleColor: UIColor, topGradientHexColor: String, bottomGradientHexColor: String, axisTextColor: UIColor, leftAxisFont: UIFont, xAxisFont: UIFont, chartBarColor: UIColor, chartBorderColor: UIColor, chartValueColor: UIColor, sliderY: [String: Double]) -> LineChartView {
        
        self.chartBackgroundColor = chartBackgroundColor
        self.chartLineColor = chartLineColor
        self.chartCircleColor = chartCircleColor
        self.chartCircleHoleColor = chartCircleHoleColor
        self.topGradientHexColor = topGradientHexColor
        self.bottomGradientHexColor = bottomGradientHexColor
        self.axisTextColor = axisTextColor
        self.leftAxisFont = leftAxisFont
        self.xAxisFont = xAxisFont
        
        self.chartBarColor = chartBarColor
        self.chartBorderColor = chartBorderColor
        self.chartValueColor = chartValueColor
        
        self.sliderY = sliderY
        
        let lineChartView = LineChartView()
        
        lineChartView.highlightPerDragEnabled = false
        lineChartView.chartDescription?.enabled = false
        lineChartView.legend.enabled = false
        lineChartView.rightAxis.enabled = true
        lineChartView.rightAxis.axisMinimum = 0
        //lineChartView.rightAxis.gridLineDashLengths = [0, 0]
        lineChartView.rightAxis.drawAxisLineEnabled = false
        lineChartView.rightAxis.drawGridLinesEnabled = false
        lineChartView.rightAxis.labelTextColor = UIColor.clear
        
        lineChartView.leftAxis.enabled = true
        lineChartView.leftAxis.axisMinimum = 0
        //lineChartView.leftAxis.gridLineDashLengths = [0, 0]
        lineChartView.leftAxis.drawAxisLineEnabled = false
        lineChartView.leftAxis.gridColor = UIColor.lightGray
        lineChartView.leftAxis.labelTextColor = axisTextColor
        lineChartView.leftAxis.labelFont = leftAxisFont
        lineChartView.leftAxis.drawLimitLinesBehindDataEnabled = false
        
        lineChartView.xAxis.enabled = true
        lineChartView.xAxis.granularity = 1
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.drawAxisLineEnabled = false
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.labelTextColor = axisTextColor
        lineChartView.xAxis.labelFont = xAxisFont
        lineChartView.xAxis.valueFormatter = DayAxisValueFormatter(chart: lineChartView)
        
        lineChartView.backgroundColor = chartBackgroundColor
        
        /*
        let marker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1),
                                   font: .systemFont(ofSize: 12),
                                   textColor: .white,
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = lineChartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        lineChartView.marker = marker
        */
        
        var maxY = 0.0
        let values = (0..<sliderX).map { (i) -> ChartDataEntry in
            if maxY < sliderY[DefaultMissions.order[i]]! {
                maxY = sliderY[DefaultMissions.order[i]]!
            }
            return ChartDataEntry(x: Double(i), y: sliderY[DefaultMissions.order[i]]!, icon: nil)
        }
        lineChartView.leftAxis.axisMaximum = maxY + 20
        
        let set1 = LineChartDataSet(values: values, label: "")
        set1.drawIconsEnabled = false
        //set1.lineDashLengths = [0, 0]
        set1.setColor(chartLineColor)
        set1.setCircleColor(chartCircleColor)
        set1.lineWidth = 1
        set1.circleRadius = 4
        set1.highlightColor = UIColor.clear
        set1.drawCircleHoleEnabled = true
        set1.circleHoleColor = chartCircleHoleColor
        set1.circleHoleRadius = 2
        set1.valueFont = UIFont.boldSystemFont(ofSize: 12)
        set1.valueColors = [chartValueColor as NSUIColor]
        
        let gradientColors = [ChartColorTemplates.colorFromString(bottomGradientHexColor).cgColor,
                              ChartColorTemplates.colorFromString(topGradientHexColor).cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        set1.fillAlpha = 0.5
        set1.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
        
        let data = LineChartData(dataSet: set1)
        
        lineChartView.data = data
        
        for set in lineChartView.data!.dataSets {
            set.drawValuesEnabled = false
            set.drawValuesEnabled = true
        }
        
        for set in lineChartView.data!.dataSets as! [LineChartDataSet] {
            set.drawFilledEnabled = true
            set.drawCirclesEnabled = true
            set.mode = (set.mode == .cubicBezier) ? .linear : .cubicBezier
        }
        
        return lineChartView
    }
    
    func initBarChartView(chartBackgroundColor: UIColor, chartBarColor: UIColor, chartBorderColor: UIColor, axisTextColor: UIColor, leftAxisFont: UIFont, xAxisFont: UIFont, chartValueColor: UIColor, sliderY: [String: Double]) -> BarChartView {
        
        let barChartView = BarChartView()
        barChartView.highlightPerDragEnabled = false
        barChartView.chartDescription?.enabled = false
        barChartView.legend.enabled = false
        barChartView.rightAxis.enabled = true
        barChartView.rightAxis.axisMinimum = 0
        //barChartView.rightAxis.gridLineDashLengths = [0, 0]
        barChartView.rightAxis.drawAxisLineEnabled = false
        barChartView.rightAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.labelTextColor = UIColor.clear
        
        barChartView.leftAxis.enabled = true
        barChartView.leftAxis.axisMinimum = 0
        //barChartView.leftAxis.gridLineDashLengths = [0, 0]
        barChartView.leftAxis.drawAxisLineEnabled = false
        barChartView.leftAxis.gridColor = UIColor.lightGray
        barChartView.leftAxis.labelTextColor = axisTextColor
        barChartView.leftAxis.labelFont = leftAxisFont
        barChartView.leftAxis.drawLimitLinesBehindDataEnabled = false
        
        barChartView.xAxis.enabled = true
        barChartView.xAxis.granularity = 1
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.drawAxisLineEnabled = false
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.labelTextColor = axisTextColor
        barChartView.xAxis.labelFont = xAxisFont
        barChartView.xAxis.valueFormatter = DayAxisValueFormatter(chart: barChartView)
        
        barChartView.backgroundColor = chartBackgroundColor
        
        /*
        let marker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1),
                                   font: .systemFont(ofSize: 12),
                                   textColor: .white,
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = barChartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        barChartView.marker = marker
        */
        
        var maxY = 0.0
        let yVals = (0..<sliderX).map { (i) -> BarChartDataEntry in
            if maxY < sliderY[DefaultMissions.order[i]]! {
                maxY = sliderY[DefaultMissions.order[i]]!
            }
            return BarChartDataEntry(x: Double(i), y: sliderY[DefaultMissions.order[i]]!)
        }
        barChartView.leftAxis.axisMaximum = maxY + 20
        
        var set1: BarChartDataSet! = nil
        set1 = BarChartDataSet(values: yVals, label: "")
        //        set1.colors = ChartColorTemplates.material()
        set1.drawValuesEnabled = false
        
        let data = BarChartData(dataSet: set1)
        data.barWidth = 0.9
        barChartView.data = data
        
        set1.drawIconsEnabled = false
        set1.setColor(chartBarColor, alpha: 0.5)
        set1.valueFont = UIFont.boldSystemFont(ofSize: 12)
        set1.valueColors = [chartValueColor as NSUIColor]
        
        for set in barChartView.data!.dataSets {
            if let set = set as? BarChartDataSet {
                set.barBorderWidth = set.barBorderWidth == 2.0 ? 0.0 : 2.0
                set.barBorderColor = chartBorderColor
                set.drawValuesEnabled = true
            }
        }
                
        return barChartView
    }
    
    func changeToLineChart () -> LineChartView {
        
        let lineChartView = initLineChartView(chartBackgroundColor: chartBackgroundColor, chartLineColor: chartLineColor, chartCircleColor: chartCircleColor, chartCircleHoleColor: chartCircleHoleColor, topGradientHexColor: topGradientHexColor, bottomGradientHexColor: bottomGradientHexColor, axisTextColor: axisTextColor, leftAxisFont: leftAxisFont, xAxisFont: xAxisFont, chartBarColor: chartBarColor, chartBorderColor: chartBorderColor, chartValueColor: chartValueColor, sliderY: sliderY)
        
        return lineChartView
    }
    
    func changeToBarChart () -> BarChartView {
        let barChartView = initBarChartView(chartBackgroundColor: chartBackgroundColor, chartBarColor: chartBarColor, chartBorderColor: chartBorderColor, axisTextColor: axisTextColor, leftAxisFont: leftAxisFont, xAxisFont: xAxisFont, chartValueColor: chartValueColor, sliderY: sliderY)
        return barChartView
    }
}

public class DayAxisValueFormatter: NSObject, IAxisValueFormatter {
    weak var chart: BarLineChartViewBase?
    
    let sliderXNames = ["Discovery",
                        "Startup",
                        "Passport",
                        "Curiosity"]
    
    init(chart: BarLineChartViewBase) {
        self.chart = chart
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return sliderXNames[Int(value)]
    }
}
