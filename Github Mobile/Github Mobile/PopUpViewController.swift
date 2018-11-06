//
//  PopUpViewController.swift
//  Github Mobile
//
//  Created by 张瑞麟 on 11/5/18.
//  Copyright © 2018 张瑞麟. All rights reserved.
//

import UIKit
import Charts

class PopUpViewController: UIViewController {

    @IBOutlet weak var bar1: BarChartView!
    @IBOutlet weak var bar2: BarChartView!
    
    var time : [String] = []
    var time_val : [Int] = []
    var month : [String] = []
    var month_val : [Int] = []
    
    @IBAction func buttonClicked(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    func setChart(x: [String], y: [Int], bar1: Bool){
        var bar : BarChartView
        var label : String
        if bar1 == true{
            bar = self.bar1
            label = "Commits vs Time"
        }else{
            bar = self.bar2
            label = "Commits vs Month"
        }
        bar.noDataText = "This is a shitty library. Don't Use."
        let values = (0..<x.count).map { (i) -> BarChartDataEntry in
            return BarChartDataEntry(x: Double(i), y: Double(y[i]))
        }
        let set1 = BarChartDataSet(values: values, label: label)
        set1.colors = ChartColorTemplates.colorful()
        
        bar.xAxis.valueFormatter = IndexAxisValueFormatter(values:x)
        bar.xAxis.granularity = 1
        bar.backgroundColor = .white
        bar.rightAxis.enabled = false
        
        let data = BarChartData(dataSet: set1)
        bar.data = data
        
        bar.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        setChart(x: self.time, y: self.time_val, bar1: true)
        setChart(x: self.month, y: self.month_val, bar1: false)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.bar1.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
