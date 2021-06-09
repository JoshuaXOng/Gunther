//
//  NewArtViewController.swift
//  Gunther
//
//  Created by user184453 on 4/25/21.
//

import UIKit

/* A view controller for the corrseponding new art screen. */
class NewArtViewController: UIViewController, UITextFieldDelegate {

    private var databaseController: DatabaseProtocol?
    
    // Name of Art field.
    @IBOutlet weak var artNameField: UITextField!
    
    // Sliders and corresponding numbers.
    @IBOutlet weak var widthSlider: UISlider!
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var pixelSizeSlider: UISlider!
    @IBOutlet weak var pixelSize: UILabel!
    
    // Start from buttons.
    @IBOutlet weak var fromCameraButton: UIButton!
    @IBOutlet weak var fromBlankCanvasButton: UIButton!
    let START_FROM_CAMERA = "startFromCamera"
    let START_FROM_BLANK_CANVAS = "startFromBlankCanvas"
    var startFromChoice: String?
    
    // MARK: - Sliders
    
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
    
    // MARK: - Buttons
    
    @IBAction func fromCameraButton(_ sender: UIButton) {
        updateButtonsRadiolike(buttons: [fromCameraButton, fromBlankCanvasButton], choice: fromCameraButton)
        startFromChoice = START_FROM_CAMERA
    }
    
    @IBAction func fromBlankCanvasButton(_ sender: UIButton) {
        updateButtonsRadiolike(buttons: [fromCameraButton, fromBlankCanvasButton], choice: fromBlankCanvasButton)
        startFromChoice = START_FROM_BLANK_CANVAS
    }
    
    @IBAction func startBarButton(_ sender: UIBarButtonItem) {
        let isInputValid = validateInput()
        if isInputValid {
            switch startFromChoice {
                case START_FROM_CAMERA:
                    performSegue(withIdentifier: "NewArtToFromPhotoSegue", sender: nil)
                case START_FROM_BLANK_CANVAS:
                    performSegue(withIdentifier: "NewArtBCToArtSegue", sender: nil)
                default:
                    print("Something ain't right sir.")
            }
            resetInputs()
        }
        else {
            displayMessage(title: "Invalid Input", message: "Please enter a valid name and a 'Start From' choice.")
        }
    }
    
    // MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get a reference to the applications database controller
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        databaseController = appDelegate.databaseController
        
        artNameField.delegate = self
        
        setupSliders()
        
        setupStartFromButton(button: fromCameraButton)
        setupStartFromButton(button: fromBlankCanvasButton)
        
    }
    
    // MARK: - Views setup
    
    private func setupSliders() {
        
        widthSlider.minimumTrackTintColor = UIColor(red: 0.79, green: 0.83, blue: 0.89, alpha: 1)
        widthSlider.thumbTintColor = UIColor(red: 0.48, green: 0.72, blue: 0.51, alpha: 1)
        
        heightSlider.minimumTrackTintColor = UIColor(red: 0.79, green: 0.83, blue: 0.89, alpha: 1)
        heightSlider.thumbTintColor = UIColor(red: 0.48, green: 0.72, blue: 0.51, alpha: 1)
        
        pixelSizeSlider.minimumTrackTintColor = UIColor(red: 0.79, green: 0.83, blue: 0.89, alpha: 1)
        pixelSizeSlider.thumbTintColor = UIColor(red: 0.48, green: 0.72, blue: 0.51, alpha: 1)
        
        widthLabel.text = String(Int(widthSlider.value))
        heightLabel.text = String(Int(heightSlider.value))
        pixelSize.text = String(Int(pixelSizeSlider.value))
    
    }
    
    private func setupStartFromButton(button: UIButton) {
        
        button.layer.cornerRadius = 2.5
        button.backgroundColor = UIColor(red: 0.48, green: 0.72, blue: 0.51, alpha: 1)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0.5, height: 1)
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 0.5
        
    }
    
    // MARK: - UIButtons radio-behaviour
    
    private func applyToggleAppearance(button: UIButton) {
        button.layer.shadowColor = UIColor.black.cgColor
        button.backgroundColor = UIColor(red: 0.38, green: 0.56, blue: 0.40, alpha: 1)
        button.layer.shadowOffset = CGSize(width: 0.5, height: 1)
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 1
    }
    
    private func applyUntoggleAppearance(button: UIButton) {
        setupStartFromButton(button: button)
    }
    
    private func updateButtonsRadiolike(buttons: [UIButton], choice: UIButton) {
        for button in buttons {
            applyUntoggleAppearance(button: button)
        }
        applyToggleAppearance(button: choice)
    }
    
    // MARK: - Validate form input
    
    private func validateInput() -> Bool {
        let isArtNameValid = !(artNameField.text?.trimmingCharacters(in: .whitespaces) == "")
        let isStartFromChoiceValid = startFromChoice
        if isArtNameValid && isStartFromChoiceValid != nil {
            return true
        }
        return false
    }
    
    // MARK: - Resize width, height and pixel size
    
    private func roundDimensionsForPixelSize(width: Float, height: Float, pixelSize: Float) -> (Float, Float) {
        let roundedWidth = width - width.truncatingRemainder(dividingBy: pixelSize)
        let roundedHeight = height - height.truncatingRemainder(dividingBy: pixelSize)
        return (roundedWidth, roundedHeight)
    }
    
    // MARK: - Clear inputs
    
    private func resetInputs() {
        self.artNameField.text = ""
        let buttons = [fromCameraButton, fromBlankCanvasButton]
        for button in buttons {
            applyUntoggleAppearance(button: button!)
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let name = artNameField.text!
        let (width, height) = roundDimensionsForPixelSize(width: Float(Int(widthSlider.value)), height: Float(Int(heightSlider.value)), pixelSize: Float(pixelSize.text!)!)
        
        let savedArt = SavedArt(name: name, width: String(Int(width)), height: String(Int(height)), pixelSize: pixelSize.text!)
        
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
