//
//  WGHistoryCollectionViewCell.swift
//  Posture
//
//  Created by 窝瓜 on 2021/6/24.
//  Copyright © 2021 LOL. All rights reserved.
//

import UIKit

class WGHistoryCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.centerView.snp.makeConstraints { (make) in
            make.centerX.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(27*ScreenScale)
        }
        self.timeView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(23*ScreenScale)
        }
        self.monthLbl.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
        }
        self.dayLbl.snp.makeConstraints { (make) in
            make.left.equalTo(self.monthLbl.snp_right).offset(5*ScreenScale)
            make.top.bottom.equalToSuperview()
        }
        self.tagLbl.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(self.dayLbl.snp_right)
        }
        self.yearLbl.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.left.equalTo(self.tagLbl.snp_right).offset(5*ScreenScale)
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    lazy var centerView: UIView = {
        let view = UIView.init(frame: .zero)
        view.layer.borderWidth = 4
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = 10*ScreenScale
        view.layer.masksToBounds = true
        self.addSubview(view)
        return view
    }()
    
    lazy var timeView: UIView = {
        let view = UIView.init(frame: .zero)
        self.centerView.addSubview(view)
        return view
    }()
    lazy var yearLbl: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.textColor = .white
        label.text = "2020"
        label.font = UIFont.systemFont(ofSize: 22*ScreenScale, weight: .regular)
        self.timeView.addSubview(label)
        return label
    }()
    
    lazy var dayLbl: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.textColor = .white
        label.text = "13"
        label.font = UIFont.systemFont(ofSize: 22*ScreenScale, weight: .regular)
        self.timeView.addSubview(label)
        return label
    }()
    
    lazy var tagLbl: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.textColor = .white
        label.text = "th"
        label.font = UIFont.systemFont(ofSize: 9*ScreenScale, weight: .regular)
        self.timeView.addSubview(label)
        return label
    }()
    
    lazy var monthLbl: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.textColor = .white
        label.text = "March"
        label.font = UIFont.systemFont(ofSize: 22*ScreenScale, weight: .regular)
        self.timeView.addSubview(label)
        return label
    }()
    
    func configData(model: WGCacheModel) {
        let timeInfos =  model.timeInfo //wg_getCurrentTime().1
        if timeInfos.count > 0 {
            self.monthLbl.text = timeInfos[0]
            self.dayLbl.text = timeInfos[1]
            self.tagLbl.text = timeInfos[2]
            self.yearLbl.text = timeInfos[3]
        }
    }
    
    func configTime() {
        let timeInfos = wg_getCurrentTime().1
        self.monthLbl.text = timeInfos[0]
        self.dayLbl.text = timeInfos[1]
        self.tagLbl.text = timeInfos[2]
        self.yearLbl.text = timeInfos[3]
    }
}
