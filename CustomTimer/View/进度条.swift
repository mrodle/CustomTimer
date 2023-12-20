//
//  进度条.swift
//  CustomTimer
//
//  Created by Eldor Makkambayev on 16.12.2023.
//

import UIKit

class 进度条: UIView, CAAnimationDelegate {
    
    fileprivate var 动画片 = CABasicAnimation()
    fileprivate var 动画开始 = false
    fileprivate var 定时器持续时间 = 0
    
    lazy var fg进度层: CAShapeLayer = {
        let fg进度层 = CAShapeLayer()
        return fg进度层
    }()
    
    lazy var bg进度层: CAShapeLayer = {
        let bg进度层 = CAShapeLayer()
        return bg进度层
    }()
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        加载背景进度条()
        loadFg进度条()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        加载背景进度条()
        loadFg进度条()
    }
    
    fileprivate func loadFg进度条() {
        
        let 起始角度 = CGFloat(-Double.pi / 2)
        let 结束角 = CGFloat(3 * Double.pi / 2)
        let 中心点 = CGPoint(x: frame.width / 2 , y: frame.height / 2)
        let 渐变遮罩层 = 渐变遮罩()
        fg进度层.path = UIBezierPath(
            arcCenter: 中心点,
            radius: frame.width/2 - 30.0,
            startAngle: 起始角度,
            endAngle: 结束角,
            clockwise: true
        ).cgPath
        fg进度层.backgroundColor = 自定义颜色.清除.cgColor
        fg进度层.fillColor = nil
        fg进度层.strokeColor = 自定义颜色.黑色的.cgColor
        fg进度层.lineWidth = 4.0
        fg进度层.strokeStart = 0.0
        fg进度层.strokeEnd = 0.0
        
        渐变遮罩层.mask = fg进度层
        layer.addSublayer(渐变遮罩层)
    }
    
    fileprivate func 渐变遮罩() -> CAGradientLayer {
        let 渐变层 = CAGradientLayer()
        渐变层.frame = bounds
        渐变层.locations = [0.0, 1.0]
        let 彩色顶部: AnyObject = 自定义颜色.酸橙.cgColor
        let 颜色底部: AnyObject = 自定义颜色.夏日天空.cgColor
        let 颜色数组: [AnyObject] = [彩色顶部, 颜色底部]
        渐变层.colors = 颜色数组
        
        return 渐变层
    }
    
    fileprivate func 加载背景进度条() {
        
        let 起始角度 = CGFloat(-Double.pi / 2)
        let 结束角 = CGFloat(3 * Double.pi / 2)
        let 中心点 = CGPoint(x: frame.width/2 , y: frame.height/2)
        let 渐变遮罩层 = 渐变遮罩Bg()
        bg进度层.path = UIBezierPath(
            arcCenter: 中心点,
            radius: frame.width/2 - 30.0,
            startAngle: 起始角度,
            endAngle: 结束角,
            clockwise: true
        ).cgPath
        bg进度层.backgroundColor = 自定义颜色.清除.cgColor
        bg进度层.fillColor = nil
        bg进度层.strokeColor = 自定义颜色.黑色的.cgColor
        bg进度层.lineWidth = 4.0
        bg进度层.strokeStart = 0.0
        bg进度层.strokeEnd = 1.0
        
        渐变遮罩层.mask = bg进度层
        layer.addSublayer(渐变遮罩层)
    }
    
    fileprivate func 渐变遮罩Bg() -> CAGradientLayer {
        let 渐变层 = CAGradientLayer()
        渐变层.frame = bounds
        渐变层.locations = [0.0, 1.0]
        let 彩色顶部: AnyObject = 自定义颜色.反面.cgColor
        let 颜色底部: AnyObject = 自定义颜色.反面.cgColor
        let 颜色数组: [AnyObject] = [彩色顶部, 颜色底部]
        渐变层.colors = 颜色数组
        
        return 渐变层
    }
    
    public func 设置进度条(小时: Int, 分钟: Int, 秒: Int) {
        let 小时到秒 = 小时 * 3600
        let 分钟转秒 = 分钟 * 60
        let 总秒数 = 秒 + 分钟转秒 + 小时到秒
        定时器持续时间 = 总秒数
    }
    
    public func 开始() {
        if !动画开始 {
            开始动画()
        }else{
            恢复动画()
        }
    }
    
    public func 暂停() {
        暂停动画()
    }
    
    public func 停止() {
        停止动画()
    }
    
    fileprivate func 开始动画() {
        
        重置动画()
        
        fg进度层.strokeEnd = 0.0
        动画片.keyPath = "strokeEnd"
        动画片.fromValue = CGFloat(0.0)
        动画片.toValue = CGFloat(1.0)
        动画片.duration = CFTimeInterval(定时器持续时间)
        动画片.delegate = self
        动画片.isRemovedOnCompletion = false
        动画片.isAdditive = true
        动画片.fillMode = CAMediaTimingFillMode.forwards
        fg进度层.add(动画片, forKey: "strokeEnd")
        动画开始 = true
        
    }
    
    fileprivate func 重置动画() {
        fg进度层.speed = 1.0
        fg进度层.timeOffset = 0.0
        fg进度层.beginTime = 0.0
        fg进度层.strokeEnd = 0.0
        动画开始 = false
    }
    
    fileprivate func 停止动画() {
        fg进度层.speed = 1.0
        fg进度层.timeOffset = 0.0
        fg进度层.beginTime = 0.0
        fg进度层.strokeEnd = 0.0
        fg进度层.removeAllAnimations()
        动画开始 = false
    }
    
    fileprivate func 暂停动画(){
        let 暂停时间 = fg进度层.convertTime(CACurrentMediaTime(), from: nil)
        fg进度层.speed = 0.0
        fg进度层.timeOffset = 暂停时间
        
    }
    
    fileprivate func 恢复动画(){
        let 暂停时间 = fg进度层.timeOffset
        fg进度层.speed = 1.0
        fg进度层.timeOffset = 0.0
        fg进度层.beginTime = 0.0
        let 自暂停以来的时间 = fg进度层.convertTime(CACurrentMediaTime(), from: nil) - 暂停时间
        fg进度层.beginTime = 自暂停以来的时间
    }
    
    internal func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        停止动画()
    }
}
