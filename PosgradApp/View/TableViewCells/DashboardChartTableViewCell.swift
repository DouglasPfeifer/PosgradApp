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
    func changeChartType(cellRow: Int, completion: @escaping (Chart) -> ())
}

class DashboardChartTableViewCell: UITableViewCell, ChartViewDelegate {

    @IBOutlet weak var configButton: UIButton!
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var teamLabel: UILabel!
    
    var chartInView = BarLineChartViewBase()
    var indexPathRow : Int!
    
    weak var delegate: ClassDashboardCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func configButton(_ sender: Any) {
        delegate!.changeChartType(cellRow: indexPathRow, completion: {
            (newChart) in
            let removableView = self.chartView.viewWithTag(101)
            removableView?.removeFromSuperview()
            
            if newChart.lineChartShouldBeActive {
                self.configButton.setImage(UIImage(named:"bar_chart_black_48dp")?.withRenderingMode(.alwaysTemplate), for: .normal)
            } else {
                self.configButton.setImage(UIImage(named:"show_chart_black_48dp")?.withRenderingMode(.alwaysTemplate), for: .normal)
            }
            
            self.chartInView = newChart.activeChart
            self.chartInView.tag = 101
            self.chartView.addSubview(self.chartInView)
            self.chartInView.translatesAutoresizingMaskIntoConstraints = false
            self.chartInView.topAnchor.constraint(equalTo: self.chartView.topAnchor, constant: 0).isActive = true
            self.chartInView.leftAnchor.constraint(equalTo: self.chartView.leftAnchor, constant: 0).isActive = true
            self.chartInView.rightAnchor.constraint(equalTo: self.chartView.rightAnchor, constant: 0).isActive = true
            self.chartInView.bottomAnchor.constraint(equalTo: self.chartView.bottomAnchor, constant: 0).isActive = true
            self.chartInView.delegate = self
            self.chartInView.setNeedsDisplay()
            self.chartInView.animate(yAxisDuration: 1)
        })
    }
    
    func initChart(chart: Chart, indexPathRow: Int) {
        self.indexPathRow = indexPathRow
        
        let removableView = chartView.viewWithTag(101)
        removableView?.removeFromSuperview()
        
        self.chartInView = chart.activeChart
        self.chartInView.tag = 101
        self.chartView.addSubview(self.chartInView)
        self.chartInView.translatesAutoresizingMaskIntoConstraints = false
        self.chartInView.topAnchor.constraint(equalTo: self.chartView.topAnchor, constant: 0).isActive = true
        self.chartInView.leftAnchor.constraint(equalTo: self.chartView.leftAnchor, constant: 0).isActive = true
        self.chartInView.rightAnchor.constraint(equalTo: self.chartView.rightAnchor, constant: 0).isActive = true
        self.chartInView.bottomAnchor.constraint(equalTo: self.chartView.bottomAnchor, constant: 0).isActive = true
        self.chartInView.delegate = self
        self.chartInView.setNeedsDisplay()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        delegate?.segueToMissionDetail(mission: entry.x, points: entry.y)
    }
}
