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
    static let order = ["Missão Passport",
                        "Missão Curiosity",
                        "Missão Discovery",
                        "Missão Startup"]
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
    
    var activeChart = BarLineChartViewBase()
    
    func initLineChartView(chartBackgroundColor: UIColor, chartLineColor: UIColor, chartCircleColor: UIColor, chartCircleHoleColor: UIColor, topGradientHexColor: String, bottomGradientHexColor: String, axisTextColor: UIColor, leftAxisFont: UIFont, xAxisFont: UIFont, chartBarColor: UIColor, chartBorderColor: UIColor, chartValueColor: UIColor, sliderY: [String: Double]) {
        
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
        lineChartView.pinchZoomEnabled = false
        
        lineChartView.rightAxis.enabled = true
        lineChartView.rightAxis.axisMinimum = 0
        lineChartView.rightAxis.drawAxisLineEnabled = false
        lineChartView.rightAxis.drawGridLinesEnabled = false
        lineChartView.rightAxis.labelTextColor = UIColor.clear
        
        lineChartView.leftAxis.enabled = true
        lineChartView.leftAxis.axisMinimum = 0
        lineChartView.leftAxis.drawAxisLineEnabled = false
        lineChartView.leftAxis.gridColor = UIColor.lightGray
        lineChartView.leftAxis.drawLimitLinesBehindDataEnabled = false
        lineChartView.leftAxis.labelTextColor = UIColor.clear
        
        lineChartView.xAxis.enabled = true
        lineChartView.xAxis.granularity = 1
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.drawAxisLineEnabled = false
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.labelTextColor = axisTextColor
        lineChartView.xAxis.labelFont = xAxisFont
        lineChartView.xAxis.valueFormatter = MissionAxisValueFormatter(chart: lineChartView)
        
        lineChartView.backgroundColor = chartBackgroundColor
        
        var maxY = 0.0
        print(sliderY)
        let values = (0..<sliderX).map { (i) -> ChartDataEntry in
            if let iSliderY = sliderY[DefaultMissions.order[i]] {
                if maxY < iSliderY {
                    maxY = iSliderY
                }
                return ChartDataEntry(x: Double(i), y: sliderY[DefaultMissions.order[i]]!, icon: nil)
            } else {
                return ChartDataEntry(x: Double(i), y: 0.0, icon: nil)
            }
        }
        // This prevents the first letter of the first mission to be cut off, havin a 3 digit (100) axisMaximum, increases the size of the leftAxis
        if maxY == 0 {
            lineChartView.leftAxis.axisMaximum = maxY + 100
        } else {
            lineChartView.leftAxis.axisMaximum = maxY + 20
        }
        
        let set1 = LineChartDataSet(values: values, label: "")
        set1.drawIconsEnabled = false
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
        set1.fill = Fill(linearGradient: gradient, angle: 90)
        
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
        
        lineChartShouldBeActive = true
        activeChart = lineChartView
    }
    
    func initBarChartView(chartBackgroundColor: UIColor, chartBarColor: UIColor, chartBorderColor: UIColor, axisTextColor: UIColor, leftAxisFont: UIFont, xAxisFont: UIFont, chartValueColor: UIColor, sliderY: [String: Double]) {
        
        let barChartView = BarChartView()
        barChartView.highlightPerDragEnabled = false
        barChartView.chartDescription?.enabled = false
        barChartView.legend.enabled = false
        barChartView.pinchZoomEnabled = false
        
        barChartView.rightAxis.enabled = true
        barChartView.rightAxis.axisMinimum = 0
        barChartView.rightAxis.drawAxisLineEnabled = false
        barChartView.rightAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.labelTextColor = UIColor.clear
        
        barChartView.leftAxis.enabled = true
        barChartView.leftAxis.axisMinimum = 0
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
        barChartView.xAxis.valueFormatter = MissionAxisValueFormatter(chart: barChartView)
        
        barChartView.backgroundColor = chartBackgroundColor
        
        var maxY = 0.0
        let yVals = (0..<sliderX).map { (i) -> BarChartDataEntry in
            if let sliderYMissionValue = sliderY[DefaultMissions.order[i]] {
                if maxY < sliderYMissionValue {
                    maxY = sliderYMissionValue
                }
                return BarChartDataEntry(x: Double(i), y: sliderYMissionValue)
            } else {
                maxY = 0
                return BarChartDataEntry(x: Double(i), y: 0)
            }
        }
        barChartView.leftAxis.axisMaximum = maxY + 20
        
        var set1: BarChartDataSet! = nil
        set1 = BarChartDataSet(values: yVals, label: "")
        set1.drawValuesEnabled = false
        
        let data = BarChartData(dataSet: set1)
        data.barWidth = 0.9
        barChartView.data = data
        
        set1.drawIconsEnabled = false
        set1.setColor(chartBarColor, alpha: 0.3)
        set1.valueFont = UIFont.boldSystemFont(ofSize: 12)
        set1.valueColors = [chartValueColor as NSUIColor]
        
        for set in barChartView.data!.dataSets {
            if let set = set as? BarChartDataSet {
                set.barBorderWidth = set.barBorderWidth == 2.0 ? 0.0 : 2.0
                set.barBorderColor = chartBorderColor.withAlphaComponent(0.5)
                set.drawValuesEnabled = true
            }
        }
        
        lineChartShouldBeActive = false
        activeChart = barChartView
    }
    
    func changeToLineChart () {
        initLineChartView(chartBackgroundColor: chartBackgroundColor, chartLineColor: chartLineColor, chartCircleColor: chartCircleColor, chartCircleHoleColor: chartCircleHoleColor, topGradientHexColor: topGradientHexColor, bottomGradientHexColor: bottomGradientHexColor, axisTextColor: axisTextColor, leftAxisFont: leftAxisFont, xAxisFont: xAxisFont, chartBarColor: chartBarColor, chartBorderColor: chartBorderColor, chartValueColor: chartValueColor, sliderY: sliderY)
    }
    
    func changeToBarChart () {
        initBarChartView(chartBackgroundColor: chartBackgroundColor, chartBarColor: chartBarColor, chartBorderColor: chartBorderColor, axisTextColor: axisTextColor, leftAxisFont: leftAxisFont, xAxisFont: xAxisFont, chartValueColor: chartValueColor, sliderY: sliderY)
    }
    
    func initUserTeamChart (sliderY: [String: Double]) {
        initLineChartView(chartBackgroundColor: UIColor.darkGray,
                          chartLineColor: UIColor.white,
                          chartCircleColor: UIColor.white,
                          chartCircleHoleColor: UIColor.black,
                          topGradientHexColor: "#FFFFFF",
                          bottomGradientHexColor: "#434343",
                          axisTextColor: UIColor.lightGray,
                          leftAxisFont: .boldSystemFont(ofSize: 11),
                          xAxisFont: .boldSystemFont(ofSize: 11),
                          chartBarColor: UIColor.white,
                          chartBorderColor: UIColor.white,
                          chartValueColor: UIColor.white,
                          sliderY: sliderY)
    }
    
    func initOthersTeamChart (sliderY: [String: Double]) {
        initLineChartView(chartBackgroundColor: UIColor.white,
                          chartLineColor: UIColor.black,
                          chartCircleColor: UIColor.white,
                          chartCircleHoleColor: UIColor.black,
                          topGradientHexColor: "#000000",//"#434343",
                          bottomGradientHexColor: "#FFFFFF",
                          axisTextColor: UIColor.black,
                          leftAxisFont: .systemFont(ofSize: 11),
                          xAxisFont: .systemFont(ofSize: 11),
                          chartBarColor: UIColor.black,
                          chartBorderColor: UIColor.black,
                          chartValueColor: UIColor.black,
                          sliderY: sliderY)
    }
}

public class MissionAxisValueFormatter: NSObject, IAxisValueFormatter {
    weak var chart: BarLineChartViewBase?
    
    let sliderXNames = ["Passport",
                        "Curiosity",
                        "Discovery",
                        "Startup"]
    
    init(chart: BarLineChartViewBase) {
        self.chart = chart
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return sliderXNames[Int(value)]
    }
}
