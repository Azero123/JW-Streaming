//
//  MeetingsCollectionView.swift
//  JW Broadcasting
//
//  Created by Austin Zelenka on 1/25/16.
//  Copyright © 2016 xquared. All rights reserved.
//

import UIKit

class MeetingsCollectionView: SuperCollectionView {

    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func cellShouldFocus(view: UIView, indexPath: NSIndexPath) {
        
        for subview in (view.subviews.first!.subviews) {
            if (subview.isKindOfClass(marqueeLabel.self)){
                (subview as! marqueeLabel).beginFocus()
            }
            if (subview.isKindOfClass(UILabel.self)){
                (subview as! UILabel).textColor=UIColor.whiteColor()
                subview.center=CGPoint(x: subview.center.x, y: subview.center.y+5)
            }
        }
    }
    
    override func cellShouldLoseFocus(view: UIView, indexPath: NSIndexPath) {
        for subview in (view.subviews.first!.subviews) {
            if (subview.isKindOfClass(UILabel.self)){
                (subview as! UILabel).textColor=UIColor.grayColor()
                subview.center=CGPoint(x: subview.center.x, y: subview.center.y-5)
            }
            if (subview.isKindOfClass(marqueeLabel.self)){
                (subview as! marqueeLabel).endFocus()
            }
            if (subview.isKindOfClass(StreamView.self)){
                (subview as! StreamView).unfocus()
            }
        }
    }



}
