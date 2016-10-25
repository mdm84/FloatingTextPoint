//
//  FloatingTextField.swift
//  Anywho
//
//  Created by Massimiliano Di Mella on 25/10/16.
//  Copyright © 2016 Massimiliano Di Mella. All rights reserved.
//

import UIKit

class FloatingTextField: UITextField,UITextFieldDelegate {
    
    var bottomLineView : UIView?
    var btmLineColor : UIColor?
    var placeHolderTextColor : UIColor?
    var selectedPlaceHolderTextColor : UIColor?
    var btmLineSelectionColor : UIColor?
    var labelPlaceholder : UILabel?
    var disableFloatingLabel : Bool?
    
    override func draw(_ rect: CGRect) {
        let rec = CGRect(x: self.frame.minX, y: self.frame.minY, width: rect.width, height: rect.height)
        updateTextField(frame: rec)
    }
    override func awakeFromNib() {
        initialization()
    }
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        delegate = self
        self.initialization()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
        self.initialization()
    }

    func initialization(){
        
        checkForDefaultLabel()
        
        if placeHolderTextColor == nil{
            placeHolderTextColor = UIColor.anyWarmGrey
        }
        if selectedPlaceHolderTextColor == nil{
            selectedPlaceHolderTextColor = UIColor.anySkyBlue
        }
        
        if btmLineColor == nil{
            btmLineColor = UIColor.anyWarmGrey
        }
        
        if btmLineSelectionColor == nil{
            btmLineColor = UIColor.anySkyBlue
        }
        
        bottomLineView?.removeFromSuperview()
        labelPlaceholder?.removeFromSuperview()
        
        if placeholder != "" && placeholder != nil{
            labelPlaceholder?.text = placeholder
        }
        let placeHolderText = labelPlaceholder?.text
        let fram = CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width, height: 2)
        bottomLineView = UIView(frame: fram)
        bottomLineView?.backgroundColor = btmLineColor
        bottomLineView?.tag = 20
        self.addSubview(bottomLineView!)
        
        labelPlaceholder = UILabel(frame: CGRect(x: 5, y: 0, width: self.frame.width - 5, height: self.frame.height))
        labelPlaceholder?.text = placeHolderText
        labelPlaceholder?.textAlignment = self.textAlignment
        labelPlaceholder?.textColor = placeHolderTextColor
        labelPlaceholder?.font = self.font
        labelPlaceholder?.tag = 21
        self.addSubview(labelPlaceholder!)
        if self.text != ""{
            floatTheLabel()
        }
    }
    func checkForDefaultLabel(){
        
        if self.text == ""{
            for view in self.subviews{
                if view is UILabel{
                    let newLabel = (view as! UILabel)
                    if newLabel.tag != 21{
                        newLabel.isHidden = true
                    }
                }
            }
        }else{
            for view in self.subviews{
                if view is UILabel{
                    let newLabel = (view as! UILabel)
                    if newLabel.tag != 21{
                        newLabel.isHidden = false
                    }
                }
            }
        }
        
        
    }
    func floatTheLabel() {
        
        if text == "" && isFirstResponder == true{
            floatPlaceHolder(value: true)
        }else if text == "" && isFirstResponder == false{
            resignPlaceholder()
        }else if text != "" && isFirstResponder == false{
            floatPlaceHolder(value: false)
            
        }else if text != "" && isFirstResponder == true{
            floatPlaceHolder(value: true)
            
        }
        checkForDefaultLabel()
        
    }
    func floatPlaceHolder(value:Bool) {
        if value == true{
            bottomLineView?.backgroundColor = btmLineSelectionColor
            if disableFloatingLabel == true{
                labelPlaceholder?.isHidden = true
                var bottomLineFrame = bottomLineView?.frame
                bottomLineFrame?.origin.y = self.frame.height - 2
                UIView.animate(withDuration: 0.1, animations: {
                    self.bottomLineView?.frame = bottomLineFrame!
                })
                return
            }
            var frame = labelPlaceholder?.frame
            frame?.size.height = 12
            var bottmLineFrame = bottomLineView?.frame
            bottmLineFrame?.origin.y = self.frame.height - 2
            UIView.animate(withDuration: 0.1, animations: {
                self.labelPlaceholder?.frame = frame!
                self.labelPlaceholder?.font = UIFont.systemFont(ofSize: 12)
                self.labelPlaceholder?.textColor = self.selectedPlaceHolderTextColor
                self.bottomLineView?.frame = bottmLineFrame!
            })
        }else{
            bottomLineView?.backgroundColor = btmLineColor
            if disableFloatingLabel == true {
                labelPlaceholder?.isHidden = true
                var bottomLineFrame = bottomLineView?.frame
                bottomLineFrame?.origin.y = self.frame.height - 2
                UIView.animate(withDuration: 0.1, animations: {
                    self.bottomLineView?.frame = bottomLineFrame!
                })
                return
            }
            var frame = labelPlaceholder?.frame
            frame?.size.height = 12
            var bottmLineFrame = bottomLineView?.frame
            bottmLineFrame?.origin.y = self.frame.height - 1
            UIView.animate(withDuration: 0.1, animations: {
                self.labelPlaceholder?.frame = frame!
                self.labelPlaceholder?.font = UIFont.systemFont(ofSize: 12)
                self.labelPlaceholder?.textColor = self.placeHolderTextColor
                self.bottomLineView?.frame = bottmLineFrame!
            })
            
        }
    }
    func resignPlaceholder(){
        bottomLineView?.backgroundColor = btmLineColor;
        if disableFloatingLabel == true {
            labelPlaceholder?.isHidden = false
            labelPlaceholder?.textColor = placeHolderTextColor
            var bottomLineFrame = bottomLineView?.frame
            bottomLineFrame?.origin.y = self.frame.height - 1
            UIView.animate(withDuration: 0.1, animations: {
                self.bottomLineView?.frame = bottomLineFrame!
            })
            return
        }
        let frame = CGRect(x: 5, y: 0, width: self.frame.size.width - 5, height: self.frame.size.height)
        var bottmLineFrame = bottomLineView?.frame
        bottmLineFrame?.origin.y = self.frame.height - 1
        UIView.animate(withDuration: 0.1, animations: {
            self.labelPlaceholder?.frame = frame
            self.labelPlaceholder?.font = self.font
            self.labelPlaceholder?.textColor = self.placeHolderTextColor
            self.bottomLineView?.frame = bottmLineFrame!
        })
        
    }
    func updateTextField(frame:CGRect){
        self.frame = frame
        initialization()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 4, y: 4, width: bounds.size.width, height: bounds.size.height)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 4, y: 4, width: bounds.size.width, height: bounds.size.height)
    }
    func set(_ text:String){
        super.text = text
        if text != "" {
            floatTheLabel()
        }
        checkForDefaultLabel()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        floatTheLabel()

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        floatTheLabel()
        layoutSubviews()
 
    }
    
    func setTextFieldPlaceholderText(pl:String){
        self.labelPlaceholder?.text = pl
        self.textFieldDidEndEditing(self)
    }
    
    func setPlaceholder(pl:String){
        self.labelPlaceholder?.text = pl
        textFieldDidEndEditing(self)
    }
    
}
