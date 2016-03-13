//
//  MeetingsDetailController.swift
//  JW Broadcasting
//
//  Created by Austin Zelenka on 1/19/16.
//  Copyright © 2016 xquared. All rights reserved.
//

import UIKit

class MeetingsDetailController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var _categoryNumber=0
    var categoryNumber=0
    
    let videos=unfold(NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("languageVideos", ofType: nil)!), instructions: []) as? [NSDictionary] // Download the video data
    
    var preparedVideos:[NSDictionary]=[] // Variable for run time organized video data
    
    let player=SuperMediaPlayer()
    
    @IBOutlet weak var VideoHorizontalView: UICollectionView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var NoVideosLabel: UILabel!
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categoryTitleLabelB: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //(self.VideoHorizontalView.collectionViewLayout as! CollectionViewHorizontalFlowLayout).spacingPercentile=1.5
        (self.VideoHorizontalView.collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing=100
        (self.VideoHorizontalView.collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing=100
        
        self.VideoHorizontalView.clipsToBounds=false
        self.updateForNewId()
        
    }
    
    func updateForNewId(){
        /*
        Display the appropriate title text and picture for the chosen category.
        */
        
        if (categoryTitleLabel == nil || categoryImageView == nil || tableView == nil || VideoHorizontalView == nil || backgroundImage == nil || NoVideosLabel == nil){
            print("failed")
            return
        }
        print("update")
        
        if (categoryNumber == 1){
            categoryTitleLabel.hidden=true
            categoryTitleLabelB.text="Meetings"
            categoryTitleLabelB.hidden=true
            //categoryImageView.image=UIImage(named: "weekly-meeings-real-2.png")
            self.VideoHorizontalView.hidden=false
            self.backgroundImage.hidden=false
            self.tableView.hidden=true
            self.view.backgroundColor=UIColor.whiteColor()
            self.categoryTitleLabel.textAlignment = .Left
            self.categoryTitleLabel.textColor = UIColor.blackColor()
            self.categoryImageView.hidden=true
            self.backgroundImage.clipsToBounds=true
            self.view.backgroundColor=UIColor.lightGrayColor()
            //self.backgroundImage.image=self.backgroundImage.image?.imageWithAlignmentRectInsets(UIEdgeInsets(top: -(self.backgroundImage.image!.size.height-self.backgroundImage.frame.size.height), left: 0, bottom: 0, right: 0))
            
            
            self.backgroundImage.image=UIImage(named: "weekly-meetings-real-1.png")
        }
        else if (categoryNumber == 2){
            categoryTitleLabel.hidden=true
            categoryTitleLabelB.text="Assemblies"
            categoryTitleLabelB.hidden=true
            //categoryImageView.image=UIImage(named: "Assembly.png")
            self.VideoHorizontalView.hidden=false
            self.backgroundImage.hidden=false
            self.backgroundImage.image=UIImage(named: "Assembly.png")
            self.tableView.hidden=true
            self.view.backgroundColor=UIColor.whiteColor()
            self.categoryTitleLabel.textAlignment = .Left
            self.categoryTitleLabel.textColor = UIColor.blackColor()
            self.categoryImageView.hidden=true
            self.backgroundImage.clipsToBounds=true
            //self.backgroundImage.image=self.backgroundImage.image?.imageWithAlignmentRectInsets(UIEdgeInsets(top: -(self.backgroundImage.image!.size.height-self.backgroundImage.frame.size.height), left: 0, bottom: 0, right: 0))
            
            self.view.backgroundColor=UIColor(colorLiteralRed: 0.3, green: 0.44, blue: 0.64, alpha: 1.0)
            
            
        }
        else if (categoryNumber == 3){
            categoryTitleLabel.text="2015 Imitate Jesus!\n Regional Convention"
            categoryTitleLabelB.hidden=true
            categoryTitleLabel.numberOfLines=2
            categoryImageView.image=UIImage(named: "conventions.jpeg")
            self.VideoHorizontalView.hidden=false
            self.backgroundImage.hidden=false
            self.tableView.hidden=true
            self.backgroundImage.clipsToBounds=true
            self.view.backgroundColor=UIColor(colorLiteralRed: 35/255, green: 60/255, blue: 62/255, alpha: 1)
            //self.backgroundImage.image=self.backgroundImage.image?.imageWithAlignmentRectInsets(UIEdgeInsets(top: -(self.backgroundImage.image!.size.height-self.backgroundImage.frame.size.height), left: 0, bottom: 0, right: 0))
            
        }
        
        
        /*
        Videos in Stream.JW.org are not organized.
        Using the data for the videos contained in self.videos we sort out only the videos that pretain to this section (Weekly Meetings, Assemblies, Regional Conventions).
        
        */
        preparedVideos=[]
        
        for video in videos! {
            
            if ((video.objectForKey("data")!.objectForKey("section") as! String) == "\(categoryNumber)" || ((categoryNumber == 1 && (video.objectForKey("data")!.objectForKey("section") as! String) == "\(2)"))){
                self.preparedVideos.append(video)
            }
        }
        
        /*
        If there are no videos in this section then display the text for no videos.
        
        */
        
        if (preparedVideos.count==0){
            //NoVideosLabel.hidden=false
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        /*
        We only are displaying 1 section of content and the table view needs to know that.
        */
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*
        Give the table view the number of videos in the section so that it generates the right amount of rows.
        */
        
        return preparedVideos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /*
        Generate a row with the title text provided from Stream.JW.org (Exp. Circuit Assembly with Branch Representative - Morning)
        */
        
        let cell=tableView.dequeueReusableCellWithIdentifier("item", forIndexPath: indexPath)
        
        if (categoryNumber == 2){
            cell.textLabel?.text="2015 \(preparedVideos[indexPath.row].objectForKey("title") as! String)"
        }
        else {
            cell.textLabel?.text=preparedVideos[indexPath.row].objectForKey("title") as? String
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        /*
        The rows by default seem rather small for TVOS so we bump up the size.
        */
        return 90
    }
    
    var monthToGoTo=0
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        /*
        Using our custom player we play the hls formatted file.
        HLS is nicer than a regular mp4 because it provides bit rate adjustments.
        Sadly at this time tv.jw.org does not use HLS.
        */
        
        
        player.updatePlayerUsingString(unfold(preparedVideos, instructions:  [indexPath.row,"data","vod_url_hls"]) as! String)
        player.playIn(self)
    }
    
    
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return preparedVideos.count
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
                if (categoryNumber == 3){
                    imageView.image=UIImage(named: "Day-1")
                }
                else if (categoryNumber == 2) {
                    if (indexPath.row%2==0){
                        imageView.image=UIImage(named: "Morning Session-2.png")
                    }
                    else {
                        imageView.image=UIImage(named: "Afternoon Session-2.png")
                    }
                }
                else if (categoryNumber == 1) {
                    if (indexPath.row%2==0){
                        imageView.image=UIImage(named: "Public Talk.png")
                    }
                    else {
                        imageView.image=UIImage(named: "Watchtower Study.png")
                    }
                }
                imageView.userInteractionEnabled = true
                #if os(tvOS)
                    imageView.adjustsImageWhenAncestorFocused = true
                #endif
                /*let imageURL=unfold(categoryDataURL+"|category|subcategories|\(indexPath.row)|images|wss|lg") as? String
                
                imageView.userInteractionEnabled = true
                imageView.adjustsImageWhenAncestorFocused = true
                imageView.alpha=0.2
                if (imageURL != nil && imageURL != ""){
                
                fetchDataUsingCache(imageURL!, downloaded: {
                
                dispatch_async(dispatch_get_main_queue()) {
                if (cell.tag==indexPath.row){
                imageView.alpha=1
                let image=imageUsingCache(imageURL!)
                (subview as! UIImageView).image=image
                }
                }
                })
                }*/
            }
            if (subview.isKindOfClass(UILabel.self)){
                var checkedIndex=indexPath.row
                
                if ((preparedVideos[0].objectForKey("title") as? String)?.containsString("Afternoon") == true){
                    if ((preparedVideos[indexPath.row].objectForKey("title") as? String)?.containsString("Morning") == true) {
                        checkedIndex=checkedIndex-1
                    }
                    else {
                        checkedIndex=checkedIndex+1
                    }
                }
                
                if (categoryNumber == 3){
                    if (subview.tag == 0){
                    (subview as! UILabel).text=(preparedVideos[checkedIndex].objectForKey("title") as? String)?.stringByReplacingOccurrencesOfString("Regional Convention - ", withString: "")
                    }
                }
                
                if (categoryNumber == 2){
                    
                    if (subview.isKindOfClass(marqueeLabel.self)){
                        (subview as! marqueeLabel).textSideOffset=0
                    }
                    let titlesAfterCorrection=(preparedVideos[checkedIndex].objectForKey("title") as? String)?.stringByReplacingOccurrencesOfString("Circuit Assembly with ", withString: "").componentsSeparatedByString("-")
                    
                    if (subview.tag == 0){
                        (subview as! UILabel).text=titlesAfterCorrection![0].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                    }
                    else {
                        
                        (subview as! UILabel).text=titlesAfterCorrection![1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                    }
                }
                if (categoryNumber == 1){
                    
                    if (subview.isKindOfClass(marqueeLabel.self)){
                        (subview as! marqueeLabel).textSideOffset=0
                    }
                    if (subview.isKindOfClass(UILabel.self)){
                        (subview as! UILabel).textColor=UIColor.darkGrayColor()
                    }
                    
                    if (subview.tag == 0){
                        (subview as! UILabel).text="Week of"
                    }
                    else {
                        
                        (subview as! UILabel).text=["March 7-13","March 7-13","March 14-20","March 14-20"][indexPath.row]
                    }
                }
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
        
        var checkedIndex=indexPath.row
        
        if ((preparedVideos[0].objectForKey("title") as? String)?.containsString("Afternoon") == true){
            if ((preparedVideos[indexPath.row].objectForKey("title") as? String)?.containsString("Morning") == true) {
                checkedIndex=checkedIndex-1
            }
            else {
                checkedIndex=checkedIndex+1
            }
        }
        
        player.updatePlayerUsingString(unfold(preparedVideos, instructions:  [checkedIndex,"data","vod_url_hls"]) as! String)
        player.playIn(self)
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        /*
        Let the detail View Controller know what the desired category is.
        */
        
        if (segue.destinationViewController.isKindOfClass(MeetingsContentDetailController.self)){
            (segue.destinationViewController as! MeetingsContentDetailController).monthID=monthToGoTo
        }
    }
    
}
