//
//  MealViewController.swift
//  DemoAppBeenLoveMemoryLite
//
//  Created by dohien on 05/09/2018.
//  Copyright © 2018 dohien. All rights reserved.
//
import UIKit
import os.log

class MealViewController: UIViewController , UITextFieldDelegate ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    var meal: Meal?

    //@IBOutlet weak var centerName: NSLayoutConstraint!
    
    //@IBOutlet weak var saveButton: UIBarButtonItem!

    @IBOutlet weak var contentView: UITextView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    //@IBAction func cancel(_ sender: UIBarButtonItem) {
          //navigationController?.dismiss(animated: false, completion: nil)
    //}
    @IBOutlet weak var ratingControl: RatingController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //contentView.delegate = self
        if let  meal = meal {
            navigationItem.title = meal.header
            contentView.text = meal.header
            //contentTextField.text = meal.detail
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
        updateSaveButtonState()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //centerName.constant -= view.bounds.width
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            //self.centerName.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    func  textFieldDidBeginEditing(_ textField: UITextField) {
        //saveButton.isEnabled = false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        contentView.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: false , completion:  nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: false, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }

        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage

        // Dismiss the picker.
        dismiss(animated: false, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // cấu hình bộ điều khiển chế độ xem đích khi nhấn nút lưu
//        guard let button = sender as? UIBarButtonItem, button == saveButton else {
//            os_log("The save button was not pressed, cancelling", log: OSLog.default,type: .debug)
//            return
//        }
        let header = contentView.text ?? ""
        let detail = ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        
        meal = Meal(header: header, detail: detail, photo: photo, rating: rating)
    }
    private func updateSaveButtonState(){
        let text = contentView.text ?? ""
        //saveButton.isEnabled = !text.isEmpty
    }
}
