//
//  TimePickerView.swift
//  CustomTimer
//
//  Created by Eldor Makkambayev on 19.12.2023.
//

import UIKit

protocol TimePickerViewOutput: AnyObject {
    func updateTime(hour: Int, minute: Int, seconds: Int)
}

class TimePickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {

    var hour: Int = 0
    var minute: Int = 0
    var seconds: Int = 0
    
    weak var output: TimePickerViewOutput?

    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    func setup(){
        self.delegate = self
        self.dataSource = self

        let height = CGFloat(20)
        let offsetX = self.frame.size.width / 3
        let offsetY = self.frame.size.height/2 - height/2
        let marginX = CGFloat(35)
        let width = offsetX - marginX

        let hourLabel = UILabel(frame: CGRectMake(marginX, offsetY, width, height))
        hourLabel.text = "h:"
        self.addSubview(hourLabel)

        let minsLabel = UILabel(frame: CGRectMake(marginX + offsetX - 10, offsetY, width, height))
        minsLabel.text = "m:"
        self.addSubview(minsLabel)

        let secLabel = UILabel(frame: CGRectMake(marginX + 2 * offsetX - 10, offsetY, width, height))
        secLabel.text = "s:"
        self.addSubview(secLabel)
    }

    func getDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date = dateFormatter.date(from: String(format: "%02d", self.hour) + ":" + String(format: "%02d", self.minute) + ":" + String(format: "%02d", self.seconds))
        return date!
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            self.hour = row
        case 1:
            self.minute = row
        case 2:
            self.seconds = row
        default:
            print("No component with number \(component)")
        }
        
        output?.updateTime(hour: hour, minute: minute, seconds: seconds)
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 24
        }

        return 60
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if (view != nil) {
            (view as! UILabel).text = String(format:"%02lu", row)
            return view!
        }
        let columnView = UILabel(frame: CGRectMake(35, 0, self.frame.size.width/3 - 35, 30))
        columnView.text = String(format:"%02lu", row)
        columnView.textAlignment = NSTextAlignment.center

        return columnView
    }
}
