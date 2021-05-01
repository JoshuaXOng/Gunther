//
//  NewArtViewController.swift
//  Gunther
//
//  Created by user184453 on 4/25/21.
//

import UIKit

class NewArtViewController: UIViewController {

    var databaseController: DatabaseProtocol?
    
    @IBOutlet weak var ArtNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get a reference to the applications database controller
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        databaseController = appDelegate.databaseController
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "NewArtBCToArtSegue" {
            
            let savedArt = SavedArt()
            savedArt.id = "ThisIsATestID" // Some test data because UI is not quite ready.
            savedArt.name = "ATestArt"
            savedArt.source = ArtNameField.text!+".png"
            savedArt.width = "300"
            savedArt.height = "300"
            savedArt.pixelSize = "4"
            
            //guard let firebaseController = databaseController as? FirebaseController else { return }
            //let _ = firebaseController.addArtToUser(user: firebaseController.user, art: savedArt)
            
            let destination = segue.destination as? ArtViewController
            destination?.savedArt = savedArt
            
        }
        
    }

}
