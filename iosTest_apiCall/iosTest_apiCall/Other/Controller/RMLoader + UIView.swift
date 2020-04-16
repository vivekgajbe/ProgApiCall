//
//  RMLoader + UIView.swift
//  Mobank
//
//  Reference Link : https://github.com/Rannie/Toast-Swift
//

/*
 
 Class Description : RMLoader + UIView.swift
 
 This is a Loader extension of UIView which is used to show loader animation
 */


import UIKit

/*
 *  Infix overload method
 */
func /(lhs: CGFloat, rhs: Int) -> CGFloat {
    return lhs / CGFloat(rhs)
}

/*
 *  Toast Config
 */
let RMLoaderDefaultDuration  =   2.0
let RMLoaderFadeDuration     =   0.2
let RMLoaderHorizontalMargin : CGFloat  =   10.0
let RMLoaderVerticalMargin   : CGFloat  =   10.0

let RMLoaderPositionDefault  =   "bottom"
let RMLoaderPositionTop      =   "top"
let RMLoaderPositionCenter   =   "center"

// activity
let RMLoaderActivityWidth  :  CGFloat  = 100.0
let RMLoaderActivityHeight :  CGFloat  = 100.0
let RMLoaderActivityPositionDefault    = "center"

// image size
let RMLoaderImageViewWidth :  CGFloat  = 80.0
let RMLoaderImageViewHeight:  CGFloat  = 80.0

// label setting
let RMLoaderMaxWidth       :  CGFloat  = 0.8;      // 80% of parent view width
let RMLoaderMaxHeight      :  CGFloat  = 0.8;
let RMLoaderFontSize       :  CGFloat  = 16.0
let RMLoaderMaxTitleLines              = 0
let RMLoaderMaxMessageLines            = 0

// shadow appearance
let RMLoaderShadowOpacity  : CGFloat   = 0.8
let RMLoaderShadowRadius   : CGFloat   = 6.0
let RMLoaderShadowOffset   : CGSize    = CGSize(width: CGFloat(4.0), height: CGFloat(4.0))

let RMLoaderOpacity        : CGFloat   = 0.9
let RMLoaderCornerRadius   : CGFloat   = 10.0

var RMLoaderActivityView: UnsafePointer<UIView>?    =   nil
var RMLoaderTimer: UnsafePointer<Timer>?          =   nil
var RMLoaderView: UnsafePointer<UIView>?            =   nil
var RMLoaderThemeColor : UnsafePointer<UIColor>?    =   nil
var RMLoaderTitleFontName: UnsafePointer<String>?   =   nil
var RMLoaderFontName: UnsafePointer<String>?        =   nil
var RMLoaderFontColor: UnsafePointer<UIColor>?      =   nil

/*
 *  Custom Config
 */
let RMLoaderHidesOnTap       =   true
let RMLoaderDisplayShadow    =   true

//RMLoader (UIView + Toast using Swift)
public extension UIView {
    
