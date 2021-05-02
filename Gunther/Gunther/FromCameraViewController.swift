//
//  FromCameraViewController.swift
//  Gunther
//
//  Created by user184453 on 5/2/21.
//

import UIKit

class FromCameraViewController: UIViewController {

    var imagePickerController: UIImagePickerController?
    
    @IBOutlet weak var previewImageView: UIImageView!
    
    @IBAction func takePhotoButton(_ sender: UIButton) {
        guard let imagePickerController = imagePickerController else { return }
        present(imagePickerController, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController = UIImagePickerController()
            imagePickerController?.sourceType = .camera
        }
        else {
            print("Well... I don't have a camera...")
            return
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
