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
    
    @IBOutlet weak var fromCameraButton: UIButton!
    @IBOutlet weak var fromBlankCanvasButton: UIButton!
    let buttons = [fromCameraButton, fromBlankCanvasButton]
    
    @IBAction func widthSlider(_ sender: UISlider) {
        let roundedWidth = widthSlider.value - widthSlider.value.truncatingRemainder(dividingBy: 5)
        widthLabel.text = String(Int(roundedWidth))
    }
    @IBAction func heightSlider(_ sender: UISlider) {
        let roundedHeight = heightSlider.value - heightSlider.value.truncatingRemainder(dividingBy: 5)
        heightLabel.text = String(Int(roundedHeight))
    }
    @IBAction func pixelSizeSlider(_ sender: UISlider) {
        let roundedPixelSize = pixelSizeSlider.value - pixelSizeSlider.value.truncatingRemainder(dividingBy: 1)
        pixelSize.text = String(Int(roundedPixelSize))
    }
    
    @IBAction func fromCameraButton(_ sender: UIButton) {
        updateButtonsRadiolike(buttons: buttons, choice: sender)
    }
    
    @IBAction func fromBlankCanvasButton(_ sender: UIButton) {
        updateButtonsRadiolike(buttons: buttons, choice: sender)
    }
    
    @IBAction func startBarButton(_ sender: UIBarButtonItem) {
        let isInputValid = !(artNameField.text?.trimmingCharacters(in: .whitespaces) == "")
        if isInputValid {
            performSegue(withIdentifier: "NewArtBCToArtSegue", sender: nil)
        }
        else {
            displayMessage(title: "Invalid Input", message: "Please enter a valid name.")
        }
        resetInputs()
    }
    
    // MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get a reference to the applications database controller
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        databaseController = appDelegate.databaseController
        
        artNameField.delegate = self
        
        widthLabel.text = String(Int(widthSlider.value))
        heightLabel.text = String(Int(heightSlider.value))
        pixelSize.text = String(Int(pixelSizeSlider.value))
        
    }
    
    // MARK: - Util for adding radio button like behaviour to a group of UIButtons
    
    private func updateButtonsRadiolike(buttons: [UIButton], choice: UIButton) {
        
    }
    
    // MARK: - Util for clearing inputs upon view transition
    
    private func resetInputs() {
        self.artNameField.text = ""
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
