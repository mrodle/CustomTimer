//
//  时间选择器视图.swift
//  CustomTimer
//
//  Created by Eldor Makkambayev on 19.12.2023.
//

import UIKit

protocol 时间选择器视图输出: AnyObject {
    func 更新时间(小时: Int, 分钟: Int, 秒: Int)
}

class 时间选择器视图: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {

    var 小时: Int = 0
    var 分钟: Int = 0
    var 秒: Int = 0
    
    weak var 输出: 时间选择器视图输出?

    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.设置()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.设置()
    }

    func 设置(){
        self.delegate = self
        self.dataSource = self

        let 高度 = CGFloat(20)
        let 偏移X = self.frame.size.width / 3
        let 偏移Y = self.frame.size.height/2 - 高度/2
        let 边距X = CGFloat(35)
        let 宽度 = 偏移X - 边距X

        let 小时标签 = UILabel(frame: CGRectMake(边距X, 偏移Y, 宽度, 高度))
        小时标签.text = "h:"
        self.addSubview(小时标签)

        let 分钟标签 = UILabel(frame: CGRectMake(边距X + 偏移X - 10, 偏移Y, 宽度, 高度))
        分钟标签.text = "m:"
        self.addSubview(分钟标签)

        let 安全标签 = UILabel(frame: CGRectMake(边距X + 2 * 偏移X - 10, 偏移Y, 宽度, 高度))
        安全标签.text = "s:"
        self.addSubview(安全标签)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            self.小时 = row
        case 1:
            self.分钟 = row
        case 2:
            self.秒 = row
        default:
            print("No component with number \(component)")
        }
        
        输出?.更新时间(小时: 小时, 分钟: 分钟, 秒: 秒)
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
        let 列视图 = UILabel(frame: CGRectMake(35, 0, self.frame.size.width/3 - 35, 30))
        列视图.text = String(format:"%02lu", row)
        列视图.textAlignment = NSTextAlignment.center

        return 列视图
    }
}
