//
//  NewArtViewController.swift
//  Gunther
//
//  Created by user184453 on 4/25/21.
//

import UIKit

class NewArtViewController: UIViewController, UITextFieldDelegate {

    private var databaseController: DatabaseProtocol?
    
    @IBOutlet weak var artNameField: UITextField!
    
    @IBOutlet weak var widthSlider: UISlider!
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var pixelSizeSlider: UISlider!
    @IBOutlet weak var pixelSize: UILabel!
    
    @IBAction func widthSlider(_ sender: UISlider) {
        let roundedWidth = widthSlider.value - widthSlider.value.truncatingRemainder(dividingBy: 5)
        widthLabel.text = String(roundedWidth)
    }
    @IBAction func heightSlider(_ sender: UISlider) {
        let roundedHeight = heightSlider.value - heightSlider.value.truncatingRemainder(dividingBy: 5)
        heightLabel.text = String(roundedHeight)
    }
    @IBAction func pixelSizeSlider(_ sender: UISlider) {
        let roundedPixelSize = pixelSizeSlider.value - pixelSizeSlider.value.truncatingRemainder(dividingBy: 1)
        pixelSize.text = String(roundedPixelSize)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get a reference to the applications database controller
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        databaseController = appDelegate.databaseController
        
        artNameField.delegate = self
        
        widthLabel.text = String(widthSlider.value)
        heightLabel.text = String(heightSlider.value)
        pixelSize.text = String(pixelSizeSlider.value)
        
    }
    
    // MARK: - Functions for resizing width, height and pixel size
    
    private func roundDimensionsForPixelSize(width: Float, height: Float, pixelSize: Float) -> (Float, Float) {
        let roundedWidth = width - width.truncatingRemainder(dividingBy: pixelSize)
        let roundedHeight = height - height.truncatingRemainder(dividingBy: pixelSize)
        return (roundedWidth, roundedHeight)
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
        savedArt.id = UUID().uuidString
        savedArt.name = artNameField.text!
        savedArt.source = UUID().uuidString+".png"
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
