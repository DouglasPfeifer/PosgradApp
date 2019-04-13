//
//  ChartTableViewCell.swift
//  PosgradApp
//
//  Created by Douglas Toneto Pfeifer on 14/02/19.
//  Copyright © 2019 Douglas Tonetto Pfeifer. All rights reserved.
//

import UIKit
import Charts

protocol ClassDashboardCellDelegate: class {
    func segueToMissionDetail(mission: Double, points: Double)
}

class DashboardChartTableViewCell: UITableViewCell, ChartViewDelegate {

    @IBOutlet weak var configButton: UIButton!
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var teamLabel: UILabel!
    
    var cellChart = Chart()
    var chartInView = BarLineChartViewBase()
    var lineChartShouldBeActive = true
    
    weak var delegate: ClassDashboardCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("/////////////////")
        print("lineChartShouldBeActive: ", lineChartShouldBeActive)
    }
    
    @IBAction func configButton(_ sender: Any) {
        lineChartShouldBeActive = !lineChartShouldBeActive
        let removableView = chartView.viewWithTag(101)
        removableView?.removeFromSuperview()
        
        if lineChartShouldBeActive {
            chartInView = cellChart.changeToLineChart()
            configButton.setImage(UIImage(named:"bar_chart_black_48dp")?.withRenderingMode(.alwaysTemplate), for: .normal)
        } else {
            chartInView = cellChart.changeToBarChart()
            configButton.setImage(UIImage(named:"show_chart_black_48dp")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        
        chartInView.tag = 101
        self.chartView.addSubview(chartInView)
        chartInView.translatesAutoresizingMaskIntoConstraints = false
        chartInView.topAnchor.constraint(equalTo: self.chartView.topAnchor, constant: 0).isActive = true
        chartInView.leftAnchor.constraint(equalTo: self.chartView.leftAnchor, constant: 0).isActive = true
        chartInView.rightAnchor.constraint(equalTo: self.chartView.rightAnchor, constant: 0).isActive = true
        chartInView.bottomAnchor.constraint(equalTo: self.chartView.bottomAnchor, constant: 0).isActive = true
        chartInView.delegate = self
        chartInView.setNeedsDisplay()
        chartInView.animate(yAxisDuration: 1)
    }
    
    func initChart(chart: BarLineChartViewBase) {
        
        chartInView.data = nil
        
        let removableView = chartView.viewWithTag(101)
        removableView?.removeFromSuperview()
        
        chartInView = chart
        
        chartInView.tag = 101
        self.chartView.addSubview(chartInView)
        chartInView.translatesAutoresizingMaskIntoConstraints = false
        chartInView.topAnchor.constraint(equalTo: self.chartView.topAnchor, constant: 0).isActive = true
        chartInView.leftAnchor.constraint(equalTo: self.chartView.leftAnchor, constant: 0).isActive = true
        chartInView.rightAnchor.constraint(equalTo: self.chartView.rightAnchor, constant: 0).isActive = true
        chartInView.bottomAnchor.constraint(equalTo: self.chartView.bottomAnchor, constant: 0).isActive = true
        chartInView.delegate = self
        chartInView.setNeedsDisplay()
        // chartInView.animate(yAxisDuration: 1)
        
        print("----------")
        print("lineChartShouldBeActive: ", lineChartShouldBeActive)
        print("chart.backgroundColor: ", chart.backgroundColor)
        print("cellChart: ", cellChart.chartBackgroundColor)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        delegate?.segueToMissionDetail(mission: entry.x, points: entry.y)
    }
}
