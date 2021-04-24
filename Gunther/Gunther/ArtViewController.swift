//
//  ArtViewController.swift
//  Gunther
//
//  Created by user184453 on 4/16/21.
//

import UIKit

class ArtViewController: UIViewController, UIColorPickerViewControllerDelegate, UIScrollViewDelegate, CanvasViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    var canvas: CanvasView?
    var art: Art?
    var tool: Tool?
    let colorPickerController = UIColorPickerViewController()
    
    @IBAction func ColorPickerButton(_ sender: UIButton) {
        self.present(colorPickerController, animated: true, completion: nil)
    }
    
    @IBAction func DragButton(_ sender: UIButton) {
        scrollView.isScrollEnabled = !(scrollView.isScrollEnabled)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup scrollView and zooming functionality
        scrollView.backgroundColor = UIColor.lightGray
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 8.0
        scrollView.zoomScale = 1.0
        scrollView.isScrollEnabled = false
        scrollView.delegate = self
        
        canvas = CanvasView(width: 500, height: 300) //a test canvas view
        //setup canvas
        guard let canvas = canvas else { return }
        canvas.canvasViewDelegate = self
        scrollView.addSubview(canvas)
        
        let w = scrollView.bounds.width
        let h = scrollView.bounds.height
        scrollView.contentSize = CGSize(width: w, height: h)
        //scrollView.contentSize = CGSize.init(width: 500+70, height: 300+70)
        
        //setup colorPickerController
        colorPickerController.selectedColor = UIColor.black
        colorPickerController.delegate = self
        
        // Setup test tool
        self.tool = Pencil()
        self.tool!.size = 5
        
        // Setup test art
        self.art = Art(name: "Test", height: 300, width: 500, pixelSize: 48)
        
    }
    
    // MARK: - Implement CanvasViewDelegate
    
    func onTouchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let canvas = canvas, let point = touches.first?.location(in: canvas), let art = art else {
            return
        }
        
        let x = Int(floor(point.x))
        let y = Int(floor(point.y))
        let location = art.getLocation(x: x, y: y)
        location.clear()
        let pixel = Pixel(color: colorPickerController.selectedColor.cgColor)
        location.push(pixel: pixel)
        
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