    /*
     *  public methods
     */
    class func hr_setToastThemeColor(color: UIColor) {
        objc_setAssociatedObject(self, &RMLoaderThemeColor, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    class func hr_toastThemeColor() -> UIColor {
        var color = objc_getAssociatedObject(self, &RMLoaderThemeColor) as! UIColor?
        if color == nil {
            color = UIColor.black
            UIView.hr_setToastThemeColor(color: color!)
        }
        return color!
    }
    
    class func hr_setToastTitleFontName(fontName: String) {
        objc_setAssociatedObject(self, &RMLoaderTitleFontName, fontName, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    class func hr_toastTitleFontName() -> String {
        var name = objc_getAssociatedObject(self, &RMLoaderTitleFontName) as! String?
        if name == nil {
            let font = UIFont.systemFont(ofSize: 12.0)
            name = font.fontName
            UIView.hr_setToastTitleFontName(fontName: name!)
        }
        
        return name!
    }
    
    class func hr_setToastFontName(fontName: String) {
        objc_setAssociatedObject(self, &RMLoaderFontName, fontName, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    class func hr_toastFontName() -> String {
        var name = objc_getAssociatedObject(self, &RMLoaderFontName) as! String?
        if name == nil {
            let font = UIFont.systemFont(ofSize: 12.0)
            name = font.fontName
            UIView.hr_setToastFontName(fontName: name!)
        }
        
        return name!
    }
    
    class func hr_setToastFontColor(color: UIColor) {
        objc_setAssociatedObject(self, &RMLoaderFontColor, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    class func hr_toastFontColor() -> UIColor {
        var color = objc_getAssociatedObject(self, &RMLoaderFontColor) as! UIColor?
        if color == nil {
            color = UIColor.white
            UIView.hr_setToastFontColor(color: color!)
        }
        
        return color!
    }
    
    func makeToast(message msg: String) {
        makeToast(message: msg, duration: RMLoaderDefaultDuration, position: RMLoaderPositionCenter as AnyObject)
    }
    func make1SecToast(message msg: String) {
        makeToast(message: msg, duration: 1.0, position: RMLoaderPositionDefault as AnyObject)
    }
    
    func makeToast(message msg: String, duration: Double, position: AnyObject) {
        let toast = self.viewForMessage(msg, title: nil, image: nil)
        showToast(toast: toast!, duration: duration, position: position)
    }
    
    func makeToast(message msg: String, duration: Double, position: AnyObject, title: String) {
        let toast = self.viewForMessage(msg, title: title, image: nil)
        showToast(toast: toast!, duration: duration, position: position)
    }
    
    func makeToast(message msg: String, duration: Double, position: AnyObject, image: UIImage) {
        let toast = self.viewForMessage(msg, title: nil, image: image)
        showToast(toast: toast!, duration: duration, position: position)
    }
    
    func makeToast(message msg: String, duration: Double, position: AnyObject, title: String, image: UIImage) {
        let toast = self.viewForMessage(msg, title: title, image: image)
        showToast(toast: toast!, duration: duration, position: position)
    }
    
    func showToast(toast: UIView) {
        showToast(toast: toast, duration: RMLoaderDefaultDuration, position: RMLoaderPositionDefault as AnyObject)
    }
    
    fileprivate func showToast(toast: UIView, duration: Double, position: AnyObject) {
        let existToast = objc_getAssociatedObject(self, &RMLoaderView) as! UIView?
        if existToast != nil {
            if let timer: Timer = objc_getAssociatedObject(existToast as Any, &RMLoaderTimer) as? Timer {
                timer.invalidate()
            }
            hideToast(toast: existToast!, force: false);
            print("hide exist!")
        }
        
        toast.center = centerPointForPosition(position, toast: toast)
        toast.alpha = 0.0
        
        if RMLoaderHidesOnTap {
            let tapRecognizer = UITapGestureRecognizer(target: toast, action: #selector(UIView.handleLoaderTapped(_:)))
            toast.addGestureRecognizer(tapRecognizer)
            toast.isUserInteractionEnabled = true;
            toast.isExclusiveTouch = true;
        }
        
        addSubview(toast)
        objc_setAssociatedObject(self, &RMLoaderView, toast, .OBJC_ASSOCIATION_RETAIN)
        
        UIView.animate(withDuration: RMLoaderFadeDuration,
                       delay: 0.0, options: ([.curveEaseOut, .allowUserInteraction]),
                       animations: {
                        toast.alpha = 1.0
        },
                       completion: { (finished: Bool) in
                        let timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(UIView.loaderTimerDidFinish(_:)), userInfo: toast, repeats: false)
                        objc_setAssociatedObject(toast, &RMLoaderTimer, timer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        })
    }
//    func makeToastActivity_WithImage(img:UIImage)
//    {
//        makeToastActivity(position: RMLoaderActivityPositionDefault as AnyObject,img:img)
//    }
    func makeToastActivity() {
        makeToastActivity(position: RMLoaderActivityPositionDefault as AnyObject)
    }
    
    func makeToastActivity(message msg: String){
        makeToastActivity(position: RMLoaderActivityPositionDefault as AnyObject, message: msg)
    }
    
    fileprivate func makeToastActivity(position pos: AnyObject, message msg: String = "") // image check for
    {
        let existingActivityView: UIView? = objc_getAssociatedObject(self, &RMLoaderActivityView) as? UIView
        if existingActivityView != nil { return }
        
        let activityView = UIView(frame: CGRect(x: 0, y: 0, width: RMLoaderActivityWidth, height: RMLoaderActivityHeight))
        activityView.layer.cornerRadius = RMLoaderCornerRadius
        
        activityView.center = self.centerPointForPosition(pos, toast: activityView)
        activityView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.0)
        activityView.alpha = 0.0
        activityView.autoresizingMask = ([.flexibleLeftMargin, .flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin])
        
        
        if RMLoaderDisplayShadow {
            activityView.layer.shadowColor = UIView.hr_toastThemeColor().cgColor
            activityView.layer.shadowOpacity = Float(RMLoaderShadowOpacity)
            activityView.layer.shadowRadius = RMLoaderShadowRadius
            activityView.layer.shadowOffset = RMLoaderShadowOffset
        }
        
        let activityIndicatorView = UIImageView()
        activityIndicatorView.image = UIImage.gifImageWithName("RMLoader")
        activityIndicatorView.frame = CGRect(x: 0, y: 0, width: 100 , height: 100)
        activityIndicatorView.center = CGPoint(x: activityView.bounds.size.width / 2, y: activityView.bounds.size.height / 2)
        self.isUserInteractionEnabled = false;
        activityView.addSubview(activityIndicatorView)
        
        
        if (!msg.isEmpty){
            activityIndicatorView.frame.origin.y -= 10
            let activityMessageLabel = UILabel(frame: CGRect(x: activityView.bounds.origin.x, y: (activityIndicatorView.frame.origin.y + activityIndicatorView.frame.size.height + 10), width: activityView.bounds.size.width, height: 20))
            activityMessageLabel.textColor = UIView.hr_toastFontColor()
            activityMessageLabel.font = (msg.count<=10) ? UIFont(name:UIView.hr_toastFontName(), size: 16) : UIFont(name:UIView.hr_toastFontName(), size: 13)
            activityMessageLabel.textAlignment = .center
            activityMessageLabel.text = msg
            activityView.addSubview(activityMessageLabel)
        }
        
        let bgView = UIView()
        bgView.frame = CGRect(x: 0, y: 0, width: (Constants.APP_DEL.window?.frame.width)!, height: (Constants.APP_DEL.window?.frame.height)!)
        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        addSubview(bgView)
        
//        if img != #imageLiteral(resourceName: "apple")
//        {
//            let activityIndicatorView = UIImageView()
//            activityIndicatorView.image = img
//            activityIndicatorView.frame = CGRect(x: 20, y: activityView.frame.origin.y + 100, width: (Constants .APP_DEL.window?.frame.width)! - 40 , height: (Constants .APP_DEL.window?.frame.width)! / 2)
//            //activityIndicatorView.center = CGPoint(x: activityView.bounds.size.width / 2, y: activityView.bounds.size.height / 2)
//            self.isUserInteractionEnabled = false;
//            activityIndicatorView.contentMode = .scaleAspectFit
//            bgView.addSubview(activityIndicatorView)
//        }
        
        bgView.addSubview(activityView)
        
        // associate activity view with self
        objc_setAssociatedObject(self, &RMLoaderActivityView, bgView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        UIView.animate(withDuration: RMLoaderFadeDuration,
                       delay: 0.0,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: {
                        activityView.alpha = 1.0
                        
        },
                       completion: nil)
    }
    
    func hideRMLoader() {
        DispatchQueue.main.async {
            let existingActivityView = objc_getAssociatedObject(self, &RMLoaderActivityView) as! UIView?
            if existingActivityView == nil { return }
            self.isUserInteractionEnabled = true;
            UIView.animate(withDuration: RMLoaderFadeDuration,
                           delay: 0.0,
                           options: UIView.AnimationOptions.curveEaseOut,
                           animations: {
                            existingActivityView!.alpha = 0.0
            },
                           completion: { (finished: Bool) in
                            existingActivityView!.removeFromSuperview()
                            objc_setAssociatedObject(self, &RMLoaderActivityView, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            })
        }
    }
    
    /*
     *  private methods (helper)
     */
    func hideToast(toast: UIView) {
        hideToast(toast: toast, force: false);
    }
    
    func hideToast(toast: UIView, force: Bool) {
        let completeClosure = { (finish: Bool) -> () in
            toast.removeFromSuperview()
            objc_setAssociatedObject(self, &RMLoaderTimer, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        if force {
            completeClosure(true)
        } else {
            UIView.animate(withDuration: RMLoaderFadeDuration,
                           delay: 0.0,
                           options: ([.curveEaseIn, .beginFromCurrentState]),
                           animations: {
                            toast.alpha = 0.0
            },
                           completion:completeClosure)
        }
    }
    
    @objc func loaderTimerDidFinish(_ timer: Timer) {
        hideToast(toast: timer.userInfo as! UIView)
    }
    
    @objc func handleLoaderTapped(_ recognizer: UITapGestureRecognizer) {
        let timer = objc_getAssociatedObject(self, &RMLoaderTimer) as! Timer
        timer.invalidate()
        
        hideToast(toast: recognizer.view!)
    }
    
    fileprivate func centerPointForPosition(_ position: AnyObject, toast: UIView) -> CGPoint {
        if position is String {
            let toastSize = toast.bounds.size
            let viewSize  = self.bounds.size
            if position.lowercased == RMLoaderPositionTop {
                return CGPoint(x: viewSize.width/2, y: toastSize.height/2 + RMLoaderVerticalMargin)
            } else if position.lowercased == RMLoaderPositionDefault {
                return CGPoint(x: viewSize.width/2, y: viewSize.height - toastSize.height/2 - RMLoaderVerticalMargin)
            } else if position.lowercased == RMLoaderPositionCenter {
                return CGPoint(x: viewSize.width/2, y: viewSize.height/2)
            }
        } else if position is NSValue {
            return position.cgPointValue
        }
        
        print("[Toast-Swift]: Warning! Invalid position for toast.")
        return self.centerPointForPosition(RMLoaderPositionDefault as AnyObject, toast: toast)
    }
    
    fileprivate func viewForMessage(_ msg: String?, title: String?, image: UIImage?) -> UIView? {
        if msg == nil && title == nil && image == nil { return nil }
        
        var msgLabel: UILabel?
        var titleLabel: UILabel?
        var imageView: UIImageView?
        
        let wrapperView = UIView()
        wrapperView.autoresizingMask = ([.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin])
        wrapperView.layer.cornerRadius = RMLoaderCornerRadius
        wrapperView.backgroundColor = UIView.hr_toastThemeColor().withAlphaComponent(RMLoaderOpacity)
        
        if RMLoaderDisplayShadow {
            wrapperView.layer.shadowColor = UIView.hr_toastThemeColor().cgColor
            wrapperView.layer.shadowOpacity = Float(RMLoaderShadowOpacity)
            wrapperView.layer.shadowRadius = RMLoaderShadowRadius
            wrapperView.layer.shadowOffset = RMLoaderShadowOffset
        }
        
        if image != nil {
            imageView = UIImageView(image: image)
            imageView!.contentMode = .scaleAspectFit
            imageView!.frame = CGRect(x: RMLoaderHorizontalMargin, y: RMLoaderVerticalMargin, width: CGFloat(RMLoaderImageViewWidth), height: CGFloat(RMLoaderImageViewHeight))
        }
        
        var imageWidth: CGFloat, imageHeight: CGFloat, imageLeft: CGFloat
        if imageView != nil {
            imageWidth = imageView!.bounds.size.width
            imageHeight = imageView!.bounds.size.height
            imageLeft = RMLoaderHorizontalMargin
        } else {
            imageWidth  = 0.0; imageHeight = 0.0; imageLeft   = 0.0
        }
        
        if title != nil {
            titleLabel = UILabel()
            titleLabel!.numberOfLines = RMLoaderMaxTitleLines
            titleLabel!.font = UIFont(name: UIView.hr_toastFontName(), size: RMLoaderFontSize)
            titleLabel!.textAlignment = .center
            titleLabel!.lineBreakMode = .byWordWrapping
            titleLabel!.textColor = UIView.hr_toastFontColor()
            titleLabel!.backgroundColor = UIColor.clear
            titleLabel!.alpha = 1.0
            titleLabel!.text = title
            
            // size the title label according to the length of the text
            let maxSizeTitle = CGSize(width: (self.bounds.size.width * RMLoaderMaxWidth) - imageWidth, height: self.bounds.size.height * RMLoaderMaxHeight);
            let expectedHeight = title!.stringHeightWithFontSize(RMLoaderFontSize, width: maxSizeTitle.width)
            titleLabel!.frame = CGRect(x: 0.0, y: 0.0, width: maxSizeTitle.width, height: expectedHeight)
        }
        
        if msg != nil {
            msgLabel = UILabel();
            msgLabel!.numberOfLines = RMLoaderMaxMessageLines
            msgLabel!.font = UIFont(name: UIView.hr_toastFontName(), size: RMLoaderFontSize)
            msgLabel!.lineBreakMode = .byWordWrapping
            msgLabel!.textAlignment = .center
            msgLabel!.textColor = UIView.hr_toastFontColor()
            msgLabel!.backgroundColor = UIColor.clear
            msgLabel!.alpha = 1.0
            msgLabel!.text = msg
            
            let maxSizeMessage = CGSize(width: (self.bounds.size.width * RMLoaderMaxWidth) - imageWidth, height: self.bounds.size.height * RMLoaderMaxHeight)
            let expectedHeight = msg!.stringHeightWithFontSize(RMLoaderFontSize, width: maxSizeMessage.width)
            msgLabel!.frame = CGRect(x: 0.0, y: 0.0, width: maxSizeMessage.width, height: expectedHeight)
        }
        
        var titleWidth: CGFloat, titleHeight: CGFloat, titleTop: CGFloat, titleLeft: CGFloat
        if titleLabel != nil {
            titleWidth = titleLabel!.bounds.size.width
            titleHeight = titleLabel!.bounds.size.height
            titleTop = RMLoaderVerticalMargin
            titleLeft = imageLeft + imageWidth + RMLoaderHorizontalMargin
        } else {
            titleWidth = 0.0; titleHeight = 0.0; titleTop = 0.0; titleLeft = 0.0
        }
        
        var msgWidth: CGFloat, msgHeight: CGFloat, msgTop: CGFloat, msgLeft: CGFloat
        if msgLabel != nil {
            msgWidth = msgLabel!.bounds.size.width
            msgHeight = msgLabel!.bounds.size.height
            msgTop = titleTop + titleHeight + RMLoaderVerticalMargin
            msgLeft = imageLeft + imageWidth + RMLoaderHorizontalMargin
        } else {
            msgWidth = 0.0; msgHeight = 0.0; msgTop = 0.0; msgLeft = 0.0
        }
        
        let largerWidth = max(titleWidth, msgWidth)
        let largerLeft  = max(titleLeft, msgLeft)
        
        // set wrapper view's frame
        let wrapperWidth  = max(imageWidth + RMLoaderHorizontalMargin * 2, largerLeft + largerWidth + RMLoaderHorizontalMargin)
        let wrapperHeight = max(msgTop + msgHeight + RMLoaderVerticalMargin, imageHeight + RMLoaderVerticalMargin * 2)
        wrapperView.frame = CGRect(x: 0.0, y: 0.0, width: wrapperWidth, height: wrapperHeight)
        
        // add subviews
        if titleLabel != nil {
            titleLabel!.frame = CGRect(x: titleLeft, y: titleTop, width: titleWidth, height: titleHeight)
            wrapperView.addSubview(titleLabel!)
        }
        if msgLabel != nil {
            msgLabel!.frame = CGRect(x: msgLeft, y: msgTop, width: msgWidth, height: msgHeight)
            wrapperView.addSubview(msgLabel!)
        }
        if imageView != nil {
            wrapperView.addSubview(imageView!)
        }
        
        return wrapperView
    }
    
}

public extension String {
    
    func stringHeightWithFontSize(_ fontSize: CGFloat,width: CGFloat) -> CGFloat {
        let font = UIFont(name: UIView.hr_toastFontName(), size: RMLoaderFontSize)
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        let attributes = [NSAttributedString.Key.font:font!,
                          NSAttributedString.Key.paragraphStyle:paragraphStyle.copy()]//NSFontAttributeName
        
        let text = self as NSString
        let rect = text.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: attributes, context:nil)
        return rect.size.height
    }
    
}
