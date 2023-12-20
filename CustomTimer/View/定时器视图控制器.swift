//
//  定时器视图控制器.swift
//  CustomTimer
//
//  Created by Eldor Makkambayev on 16.12.2023.
//

import UIKit
import AudioToolbox

class 定时器视图控制器: UIViewController {
    
    var 选定的秒: Int = 0
    var 倒计时计时器已开始 = false
    
    lazy var 倒计时器: 倒数定时器类 = {
        let 看法 = 倒数定时器类()
        return 看法
    }()
    
    @IBOutlet weak var 进度条: 进度条!
    private var 时间标签: UILabel = {
        var 标签 = UILabel()
        标签.font = UIFont.systemFont(ofSize: 32, weight: .light)
        标签.textAlignment = .center
        标签.textColor = 自定义颜色.白色的
        return 标签
    }()
    private var 停止按钮: UIButton = {
        var 按钮 = UIButton()
        按钮.contentHorizontalAlignment = .center
        按钮.contentVerticalAlignment = .center
        按钮.contentMode = .scaleToFill
        按钮.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
        按钮.setTitle("STOP", for: .normal)
        return 按钮
    }()
    private var 开始按钮: UIButton = {
        var 按钮 = UIButton()
        按钮.contentHorizontalAlignment = .center
        按钮.contentVerticalAlignment = .center
        按钮.contentMode = .scaleToFill
        按钮.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
        按钮.setTitle("SET", for: .normal)
        return 按钮
    }()
    private var 时间选择器: 时间选择器视图 = {
        var 拾取器 = 时间选择器视图()
        拾取器.isHidden = true
        拾取器.backgroundColor = 自定义颜色.白色的
        拾取器.layer.cornerRadius = 30
        拾取器.layer.masksToBounds = true
        return 拾取器
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        设置界面()
        配置按钮()
        倒计时器.代表 = self
        时间选择器.输出 = self
        倒计时器.停止定时器()
    }
    
    private func 设置界面() {
        view.backgroundColor = 自定义颜色.黑色的
        [
            时间标签,
            停止按钮,
            开始按钮,
            时间选择器
        ].forEach { 子视图 in
            view.addSubview(子视图)
            子视图.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            
            时间标签.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            时间标签.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            时间标签.widthAnchor.constraint(equalToConstant: 300),
            时间标签.heightAnchor.constraint(equalToConstant: 40),
            
            停止按钮.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -20),
            停止按钮.widthAnchor.constraint(equalToConstant: 170),
            停止按钮.heightAnchor.constraint(equalToConstant: 50),
            停止按钮.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            
            开始按钮.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 20),
            开始按钮.widthAnchor.constraint(equalToConstant: 170),
            开始按钮.heightAnchor.constraint(equalToConstant: 50),
            开始按钮.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            
            时间选择器.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            时间选择器.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func 配置按钮() {
        停止按钮.isEnabled = false
        停止按钮.alpha = 0.5
        停止按钮.addTarget(self, action: #selector(停止动作), for: .touchUpInside)
        开始按钮.addTarget(self, action: #selector(开始动作), for: .touchUpInside)
    }
        
    @objc func 开始动作() {
        if 选定的秒 == 0 {
            时间选择器.isHidden = false
            开始按钮.setTitle("START",for: .normal)
            return
        }

        停止按钮.isEnabled = true
        停止按钮.alpha = 1.0
        时间选择器.isHidden = true
        
        if !倒计时计时器已开始 {
            倒计时器.启动定时器()
            进度条.开始()
            倒计时计时器已开始 = true
            开始按钮.setTitle("PAUSE",for: .normal)
        } else {
            倒计时器.暂停定时器()
            进度条.暂停()
            倒计时计时器已开始 = false
            开始按钮.setTitle("RESUME",for: .normal)
        }
    }
    
    @objc func 停止动作() {
        选定的秒 = 0
        倒计时器.停止定时器()
        进度条.停止()
        倒计时计时器已开始 = false
        停止按钮.isEnabled = false
        停止按钮.alpha = 0.5
        开始按钮.setTitle("SET",for: .normal)
    }
}

extension 定时器视图控制器: 倒数计时器代理 {
    func 倒计时完成() {
        选定的秒 = 0
        倒计时计时器已开始 = false

        停止按钮.isEnabled = false
        停止按钮.alpha = 0.5
        开始按钮.setTitle("SET",for: .normal)
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    func 倒计时时间(时间: String) {
        时间标签.text = 时间
    }
}

extension 定时器视图控制器: 时间选择器视图输出 {
    func 更新时间(小时: Int, 分钟: Int, 秒: Int) {
        let 小时到秒 = 小时 * 3600
        let 分钟转秒 = 分钟 * 60
        let 秒到秒 = 秒
        选定的秒 = 小时到秒+分钟转秒+秒到秒
        倒计时器.设置定时器(小时: 小时, 分钟: 分钟, 秒: 秒)
        进度条.设置进度条(小时: 小时, 分钟: 分钟, 秒: 秒)
    }
}
