//
//  ArtViewController.swift
//  Gunther
//
//  Created by user184453 on 4/16/21.
//

import UIKit

class ArtViewController: UIViewController, UIColorPickerViewControllerDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    var canvas: CanvasView?
    let colorPickerController = UIColorPickerViewController()
    
    @IBAction func ColorPickerButton(_ sender: UIButton) {
        self.present(colorPickerController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup scrollView and zooming functionality
        scrollView.backgroundColor = UIColor.lightGray
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 4.0
        scrollView.zoomScale = 1.0
        scrollView.isScrollEnabled = false
        scrollView.delegate = self
        
        canvas = CanvasView(width: 500, height: 300) //a test canvas view
        //setup canvas
        guard let canvas = canvas else { return }
        scrollView?.addSubview(canvas)
        //scrollView?.zoom(to: , animated: false)
        
        //setup colorPickerController
        colorPickerController.selectedColor = UIColor.black
        canvas.brushColor = UIColor.black.cgColor
        colorPickerController.delegate = self
        
    }
    
    // MARK: - Implement UIColorPickerViewControllerDelegate
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let chosenColor = viewController.selectedColor
        canvas?.brushColor = chosenColor.cgColor
    }
    
    // MARK: - Implement UIColorPickerViewControllerDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return canvas
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
