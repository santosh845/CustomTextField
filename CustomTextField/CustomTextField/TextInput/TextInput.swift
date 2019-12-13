//
//  TextInput.swift
//  TextFieldDemo
//
//  Created by Santosh Maurya on 11/29/19.
//  Copyright © 2019 Santosh Maurya. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
 

protocol TextInputDelegate {
    
     func textShouldReturn(textInput: TextInput)
     func textInputDidBeginEditing(textInput: TextInput)
     func textInputDidEndEditing(textInput: TextInput)
     func textInputDidChange(textInput: TextInput, text: String)
}

class TextInput: UIView {
    
    public var rightBtn: UIButton!
    @IBOutlet weak var txtFld: SkyFloatingLabelTextField!
    public var delegate : TextInputDelegate?

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        
        guard let nib = Bundle.main.loadNibNamed("TextInput", owner: self, options: nil)?.first as? UIView else {
            fatalError("Couldn't find the xib for TextInputView")
        }
        
        addSubview(nib)
        nib.frame = bounds
        nib.autoresizingMask = [.flexibleWidth, .flexibleHeight ]
        configTextField()
        
    }
    
    var text:String? {
        return txtFld.text
    }
    
    public func configTextField(){
        
        txtFld.delegate = self
        
        //txtFld.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    func addRightImageOnTextField(textField:UITextField) {
        
        if rightImage != nil{
            rightBtn = UIButton(type: .custom)
            let origImage = rightImage
            let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
            rightBtn.setImage(tintedImage, for: .normal)
            rightBtn.tintColor = .lightGray
            rightBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
            rightBtn.frame = CGRect(x: CGFloat(textField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
            if(textField == txtFld){
               // button.addTarget(self, action: #selector(self.newPasswordRefresh), for: .touchUpInside)
            }
            textField.rightView = rightBtn
            textField.rightViewMode = .always
        }
        
    }
    
    
    
    // This will notify us when something has changed on the textfield
    //@objc func textFieldDidChange(_ textfield: UITextField) {
    public func textFieldEmailValidation(_ textfield: TextInput) {
        
            if let text = textfield.text {
                if let floatingLabelTextField = txtFld {
                    if(text.count < 3 || !text.contains("@")) {
                        floatingLabelTextField.errorMessage = errorMessage
                        rightBtn.tintColor = .red
                       
                    }
                    else {
                        // The error message will only disappear when we reset it to nil or empty string
                        floatingLabelTextField.errorMessage = ""
                        rightBtn.tintColor = .lightGray
                        
                    }
                }
            }
    }
    
    public func textFieldPasswordValidation(_ textfield: TextInput) {
        
            if let text = textfield.text {
                if let floatingLabelTextField = txtFld {
                    if(text.count < 3 || text.count > 8) {
                        floatingLabelTextField.errorMessage = errorMessage
                    }
                    else {
                        // The error message will only disappear when we reset it to nil or empty string
                        floatingLabelTextField.errorMessage = ""
                    }
                }
            }
    }
    
    private func animateShadow() {
        center = self.center
        backgroundColor = UIColor.white
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 5
        
    }
    
    private func removeShadow() {
        center = self.center
        backgroundColor = UIColor.white
        layer.shadowColor = UIColor.clear.cgColor
        layer.shadowOpacity = 0.0
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 0.0
        
    }
    
    @IBInspectable public var isProtected: Bool = false {
        didSet{
                txtFld.isSecureTextEntry = isProtected
            if (isProtected) {
                txtFld.keyboardType = .default
            }
        }
    }
    @IBInspectable public var rightImage: UIImage? {
        didSet{
           self.addRightImageOnTextField(textField: self.txtFld)
        }
    }
      
    
    @IBInspectable public var isEmailType:Bool = false{
        didSet{
            if isEmailType {
                txtFld.keyboardType = .emailAddress
            }
        }
    }
    
    @IBInspectable public var placeHolderText: String?{
        didSet{
            if  (placeHolderText != nil){
                txtFld.placeholder = placeHolderText
            }
            
        }
    }
    
    @IBInspectable public var errorMessage: String?
        
    
    @IBInspectable public var selectedTitle: String?{
        didSet{
            if selectedTitle != nil {
                txtFld.selectedTitle = selectedTitle
            }
            
        }
    }
    
    @IBInspectable public var selectedLineColor: UIColor?{
        didSet{
            if selectedLineColor != nil {
                txtFld.selectedLineColor = selectedLineColor ?? .black
                
              }
          }
    }
    
    @IBInspectable public var placeholderColor: UIColor?{
        didSet{
            if placeholderColor != nil {
                txtFld.placeholderColor = placeholderColor ?? .lightGray
              }
          }
    }
    
    @IBInspectable public var errorColor: UIColor?{
        didSet{
            if errorColor != nil {
                txtFld.errorColor = errorColor ?? .red
              }
          }
    }
    
}

extension TextInput:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.textShouldReturn(textInput: self)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateShadow()
        delegate?.textInputDidBeginEditing(textInput: self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        removeShadow()
        delegate?.textInputDidEndEditing(textInput: self)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        delegate?.textInputDidChange(textInput: self, text: string)
        return true
    }
    
}
