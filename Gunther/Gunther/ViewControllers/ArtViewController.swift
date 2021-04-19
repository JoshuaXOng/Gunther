//
//  ArtViewController.swift
//  Gunther
//
//  Created by user184453 on 4/16/21.
//

import UIKit

class ArtViewController: UIViewController, UIColorPickerViewControllerDelegate {

    var canvas: CanvasView?
    let colorPickerController = UIColorPickerViewController()
    
    @IBAction func ColorPickerButton(_ sender: UIButton) {
        self.present(colorPickerController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //setup colorPickerController
        colorPickerController.delegate = self
        
        canvas = CanvasView(width: 240, height: 450) //a test canvas view
        
        guard let canvas = canvas else { return }
        canvas.backgroundColor = .white
        canvas.center = view.center
        view.addSubview(canvas)
        
    }
    
    // MARK: - Implement UIColorPickerViewControllerDelegate
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let chosenColor = viewController.selectedColor
        canvas?.brushColor = chosenColor.cgColor
        print("test")
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
