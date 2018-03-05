//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Rohan Bardekar on 01/08/17.
//  Copyright © 2017 Onbinge. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!

    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    
    var memes: [Meme]!
    
    // MARK: Text Properties
    let memeTextAttributes:[String:Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -3.6]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Enable or Disable Camera Button
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
       
        topTextField.delegate = self
        bottomTextField.delegate = self
        shareButton.isEnabled = false
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setTextField(textField: topTextField)
        setTextField(textField: bottomTextField)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    // MARK: Hiding Keyboard
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Text Field Default Attributes
    func setTextField(textField: UITextField) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment  = .center
    }
    
    // MARK: Refactored Image Source Selection
    func pickImageFrom(_ source: UIImagePickerControllerSourceType) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    // MARK: Selected Image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let imageSelected = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imagePickerView.image = imageSelected
            shareButton.isEnabled = true
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Pick Image From Album
    @IBAction func pickImageFromAlbum(_ sender: UIBarButtonItem) {
        
        pickImageFrom(.photoLibrary)
    }
    
    // MARK: Pick Image From Camera
    @IBAction func pickImageFromCamera(_ sender: UIBarButtonItem) {
        
        pickImageFrom(.camera)
    }
    
    // MARK: Cancel Image Selection
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.dismiss(animated: true, completion: nil)
        if imagePickerView.image == nil {
            shareButton.isEnabled = false
        }
    }
    
    // MARK: Clear Image And Text
    @IBAction func clearImageAndText(){
        imagePickerView.image = nil
        shareButton.isEnabled = false
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        dismiss(animated:true, completion:nil)
    }
    
    // MARK: Subscribe Keyboard Notifications
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    // MARK: Unsubscribe Keyboard Notifications
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    // MARK: Show Keyboard
    @objc func keyboardWillShow(_ notification: Notification) {
        
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
    }
    
    // MARK: Hide Keyboard
    @objc func keyboardWillHide(_ notification:Notification) {
        
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
 
    
    // MARK: Keyboard Height
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func save() {
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
       
        // Save meme to "memes" array
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
    }
    
    // MARK: Share Image
    @IBAction func shareImage(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityView = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityView.completionWithItemsHandler = {activity, completed, items, error in
            if completed {
                self.save()
                self.dismiss(animated: false, completion: nil)
            }
        }
        self.present(activityView, animated: true, completion: nil)

    }
    
    // MARK: Generating Meme
    func generateMemedImage() -> UIImage {
        
        navigationBar.isHidden = true
        toolBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        navigationBar.isHidden = false
        toolBar.isHidden = false
        
        return memedImage
    }
    

}

