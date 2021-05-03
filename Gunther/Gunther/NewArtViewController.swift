//
//  NewArtViewController.swift
//  Gunther
//
//  Created by user184453 on 4/25/21.
//

import UIKit

class NewArtViewController: UIViewController, UITextFieldDelegate {

    var databaseController: DatabaseProtocol?
    
    @IBOutlet weak var artNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get a reference to the applications database controller
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        databaseController = appDelegate.databaseController
        
        artNameField.delegate = self
        
    }
    
    // MARK: - Implement UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let savedArt = SavedArt()
        savedArt.id = "ThisIsATestID" // Some test data because UI is not quite ready.
        savedArt.name = "ATestArt"
        savedArt.source = artNameField.text!+".png"
        savedArt.width = "300"
        savedArt.height = "300"
        savedArt.pixelSize = "10" //4
        
        if segue.identifier == "NewArtBCToArtSegue" {
            let destination = segue.destination as? ArtViewController
            destination?.savedArt = savedArt
            destination?.isNew = true
        }
        else if segue.identifier == "NewArtToFromPhotoSegue" {
            let destination = segue.destination as? FromCameraViewController
            destination?.savedArt = savedArt
        }
        
    }

}
