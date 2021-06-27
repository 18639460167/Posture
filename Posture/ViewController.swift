//
//  ViewController.swift
//  Posture
//
//  Created by 窝瓜 on 2021/6/18.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.testAddLayer()
    }
    
    lazy var shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2.0
        shapeLayer.strokeColor = UIColor(hexString: "#555555").cgColor
        self.testView1.layer.addSublayer(shapeLayer)
        return shapeLayer
    }()
    
    lazy var path: UIBezierPath = {
        let path = UIBezierPath.init()
        return path
    }()
    
    lazy var shapeLayer2: CAShapeLayer = {
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2.0
        shapeLayer.strokeColor = UIColor.red.cgColor
        self.testView2.layer.addSublayer(shapeLayer)
        return shapeLayer
    }()
    
    lazy var path2: UIBezierPath = {
        let path = UIBezierPath.init()
        return path
    }()
    
    lazy var testView1: UIView = {
        let view = UIView.init(frame: CGRect(x: 50, y: 400, width: 200, height: 100))
        view.backgroundColor = .blue
        self.view.addSubview(view)
        return view
    }()
    
    lazy var testView2: UIView = {
        let view = UIView.init(frame: CGRect(x: 50, y: 400, width: 200, height: 100))
        view.backgroundColor = .green
        self.view.addSubview(view)
        return view
    }()
    
    func testAddLayer() {
        let point1 = CGPoint(x: 0, y: 100)
        let point2 = CGPoint(x: 200, y: 0)
        
        self.path.move(to: point1)
        self.path.addLine(to: point2)
        self.shapeLayer.path = self.path.cgPath
        
        self.path2.move(to: point1)
        self.path2.addLine(to: point2)
        self.shapeLayer2.path = self.path2.cgPath
        
        self.testView2.layer.transform = CATransform3DMakeRotation(CGFloat(90 * Double.pi/180), 0.0, 0.0, 1.0)
    }
    
    
}

