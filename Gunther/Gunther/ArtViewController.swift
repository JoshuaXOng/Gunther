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
        scrollView.backgroundColor = UIColor(red: 0.79, green: 0.83, blue: 0.89, alpha: 1)
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 8
        scrollView.zoomScale = 1
        scrollView.isScrollEnabled = false
        scrollView.delegate = self
        
        canvas = CanvasView(width: 500, height: 300) //a test canvas view
        //setup canvas
        guard let canvas = canvas else { return }
        canvas.canvasViewDelegate = self
        scrollView.addSubview(canvas)
    
        scrollView.contentSize = CGSize(width: 500 + 50*4, height: 300 + 30*4)
        
        let w = scrollView.contentSize.width
        let h = scrollView.contentSize.height
        let point = CGPoint(x: w/2, y: h/2)
        canvas.center = point
        scrollView.zoom(to: canvas.bounds, animated: false)
        
        canvas.layer.shadowColor = UIColor.black.cgColor
        canvas.layer.shadowOpacity = 1
        canvas.layer.shadowOffset = .zero
        canvas.layer.shadowRadius = 5
        
        //setup colorPickerController
        colorPickerController.selectedColor = UIColor.black
        colorPickerController.delegate = self
        
        // Setup test tool
        self.tool = Pencil()
        self.tool!.size = 5
        
        // Setup test art
        self.art = Art(name: "Test", height: 300, width: 500, pixelSize: 4)
        
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
