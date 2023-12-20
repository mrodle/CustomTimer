//
//  倒数定时器类.swift
//  CustomTimer
//
//  Created by Eldor Makkambayev on 16.12.2023.
//

import UIKit

protocol 倒数计时器代理: AnyObject {
    func 倒计时完成()
    func 倒计时时间(时间: String)
}

class 倒数定时器类 {
    
    weak var 代表: 倒数计时器代理?
    
    private var 主队列 = DispatchQueue.main
    private var 队列: DispatchQueue?
    private var 期间 = 0
    
    public func 设置定时器(小时: Int, 分钟: Int, 秒: Int) {
        let 所有秒数 = 时间到秒(小时: 小时, 分钟: 分钟, 秒: 秒)
        self.期间 = 所有秒数
        代表?.倒计时时间(时间: 格式时间(秒: 所有秒数))
    }
    
    public func 启动定时器() {
        队列 = 主队列
        更新定时器()
    }
    
    public func 停止定时器() {
        队列 = nil
        代表?.倒计时时间(时间: 格式时间(秒: 0))
    }
    
    public func 暂停定时器() {
        队列 = nil
    }
    
    private func 计时器滴答声() {
        期间 -= 1
        if 期间 <= 0 {
            定时器完成()
        }
    }
    
    private func 定时器完成() {
        停止定时器()
        代表?.倒计时完成()
    }
    
    private func 更新定时器() {
        队列?.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self, self.队列 != nil else { return }
            self.计时器滴答声()
            self.代表?.倒计时时间(时间: self.格式时间(秒: self.期间))
            self.更新定时器()
        }
    }
    
    private func 格式时间(秒: Int) -> String {
        let 小时 = 秒 / 3600
        let 分钟 = (秒 % 3600) / 60
        let 秒 = 秒 % 60
        
        let 格式化时间 = String(format: "%02d:%02d:%02d", 小时, 分钟, 秒)
        return 格式化时间
    }
    
    private func 时间到秒(小时: Int, 分钟: Int, 秒: Int) -> Int {
        return 小时 * 3600 + 分钟 * 60 + 秒
    }
}
