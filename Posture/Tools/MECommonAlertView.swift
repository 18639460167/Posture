//
//  MECommonAlertView.swift
//  MandarinExam
//
//  Created by pisces_seven on 2021/5/29.
//  Copyright © 2021 LOL. All rights reserved.
//

import UIKit

class MECommonAlertView: UIView {

    static let shareAlert: MECommonAlertView = MECommonAlertView.init(frame: UIScreen.main.bounds)
    
    var btnHandle:((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.init(hexString: "#292F4A").withAlphaComponent(0.5)
        self.contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(313*ScreenScale)
        }
        self.cancelBtn.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.height.equalTo(52*ScreenScale)
            make.width.equalTo(self.contentView.snp_width).multipliedBy(0.5)
        }
        self.confirmBtn.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.height.equalTo(52*ScreenScale)
            make.left.equalTo(self.cancelBtn.snp_right)
        }
        
        self.contentView.addSubview(centerLineView)
        centerLineView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.cancelBtn.snp_centerY)
            make.size.equalTo(CGSize.init(width: 1, height: 21*ScreenScale))
        }
        self.botLineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.cancelBtn.snp_top)
            make.height.equalTo(1.0)
        }
        self.failAlertView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.botLineView.snp_top).offset(-25*ScreenScale)
            make.centerX.equalToSuperview()
            make.height.equalTo(25*ScreenScale)
        }
        self.descriptionLbl.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(25*ScreenScale)
            make.bottom.equalTo(self.failAlertView.snp_top).offset(-10*ScreenScale)
        }
        self.titleLbl.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(25*ScreenScale)
            make.top.equalToSuperview().offset(25*ScreenScale)
            make.bottom.equalTo(self.descriptionLbl.snp_top).offset(-8*ScreenScale)
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    lazy var contentView: UIView = {
        let view = UIView.init(frame: .zero)
        view.layer.cornerRadius = 8*ScreenScale
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        self.addSubview(view)
        return view
    }()
    lazy var titleLbl: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 23*ScreenScale, weight: .medium)
        label.textColor = UIColor.init(hexString: "#373C45")
        label.numberOfLines = 0
        self.contentView.addSubview(label)
        return label
    }()
    lazy var descriptionLbl: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17*ScreenScale, weight: .regular)
        label.textColor = UIColor.init(hexString: "#566173")
        label.numberOfLines = 0
        self.contentView.addSubview(label)
        return label
    }()
    lazy var botLineView: UIView = {
        let view = UIView.init(frame: .zero)
        view.backgroundColor = UIColor.init(hexString: "#D5DCE6")
        self.contentView.addSubview(view)
        return view
    }()
    lazy var cancelBtn: UIButton = {
        let btn = UIButton.init(frame: .zero)
        btn.setTitleColor(UIColor.init(hexString: "#7C8CA6"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17*ScreenScale, weight: .regular)
        btn.tag = 1
        btn.addTarget(self, action: #selector(btnAction(sender:)), for: .touchUpInside)
        btn.setTitle("推出测试", for: .normal)
        self.contentView.addSubview(btn)
        return btn
    }()
    lazy var confirmBtn: UIButton = {
        let btn = UIButton.init(frame: .zero)
        btn.setTitleColor(UIColor.init(hexString: "#5B77F2"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17*ScreenScale, weight: .medium)
        btn.tag = 2
        btn.addTarget(self, action: #selector(btnAction(sender:)), for: .touchUpInside)
        btn.setTitle("推出测试", for: .normal)
        self.contentView.addSubview(btn)
        return btn
    }()
    
    lazy var centerLineView: UIView = {
        let lineView = UIView.init(frame: .zero)
        lineView.backgroundColor = UIColor.init(hexString: "#D5DCE6")
        lineView.layer.cornerRadius = 0.5
        lineView.layer.masksToBounds = true
        return lineView
    }()
    
    lazy var failAlertView: UIView = {
        let view = UIView.init(frame: .zero)
        view.isHidden = true
        view.layer.cornerRadius = 12.5*ScreenScale
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.init(hexString: "#5B77F2").withAlphaComponent(0.2)
        let imgView = UIImageView.init(frame: .zero)
        imgView.image = UIImage.init(named: "examtips_modal_tips")
        view.addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(7*ScreenScale)
            make.width.equalTo(14*ScreenScale)
        }
        let label = UILabel.init(frame: .zero)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13*ScreenScale, weight: .regular)
        label.textColor = UIColor.init(hexString: "#5B77F2")
        label.text = "我没有以上错误，求提示！"
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-7*ScreenScale)
            make.left.equalTo(imgView.snp_right).offset(4*ScreenScale)
        }
        let btn = UIButton.init(frame: .zero)
        btn.tag = 4
        btn.addTarget(self, action: #selector(btnAction(sender:)), for: .touchUpInside)
        view.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.contentView.addSubview(view)
        return view
    }()
    
    @objc func btnAction(sender: UIButton) {
        if sender.tag == 4 {
            self.contentView.isHidden = true
            self.tipContentView.isHidden = false
            self.tipContentView.snp_remakeConstraints { (make) in
                make.center.equalToSuperview()
                make.width.equalTo(313*ScreenScale)
            }
        } else {
            self.btnHandle?(sender.tag)
            self.removeFromSuperview()
        }
    }
    
    /// 显示弹窗
    /// btnHandle： 1取消 2确定
    class func showAlertView(title: String?,
                             destriciton: String? = nil,
                             cancel: String? = nil,
                             confirm: String? = nil,
                             cancelColor: String = "#7C8CA6",
                             confirmColor: String = "#5B77F2",
                             fatherView: UIView? = nil,
                             showFailTip: Bool = false,
                             btnHandle: ((Int) -> Void)?) {
        MECommonAlertView.hideAlert()
        let view = MECommonAlertView.shareAlert
        view.tipContentView.isHidden = true
        view.contentView.isHidden = false
        view.btnHandle = btnHandle
        if let faView = fatherView {
            faView.addSubview(view)
        } else {
            UIApplication.shared.keyWindow?.addSubview(view)
        }
        view.failAlertView.isHidden = !showFailTip
        view.descriptionLbl.isHidden = (destriciton == nil)
        view.descriptionLbl.snp_remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(25*ScreenScale)
            if showFailTip {
                make.bottom.equalTo(view.failAlertView.snp_top).offset(-8*ScreenScale)
            } else {
                make.bottom.equalTo(view.botLineView.snp_top).offset(-25*ScreenScale)
            }
        }
        view.titleLbl.snp_remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(25*ScreenScale)
            make.top.equalToSuperview().offset(25*ScreenScale)
            if destriciton == nil {
                make.bottom.equalTo(view.botLineView.snp_top).offset(-25*ScreenScale)
            } else {
                make.bottom.equalTo(view.descriptionLbl.snp_top).offset(-8*ScreenScale)
            }
        }
        if confirm == nil || cancel == nil {
            view.centerLineView.isHidden = true
        } else {
            view.centerLineView.isHidden = false
        }
        view.cancelBtn.snp_remakeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.height.equalTo(53*ScreenScale)
            if confirm == nil {
                make.width.equalTo(view.contentView.snp_width).multipliedBy(1.0)
            } else {
                make.width.equalTo(view.contentView.snp_width).multipliedBy(cancel == nil ? 0 : 0.5)
            }
        }
        view.titleLbl.text = title
        view.descriptionLbl.text = destriciton
        view.cancelBtn.setTitle(cancel, for: .normal)
        view.confirmBtn.setTitle(confirm, for: .normal)
        view.cancelBtn.setTitleColor(UIColor.init(hexString: cancelColor), for: .normal)
        view.confirmBtn.setTitleColor(UIColor.init(hexString: confirmColor), for: .normal)
    }
    
    lazy var tipContentView: UIView = {
        let view = UIView.init(frame: .zero)
        view.isHidden = true
        view.layer.cornerRadius = 8*ScreenScale
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        self.addSubview(view)
        let knowBtn = UIButton.init(frame: .zero)
        knowBtn.setTitle("知道了", for: .normal)
        knowBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17*ScreenScale, weight: .medium)
        knowBtn.setTitleColor(UIColor.init(hexString: "#5B77F2"), for: .normal)
        knowBtn.tag = 3
        knowBtn.addTarget(self, action: #selector(btnAction(sender:)), for: .touchUpInside)
        view.addSubview(knowBtn)
        knowBtn.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(52*ScreenScale)
        }
        let lineView = UIView.init(frame: .zero)
        lineView.backgroundColor = UIColor.init(hexString: "#D5DCE6")
        view.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(knowBtn.snp_top)
            make.height.equalTo(1.0)
        }
        let label = UILabel.init(frame: .zero)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 23*ScreenScale, weight: .medium)
        label.textColor = UIColor.init(hexString: "#373C45")
        label.numberOfLines = 0
        label.text = "考试提示"
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(73*ScreenScale)
            make.left.right.equalToSuperview()
        }
        let tipView1 = METipAlertView.init(frame: .zero)
        view.addSubview(tipView1)
        tipView1.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(323*ScreenScale)
            make.top.equalTo(label.snp_bottom).offset(28*ScreenScale)
        }
        tipView1.titleLbl.text = "在听到“嘟”的一声后，开始录音。"
        let tipView2 = METipAlertView.init(frame: .zero)
        view.addSubview(tipView2)
        tipView2.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(323*ScreenScale)
            make.top.equalTo(tipView1.snp_bottom).offset(10*ScreenScale)
        }
        tipView2.titleLbl.text = "建议您在测评时选择安静的环境，保持适中的语速大声朗读。"
        let tipView3 = METipAlertView.init(frame: .zero)
        view.addSubview(tipView3)
        tipView3.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(323*ScreenScale)
            make.top.equalTo(tipView2.snp_bottom).offset(10*ScreenScale)
            make.bottom.equalTo(lineView.snp_top).offset(-25*ScreenScale)
        }
        tipView3.titleLbl.text = "建议与话筒保持适当的距离，过近时可能录入呼吸声，导致评测异常。"
        
        let imgView = UIImageView.init(frame: .zero)
        imgView.image = UIImage.init(named: "examtips_modal_bg")
        view.addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.right.top.equalToSuperview()
            make.height.equalTo(77*ScreenScale)
        }
        return view
    }()
    
    class func hideAlert() {
        MECommonAlertView.shareAlert.removeFromSuperview()
    }

}

class METipAlertView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUpUI() {
        colorView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 8*ScreenScale, height: 8*ScreenScale))
            make.left.equalToSuperview().offset(21*ScreenScale)
            make.top.equalToSuperview().offset(7*ScreenScale)
        }
        titleLbl.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-21*ScreenScale)
            make.left.equalTo(colorView.snp_right).offset(6*ScreenScale)
        }
    }
    lazy var colorView: UIView = {
        let view = UIView.init(frame: .zero)
        view.backgroundColor = UIColor.init(hexString: "#5B77F2")
        view.layer.cornerRadius = 4*ScreenScale
        view.layer.masksToBounds = true
        self.addSubview(view)
        return view
    }()
    lazy var titleLbl: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17*ScreenScale, weight: .regular)
        label.textColor = UIColor.init(hexString: "#566173")
        self.addSubview(label)
        return label
    }()
}
