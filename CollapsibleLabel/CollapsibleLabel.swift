//
//  CollapsibleLabel.swift
//  CollapsibleLabel
//
//  Created by Hilal Baig on 11/7/17.
//  Copyright © 2017 Baig. All rights reserved.
//

import UIKit

class CollapsibleLabel: UILabel {

    typealias Closure = ()->Void
    
    var moreClicked:Closure? = {}
    var lessClicked:Closure? = {}
    var noneClicked:Closure? = {}
    
    var moreTitle: String = "" {
        didSet {
            updateText()
        }
    }
    var lessTitle: String = "" {
        didSet {
            updateText()
        }
    }
    
    //public var actionTitleTextAttributes: [String: Any]?
    
    
    var wrapAfterIndex: Int = 0 {
        didSet {
            updateText()
        }
    }
    
    
    var autoExpand:Bool = false
    
    
    private var originalText: String = ""
    private var isExpanded:Bool = false {
        didSet {
            updateText()
        }
    }
    
    override var text: String? {
        didSet{
            originalText = text ?? ""
            updateText()
        }
    }
    
    
    private var tapGesture: UITapGestureRecognizer? = nil
    
    
    override func drawText(in rect: CGRect) {
        let textRect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        super.drawText(in: textRect)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeLabel()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeLabel()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initializeLabel()
    }
    
    func initializeLabel() {
        
        self.numberOfLines = 0
        originalText = text ?? ""
        self.isExpanded = false
        addTapGesture()
    }
    
    private func updateText() {
        if isExpanded == true {
            self.lblAttributedString(for: originalText, with: lessTitle)
        } else {
            self.lblAttributedString(for: minimalText(), with: moreTitle)
        }
    }
    
    private func lblAttributedString(for labelText:String, with actionText:String)  {
        
        
        let fullText = labelText + actionText
        
        //ful string attr
        let attribs = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont.systemFont(ofSize: 14.0)]
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: fullText, attributes: attribs)
        
        //btn string attr
        attributedString.addAttribute(NSLinkAttributeName, value: actionText, range: NSRange(location: labelText.utf16.count, length: actionText.utf16.count))
        attributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: labelText.utf16.count, length: actionText.utf16.count))
        

        
        
        
        self.attributedText = attributedString
        
        
    }
    
    
    
    private func minimalText() -> String{
        
        if(originalText.utf16.count > wrapAfterIndex) {
            let res = NSString(string: originalText)
            
            let subString = res.substring(to: wrapAfterIndex)
            
            if wrapAfterIndex == 0 {
                return originalText
            } else {
                return subString
            }
            
            
        } else {
            return originalText
        }
        
        
        
    }
    
    
    
    private func addTapGesture() {
        self.isUserInteractionEnabled = true
        if tapGesture == nil {
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapFunction(sender:)))
            self.addGestureRecognizer(tapGesture!)
        }
        
        
    }
    
    private func indexOfTappedCharacter(_ sender:UITapGestureRecognizer) -> Int {
        
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        //let textContainer = NSTextContainer(size: CGSize.zero)
        let textContainer = NSTextContainer(size: CGSize(width: self.frame.width, height: self.frame.height))

        let textStorage = NSTextStorage(attributedString: self.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = self.lineBreakMode
        textContainer.maximumNumberOfLines = self.numberOfLines
        let labelSize = self.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = tapGesture!.location(in: self)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        
        
        let textContainerOffset = CGPoint(x:(labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y:(labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x:locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y:locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        
        
        
        let index = text?.index ((text?.startIndex)!, offsetBy: indexOfCharacter)
        
        print("indexOfCharacter:\(indexOfCharacter) with string \(text![index!])")
        return indexOfCharacter
    }
    
    @objc private func tapFunction(sender:UITapGestureRecognizer) {
        
        switch isExpanded {
        case true:
            
            if isLessTapped(in: sender) {
                lessClicked?()
                toggleIsExpanded()
                
            } else {
                noneClicked?()
            }
            
        case false:
            
            
            if isMoreTapped(in: sender) {
                moreClicked?()
                toggleIsExpanded()
            } else {
                noneClicked?()
            }
        }
        
        
        
        
    }
    
    
    private func toggleIsExpanded() {
        if autoExpand {
            isExpanded = !isExpanded
        }
        
        
    }
    
    private func isMoreTapped(in sender:UITapGestureRecognizer) -> Bool {
        
        let moreTitleRange = (text! as NSString).range(of: moreTitle)
        let tapped = NSLocationInRange(indexOfTappedCharacter(sender), moreTitleRange)
        return tapped
        
    }
    
    private func isLessTapped(in sender:UITapGestureRecognizer) -> Bool {
        
        let lessTitleRange = (text! as NSString).range(of: lessTitle)
        let tapped = NSLocationInRange(indexOfTappedCharacter(sender), lessTitleRange)
        return tapped
        
    }
    
    
    
}

