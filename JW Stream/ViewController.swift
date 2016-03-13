//
//  ViewController.swift
//  JW Stream
//
//  Created by Austin Zelenka on 2/29/16.
//  Copyright © 2016 xquared. All rights reserved.
//

import UIKit
import JavaScriptCore
/*
#import <CommunicationsSetupUI/NSObject-Protocol.h>

@class NSError, NSURLRequest, UIWebView;

@protocol UIWebViewDelegate <NSObject>

@optional
- (void)webView:(UIWebView *)arg1 didFailLoadWithError:(NSError *)arg2;
- (void)webViewDidFinishLoad:(UIWebView *)arg1;
- (void)webViewDidStartLoad:(UIWebView *)arg1;
- (_Bool)webView:(UIWebView *)arg1 shouldStartLoadWithRequest:(NSURLRequest *)arg2 navigationType:(long long)arg3;
@end
*/
/*
class UIWebView : UIView{
}

@objc protocol UIWebViewDelegate : NSObjectProtocol {
    func webView(arg1:UIWebView, shouldStartLoadWithRequest arg2:NSURLRequest, navigationType arg3:CUnsignedLongLong) -> Bool;
}*/

@objc protocol ScriptingEngineExports : JSExport {
    func messageFromPusher(message: String)
}

class ViewController: UIViewController, UITextFieldDelegate, ScriptingEngineExports {
    @IBOutlet weak var textView: UITextField!
    @IBOutlet var codeKeys: [UILabel]!
    
    var preventMenuReturn:Bool = true

    var code=""
    var context = JSContext()
    let engineQueue = dispatch_queue_create(
        "script_engine", DISPATCH_QUEUE_SERIAL)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        for codeKey in self.codeKeys {
            codeKey.layer.cornerRadius=7.5
            codeKey.layer.borderColor=UIColor.grayColor().CGColor
            codeKey.layer.borderWidth=1
            codeKey.clipsToBounds=true
        }
        
        let UUID=NSUserDefaults.standardUserDefaults().objectForKey("UUID")
        
        if (UUID == nil){
            NSUserDefaults.standardUserDefaults().setObject(NSUUID().UUIDString, forKey: "UUID")
        }
        
        
        let pendingCode=NSUserDefaults.standardUserDefaults().objectForKey("pendingCode")
        if (pendingCode != nil && pendingCode is String && pendingCode as! String != ""){
            print(code)
            code = pendingCode as! String
            print(code)
            var i=0
            for codeKey in self.codeKeys {
                codeKey.text="\(self.code[self.code.startIndex.advancedBy(i)])"
                i++
            }
            //server is code bound?
            self.checkServer()
        }
        else {
            //pusher
            self.pendingCode()
        }
        
