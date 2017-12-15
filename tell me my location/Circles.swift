//
//  Circles.swift
//  tell me my location
//
//  Created by 조대희 on 2017. 12. 8..
//  Copyright © 2017년 AsiaQuest.inc. All rights reserved.
//

import UIKit

class Circles: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func draw(_ rect: CGRect) {
        let arc = UIBezierPath(arcCenter: CGPoint(x:x0, y:y0), radius:(CGFloat(distance * 20000/20000)) ,  startAngle: 0, endAngle: CGFloat(Double.pi)*2, clockwise: true)
    // 透明色設定
    let aColor = UIColor(red: 0.74, green: 1, blue: 0, alpha: 0.5)
        aColor.setStroke()
    arc.lineWidth = 1
    
    
    // 点線のパターンをセット
    
    arc.stroke()
}
}
