//
//  MeetingsControllerViewController.swift
//  JW Broadcasting
//
//  Created by Austin Zelenka on 1/18/16.
//  Copyright © 2016 xquared. All rights reserved.
//

import UIKit

var MeetingContentSections=true

class MeetingsController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var VideoCollectionView: UICollectionView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var BackgroundEffectView: UIVisualEffectView!
    
    
    let MonthlyContentMeta=unfold(NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("Monthly-Meetings-En", ofType: "json")!), instructions: []) as? [NSDictionary]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        /*
        The gradual contextual background effect is not blurred exactly to apples default we change the color a bit to be more apparent and noticable.
        */
        
        backgroundImageView.alpha=0.75
        BackgroundEffectView.alpha=0.99
        
        /*
        Prepareing the collection view by registering some of its generation abilities and setting the space between the cells customly.
        */
        
        self.VideoCollectionView.clipsToBounds=false
        self.VideoCollectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")
        //(self.VideoCollectionView.collectionViewLayout as! CollectionViewAlignmentFlowLayout).spacingPercentile=1.275
        
        /*
        
        Generate content for language.
        
        */
        let menuPressRecognizer = UITapGestureRecognizer()
        menuPressRecognizer.addTarget(self, action: "menuButtonAction:")
        menuPressRecognizer.allowedPressTypes = [NSNumber(integer: UIPressType.Menu.rawValue)]
        self.view.addGestureRecognizer(menuPressRecognizer)
        
        renewContent()
    }
    
    var previousLanguageCode=languageCode
    
    override func viewWillAppear(animated: Bool) {
        
        /*
        The detail view controller of this view uses the semantic ForceRightToLeft. Incase the view was in RTL when it left we need to turn that off because this view manages all it's own RTL layouts.
        */
        
        UIView.appearance().semanticContentAttribute=UISemanticContentAttribute.ForceLeftToRight
        /*
        The view may be reappearing so if the language has been changed since the view last was ran that we need to update the content to the new language.
        */
        if (previousLanguageCode != languageCode){
            renewContent()
        }
        previousLanguageCode=languageCode
        
        /*
        Old code for when TVOS 9.0 couldn't even handle change in view controllers properly if they were running methods in background.
        (Leave this incase we want to update the app to work in 9.0)
        */
        
        self.view.hidden=false
    }
    
    override func viewDidDisappear(animated: Bool) {
        /*
        Old code for when TVOS 9.0 couldn't even handle change in view controllers properly if they were running methods in background.
        (Leave this incase we want to update the app to work in 9.0)
        */
        self.view.hidden=true
    }
    
    func renewContent(){
        
        self.VideoCollectionView.reloadData()
    }
    
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        var sectionCount=1
        
        if (MeetingContentSections == true){
            sectionCount=sectionCount+1
        }
        return sectionCount
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (section == 0){
            return 3
        }
        else {
            if (MonthlyContentMeta == nil){
                return 0
            }
            return (MonthlyContentMeta?.count)!
        }
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        var header:UICollectionReusableView?=nil
        
        if (kind == UICollectionElementKindSectionHeader){
            header=collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "header", forIndexPath: indexPath)
            var needsLabel=true
            for subview in (header?.subviews)! {
                if (subview.isKindOfClass(UILabel.self)){
                    (subview as! UILabel).text=["JW Streaming","Our Christian Life and Ministry"][indexPath.section]
                    needsLabel=false
                }
            }
            if (needsLabel){
                //header!.frame=CGRect(x: header!.frame.origin.x, y: header!.frame.origin.y, width: 300, height: 50)
                let label=UILabel(frame: CGRect(x: 0, y: 0, width: header!.frame.size.width, height: 50))
                label.font=UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
                label.text=["JW Streaming","Our Christian Life and Ministry"][indexPath.section]
                header?.addSubview(label)
            }
        }
        if (kind == UICollectionElementKindSectionFooter) {
            header=collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: "footer", forIndexPath: indexPath)
            
        }
        
        return header!
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 70)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("category", forIndexPath: indexPath)
        cell.alpha=1
        cell.tag=indexPath.row
        
        for subview in cell.contentView.subviews {
            if (indexPath.section == 0){
                if (subview.isKindOfClass(UIActivityIndicatorView.self)){
                    subview.transform = CGAffineTransformMakeScale(2.0, 2.0)
                    (subview as! UIActivityIndicatorView).startAnimating()
                }
                if (subview.isKindOfClass(UIImageView.self)){
                    
                    let imageView=subview as! UIImageView
                    imageView.image=UIImage(named: ["Regional-Conventions-real-1.png","Assembly.png","weekly-meetings-real-2.png"][indexPath.row])
                    imageView.userInteractionEnabled = true
                    #if os(tvOS)
                        imageView.adjustsImageWhenAncestorFocused = true
                    #endif
                }
                if (subview.isKindOfClass(UILabel.self)){
                    (subview as! UILabel).text=["Conventions","Assemblies","Meetings"][indexPath.row]
                }
            }
            else if (indexPath.section == 1){
                
                if (subview.isKindOfClass(UIActivityIndicatorView.self)){
                    subview.transform = CGAffineTransformMakeScale(2.0, 2.0)
                    (subview as! UIActivityIndicatorView).startAnimating()
                }
                if (subview.isKindOfClass(UIImageView.self)){
                    
                    let imageView=subview as! UIImageView
                    
                    //print(MonthlyContentMeta)
                    
                    
                    let url=NSURL(string: unfold(MonthlyContentMeta, instructions: [indexPath.row,"images","wss","lg"]) as! String)!
                    let data=NSData(contentsOfURL: url)
                    if (data != nil){
                        imageView.image=UIImage(data: data!)
                    }
                    
                    fetchDataUsingCache(unfold(MonthlyContentMeta, instructions:  [indexPath.row,"images","tvtop","normal"]) as! String, downloaded: {
                        for var i=0; i<unfold(self.MonthlyContentMeta, instructions:  [indexPath.row,"videos","count"]) as! Int; i++ {
                            
                            fetchDataUsingCache(unfold(self.MonthlyContentMeta, instructions:  [indexPath.row,"videos",i,"images","wss","lg"]) as! String, downloaded: nil)
                        }
                        
                    })
                    
                    
                    imageView.userInteractionEnabled = true
                    #if os(tvOS)
                        imageView.adjustsImageWhenAncestorFocused = true
                    #endif
                }
                if (subview.isKindOfClass(UILabel.self)){
                    (subview as! UILabel).text=unfold(MonthlyContentMeta, instructions: [indexPath.row, "month-name"]) as? String
                }
            }
        }
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        if (indexPath.section == 0){
            
            categoryIndexToGoTo=[3,2,1][indexPath.row]
        self.performSegueWithIdentifier("presentMeetingsDetail", sender: self)
        }
        else if (indexPath.section == 1){
            categoryIndexToGoTo=indexPath.row
        self.performSegueWithIdentifier("presentMeetingsForMonth", sender: self)
        }
        return true
    }
    
    var categoryIndexToGoTo:Int=0
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        /*
        Let the detail View Controller know what the desired category is.
        */
        
        if (segue.destinationViewController.isKindOfClass(MeetingsDetailController.self)){
            (segue.destinationViewController as! MeetingsDetailController).categoryNumber=categoryIndexToGoTo
        }
        if (segue.destinationViewController.isKindOfClass(MeetingsContentDetailController.self)){
            (segue.destinationViewController as! MeetingsContentDetailController).monthID=categoryIndexToGoTo
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        /*
        This handles the frame sizes of the previews without destroying ratios.
        */
        
        let multiplier:CGFloat=0.80
        let ratio:CGFloat=1.77777777777778
        let width:CGFloat=360
        return CGSize(width: width*ratio*multiplier, height: width*multiplier) //Currently set to 512,288
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
    
    
    
    func menuButtonAction(sender:AnyObject?){
        print("pressed menu")
        //UIApplication *myapp = [UIApplication sharedApplication];
        //[myapp performSelector:@selector(suspend)];
        UIApplication.sharedApplication().performSelector("suspend")
    }
}

