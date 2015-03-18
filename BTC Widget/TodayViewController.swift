//
//  TodayViewController.swift
//  BTC Widget
//
//  Created by Auralog on 15/3/18.
//  Copyright (c) 2015年 Ray Wenderlich. All rights reserved.
//

import UIKit
import NotificationCenter
import CryptoCurrencyKit

class TodayViewController: CurrencyDataViewController, NCWidgetProviding {
    
    @IBOutlet weak var toggleLineChartButton: UIButton!
    @IBOutlet weak var lineChartHeightConstrait: NSLayoutConstraint!
    
    var lineChartIsVisible : Bool  = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        lineChartHeightConstrait.constant = 0
        lineChartView.delegate = self
        lineChartView.dataSource = self
        
        priceLabel.text = "- -"
        priceChangeLabel.text = "- -"
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchPrices { (error) -> () in
            if error == nil {
                self.updatePriceLabel()
                self.updatePriceChangeLabel()
                self.updatePriceHistoryLineChart()
            }
        }
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        println(__FUNCTION__)
        self.updatePriceHistoryLineChart()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        fetchPrices { (error) -> () in
            if error == nil {
                self.updatePriceLabel()
                self.updatePriceChangeLabel()
                self.updatePriceHistoryLineChart()
                completionHandler(.NewData)
            }else {
                completionHandler(.NoData)
            }
        }
    }
    
    @IBAction func toggleLineChart(sender: AnyObject) {
        if lineChartIsVisible{
            lineChartHeightConstrait.constant = 0
            let transform = CGAffineTransformMakeRotation(0)
            toggleLineChartButton.transform = transform
            lineChartIsVisible = false
        }else{
            lineChartHeightConstrait.constant = 98
            let transform = CGAffineTransformMakeRotation(CGFloat(180.0 * M_PI / 180.0))
            toggleLineChartButton.transform = transform
            lineChartIsVisible = true
        }
    }
    
    override func lineChartView(lineChartView: JBLineChartView!, colorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        return UIColor(red: 0.17, green: 0.49, blue: 0.82, alpha: 1.0)
    }
}
