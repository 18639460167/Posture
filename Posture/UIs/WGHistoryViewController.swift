//
//  WGHistoryViewController.swift
//  Posture
//
//  Created by 窝瓜 on 2021/6/24.
//  Copyright © 2021 LOL. All rights reserved.
//

import UIKit

class WGHistoryViewController: WGBaseViewController {

    var cacheModels: [WGCacheModel] = []
    var firstCacheModel: WGCacheModel = WGCacheModel.init()
    var isResult: Bool = true   // 是否是结果详情(true是，false是对比选择)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: SaveSuccessNotifiName, object: nil)
        self.setUpUI()
        self.loadData()
    }
    
    private func setUpUI() {
        self.closeBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(21*ScreenScale)
            make.top.equalToSuperview().offset(12*ScreenScale+SafeTopHeight)
            make.width.height.equalTo(35*ScreenScale)
        }
        self.historyList.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.closeBtn.snp_bottom).offset(10*ScreenScale)
        }
    }
    
    @objc func loadData() {
        self.cacheModels = WGResourceCacheTool.sharedInstance.cacheResourceList()
        self.historyList.reloadData()
    }
    @objc func closeAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    lazy var closeBtn: UIButton = {
        let btn = UIButton.init(frame: .zero)
        btn.setImage(UIImage.init(named: "nav_back"), for: .normal)
        btn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        self.view.addSubview(btn)
        return btn
    }()
    
    lazy var historyList: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 15*ScreenScale
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets.init(top: 15*ScreenScale, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize.init(width: ScreenWidth, height: 72*ScreenScale)
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets.init(top: 10*ScreenScale, left: 0, bottom: 0, right: 0)
        self.view.addSubview(collectionView)
        collectionView.register(WGHistoryCollectionViewCell.self, forCellWithReuseIdentifier: "WGHistoryCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WGHistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cacheModels.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WGHistoryCollectionViewCell", for: indexPath) as! WGHistoryCollectionViewCell
        // configTime
        cell.configData(model: cacheModels[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.isResult {
            let item = cacheModels[indexPath.row]
            let resultVC = WGResultDetailVC.init()
            resultVC.cacheModel = item
            self.navigationController?.pushViewController(resultVC, animated: true)
        } else {
            let item = cacheModels[indexPath.row]
            let resultVC = WGCompareResultVC.init()
            resultVC.firstCacheModel = self.firstCacheModel
            resultVC.lastCacheModel = item
            self.navigationController?.pushViewController(resultVC, animated: true)
        }
        
    }
}
