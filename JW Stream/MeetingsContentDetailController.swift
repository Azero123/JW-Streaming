//
//  MeetingsContentDetailController.swift
//  JW Broadcasting
//
//  Created by Austin Zelenka on 2/2/16.
//  Copyright © 2016 xquared. All rights reserved.
//

import UIKit

class MeetingsContentDetailController: UIViewController {
    //https://www.jw.org/apps/E_0010011965_FILEDOWNLOAD?txtFile=eventmedia_global%2Fmwb16.02_E_01.mp4&__gda__=8c8ffc898d657cd881ee56e860c35b27
    
    //https://www.jw.org/apps/E_0010011965_FILEDOWNLOAD?txtFile=eventmedia_global%2Fmwb16.02_E_02.mp4&__gda__=677b01c417f86c8e8c1649af57bc2245
    
    //https://www.jw.org/apps/E_0010011965_FILEDOWNLOAD?txtFile=eventmedia_global%2Fld_E_01.mp4&__gda__=affaffb4e04d83d392ed7c1214151f5c
    
    
    //https://download-a.akamaihd.net/files/media_video/c4/nwtsv_E_160_r720P.mp4
    
    var monthID=0
    let meta=unfold(NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("Monthly-Meetings-En", ofType: "json")!), instructions: []) as? [NSDictionary]
    
    
    @IBOutlet weak var backgroundImage: UIImageView!
    let player=SuperMediaPlayer()
    @IBOutlet weak var VideoHorizontalView: MeetingsCollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //100 × 1074
        //"Meeting-Workbook-2016-February.png"
        self.backgroundImage.image=imageUsingCache(unfold(meta, instructions:  [monthID, "images","tvtop","normal"]) as! String)
        //(self.VideoHorizontalView.collectionViewLayout as! CollectionViewHorizontalFlowLayout).spacingPercentile=1.5
        (self.VideoHorizontalView.collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing=100
        (self.VideoHorizontalView.collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing=100
        
        self.VideoHorizontalView.clipsToBounds=false
        
        if (monthID==0){
            self.view.backgroundColor=UIColor(colorLiteralRed: 42/255, green: 67/255, blue: 70/255, alpha: 1)
        }
        if (monthID==1){
            self.view.backgroundColor=UIColor(colorLiteralRed: 43/255, green: 23/255, blue: 56/255, alpha: 1)
        }
        if (monthID==2){
            self.view.backgroundColor=UIColor(colorLiteralRed: 25/255, green: 25/255, blue: 25/255, alpha: 1)
        }
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return unfold(meta, instructions:  [monthID,"videos", "count"]) as! Int
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        var header:UICollectionReusableView?=nil
        
        if (kind == UICollectionElementKindSectionHeader){
            header=collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "header", forIndexPath: indexPath)
        }
        if (kind == UICollectionElementKindSectionFooter) {
            header=collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: "footer", forIndexPath: indexPath)
            
        }
        
        return header!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("category", forIndexPath: indexPath)
        cell.alpha=1
        cell.tag=indexPath.row
        cell.clipsToBounds=false
        
        for subview in cell.contentView.subviews {
            if (subview.isKindOfClass(UIActivityIndicatorView.self)){
                subview.transform = CGAffineTransformMakeScale(2.0, 2.0)
                (subview as! UIActivityIndicatorView).startAnimating()
            }
            if (subview.isKindOfClass(UIImageView.self)){
                
                let imageView=subview as! UIImageView
                imageView.image=UIImage(named: unfold(meta, instructions:  [monthID,"videos", indexPath.row,"images","wss","lg"]) as! String)
                
                if (imageView.image == nil){
                    
                    imageView.image=imageUsingCache(unfold(meta, instructions:  [monthID,"videos", indexPath.row,"images","wss","lg"]) as! String)
                }
                
                imageView.userInteractionEnabled = true
                #if os(tvOS)
                    imageView.adjustsImageWhenAncestorFocused = true
                #endif
            }
            if (subview.isKindOfClass(UILabel.self)){
                (subview as! UILabel).text=unfold(meta, instructions:  [monthID,"videos", indexPath.row,"name"]) as? String
            }
        }
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        /*
        This handles the frame sizes of the previews without destroying ratios.
        */
        
        let multiplier:CGFloat=1.0
        let ratio:CGFloat=0.8
        let width:CGFloat=250
        return CGSize(width: width*multiplier, height: width*ratio*multiplier) //Currently set to 512,288
    }
    
    func collectionView(collectionView: UICollectionView, didUpdateFocusInContext context: UICollectionViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        /*
        
        This method handles when the user moves focus over a UICollectionViewCell and/or UICollectionView.
        
        UICollectionView that are SuperCollectionViews manage their own focus events so if UICollectionView is a SuperCollectionView let it handle itself.
        
        Lastly if he LatestVideos or SlideShow collection view are focused move everything up so you can see them.
        */
        
        if (context.nextFocusedView != nil && context.previouslyFocusedView?.superview!.isKindOfClass(SuperCollectionView.self) == true && context.previouslyFocusedIndexPath != nil){
            (context.previouslyFocusedView?.superview as! SuperCollectionView).cellShouldLoseFocus(context.previouslyFocusedView!, indexPath: context.previouslyFocusedIndexPath!)
            
        }
        if (context.nextFocusedView?.superview!.isKindOfClass(SuperCollectionView.self) == true && context.nextFocusedIndexPath != nil){
            
            (context.nextFocusedView?.superview as! SuperCollectionView).cellShouldFocus(context.nextFocusedView!, indexPath: context.nextFocusedIndexPath!)
            (context.nextFocusedView?.superview as! SuperCollectionView).cellShouldFocus(context.nextFocusedView!, indexPath: context.nextFocusedIndexPath!, previousIndexPath: context.previouslyFocusedIndexPath)
            
        }
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        /*
        Using our custom player we play the hls formatted file.
        HLS is nicer than a regular mp4 because it provides bit rate adjustments.
        Sadly at this time tv.jw.org does not use HLS.
        */
        
        player.updatePlayerUsingString(unfold(meta, instructions:  [monthID, "videos", indexPath.row,"url"]) as! String)
        player.playIn(self)
        return true
    }
}