        if (code == ""){
            // ake new code
            self.generateCode()
        }
        
    }
    
    func pendingCode(){
        
        let webViewClass : AnyObject.Type = NSClassFromString("UIWebView")!
        let webViewObject : NSObject.Type = webViewClass as! NSObject.Type
        let webview: AnyObject = webViewObject.init()
        /*let url = NSURL(string: "https://www.google.com")
        let request = NSURLRequest(URL: url!)
        webview.loadRequest(request)*/
        webview.loadRequest(NSURLRequest(URL: NSBundle.mainBundle().URLForResource("pusher", withExtension: "html")!))
        let uiview = webview as! UIView
        uiview.frame = CGRectMake(0, 0, 0, 0)
        view.addSubview(uiview)
        uiview.hidden=true
        
        let context = webview.valueForKeyPath("documentView.webView.mainFrame.javaScriptContext") as! JSContext
        context.evaluateScript("var uuid='\(NSUserDefaults.standardUserDefaults().objectForKey("UUID")!)';")
        
        //context.objectForKeyedSubscript("console").setObject(unsafeBitCast(logFunction, AnyObject.self), forKeyedSubscript: "log")
        dispatch_async(engineQueue) {
            self.context = context
            self.context.setObject(self, forKeyedSubscript: "$")
            self.context.evaluateScript(
                "function messageFromPusher(message) {$.messageFromPusher(message);}")
        }
        
        // get the contentData for the file
        let frameworkContentData = dataUsingCache("http://js.pusher.com/3.0/pusher.min.js")
        // get the string from the data
        
        let frameworkContent = NSString(data: frameworkContentData!, encoding: NSUTF8StringEncoding) as? String
        // finally inject it into the js context
        context.evaluateScript(frameworkContent)
    }
    
    /*func webView(arg1:UIWebView, shouldStartLoadWithRequest request:NSURLRequest, navigationType arg3:CUnsignedLongLong) -> Bool{
        
        //NSString *requestString = [[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        let requestString=request.URL?.absoluteString.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        
        if (requestString == "") {
           // NSString* logString = [[requestString componentsSeparatedByString:@":#iOS#"] objectAtIndex:1];
           // NSLog(@"UIWebView console: %@", logString);
            print(request)
            return false
        }
        
        return true
    }*/
    
    func messageFromPusher(message: String){
        print("message from pusher")
        let json=unfold(message.dataUsingEncoding(NSUTF8StringEncoding), instructions: [])
        if (json != nil && json is NSDictionary){
            if ((json?.objectForKey("approved"))! as! String == "true"){
                self.performSegueWithIdentifier("showMainPage", sender: nil)
                print("Yay! we can now watch hours of videos together!")
            }
            else if ((json?.objectForKey("disabled"))! as! String == "true"){
                NSUserDefaults.standardUserDefaults().setObject(NSUUID().UUIDString, forKey: "UUID")
                NSUserDefaults.standardUserDefaults().removeObjectForKey("pendingCode")
                self.performSegueWithIdentifier("lostAccess", sender: nil)
                print("What happened?! We were good friends ):")
            }
        }
        else {
            print(message)
        }
    }
    
    func generateCode(){
        
        //CFUUIDRef theUUID = CFUUIDCreate(NULL);
        //CFStringRef string = CFUUIDCreateString(NULL, theUUID);
        //CFRelease(theUUID);
        let uuid=NSUserDefaults.standardUserDefaults().objectForKey("UUID")
        
        let codeCreationURL="http://xquared.com:8888/createCode?uuid=\(uuid!)"
        print(codeCreationURL)
        
        fetchDataUsingCache(codeCreationURL,downloaded: {
            dispatch_async(dispatch_get_main_queue(), {
                self.code=unfold("\(codeCreationURL)|code") as! String
                if (self.code != ""){
                    var i=0
                    NSUserDefaults.standardUserDefaults().setObject(self.code, forKey: "pendingCode")
                    for codeKey in self.codeKeys {
                        codeKey.text="\(self.code[self.code.startIndex.advancedBy(i)])"
                        i++
                    }
                    
                    
                    //self.checkServer()
                }
                else {
                    self.generateCode()
                }
                
                })
            },usingCache: false, failed:{
                self.generateCode()
        })
    }
    
    func checkServer(){
        //if (code != ""){
        
        fetchDataUsingCache("http://xquared.com:8888/isCodeBound?code=\(code)",downloaded: {
            dispatch_async(dispatch_get_main_queue(), {
                let approved=unfold("http://xquared.com:8888/isCodeBound?code=\(self.code)|codeApproved") as! String
                if (approved == "true"){
                    print("code approved")
                    self.performSegueWithIdentifier("showMainPage", sender: nil)
                }
                else if (approved == "false"){
                    self.pendingCode()
                }
                /*else {
                    print("waiting for code approval...")
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                        self.checkServer()
                    })
                }*/
            })
            },usingCache: false, failed:  {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                    self.checkServer()
                })
        })
        //}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let final=(textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        if (final.characters.count>5){
            textField.text=""
            self.view.window?.endEditing(true)
            fetchDataUsingCache("http://xquared.com:8888/broadcast/checkCode.php?code=\(final)", downloaded: {
                dispatch_async(dispatch_get_main_queue(), {
                
                    self.loginBasedOn("http://xquared.com:8888/broadcast/checkCode.php?code=\(final)")
                
                })
            }, usingCache:false)
        }
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        print("test")
        
        //self.performSegueWithIdentifier("showMainPage", sender: self)
    }*/
    /*
    func loginBasedOn(file:String){
        if (unfold("\(file)|confirmed") != nil){
            if (unfold("\(file)|confirmed") as! String == "true"){
                print("login success \(unfold("\(file)"))")
                
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                    self.performSegueWithIdentifier("showMainPage", sender: self)
                })
                return
            }
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            self.textView.becomeFirstResponder()
        })
    }*/
    
}

