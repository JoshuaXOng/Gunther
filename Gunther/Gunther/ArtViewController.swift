//
//  ArtViewController.swift
//  Gunther
//
//  Created by user184453 on 4/16/21.
//

import UIKit

class ArtViewController: UIViewController, UIColorPickerViewControllerDelegate, UIScrollViewDelegate, CanvasViewDelegate {
    
    var databaseController: DatabaseProtocol?
    
    @IBOutlet weak var scrollView: UIScrollView!
    var canvas: CanvasView?
    var art: Art?
    var tool: Tool?
    let colorPickerController = UIColorPickerViewController()
    
    @IBAction func SaveButton(_ sender: UIBarButtonItem) {
        self.save()
    }
    
    @IBAction func ColorPickerButton(_ sender: UIButton) {
        self.present(colorPickerController, animated: true, completion: nil)
    }
    
    @IBAction func DragButton(_ sender: UIButton) {
        scrollView.isScrollEnabled = !(scrollView.isScrollEnabled)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup database
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        databaseController = appDelegate.databaseController
        
        // Setup scrollView and zooming functionality
        scrollView.backgroundColor = UIColor(red: 0.79, green: 0.83, blue: 0.89, alpha: 1)
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 8
        scrollView.zoomScale = 1
        scrollView.isScrollEnabled = false
        scrollView.delegate = self
        
        // Initialize a test canvas view
        canvas = CanvasView(width: 500, height: 300)
        
        // Setup canvas
        guard let canvas = canvas else { return }
        canvas.canvasViewDelegate = self
        scrollView.addSubview(canvas)
        
        // Adjust scrollView and canvas
        scrollView.contentSize = CGSize(width: 500 + 50*4, height: 300 + 30*4)
        let centerOfSVContent = CGPoint(x: scrollView.contentSize.width/2, y: scrollView.contentSize.height/2)
        canvas.center = centerOfSVContent
        scrollView.zoom(to: canvas.bounds, animated: false)
        
        // Give shadow to canvas
        canvas.layer.shadowColor = UIColor.black.cgColor
        canvas.layer.shadowOpacity = 1
        canvas.layer.shadowOffset = .zero
        canvas.layer.shadowRadius = 5
        
        // Setup colorPickerController
        colorPickerController.selectedColor = UIColor.black
        colorPickerController.delegate = self
        
        // Setup test tool
        self.tool = Pencil()
        self.tool!.size = 11
        
        // Setup test art
        //self.art = Art(name: "Test", height: 300, width: 500, pixelSize: 4)
        
        guard let firebaseController = databaseController as? FirebaseController else {
            return
        }
        let rootRef = firebaseController.storage.reference()
        let testRef = rootRef.child("test.png")
        testRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(error)
            } else {
                var image = UIImage(data: data!)
                image = ArtViewController.resizeImage(image: image!, targetSize: CGSize(width: 500, height: 300))
                self.art = Art(name: "", height: 300, width: 500, pixelSize: 4, image: image!)
                
                /*
                DispatchQueue.main.async {
                    let v = self.art!.test
                    self.view.addSubview(v!)
                }*/
                
            }
        }
        //sleep(5)
        
    }
    
    // NOT MY CODE
    
    static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
    // MARK: - Implement CanvasViewDelegate
    
    func onTouchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let canvas = canvas, let point = touches.first?.location(in: canvas), let art = art else {
            return
        }
        
        let x = Int(floor(point.x))
        let y = Int(floor(point.y))
        
        let area = tool?.nibArea(x: x/self.art!.pixelSize, y: y/self.art!.pixelSize)
        for point in area! {
            let x = point[0]*self.art!.pixelSize
            let y = point[1]*self.art!.pixelSize
            let location = art.getLocation(x: x, y: y)
            location.clear()
            let pixel = Pixel(color: colorPickerController.selectedColor.cgColor)
            location.push(pixel: pixel)
        }
        
    }
    
    // MARK: - Implement UIColorPickerViewControllerDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return canvas
    }
    
    // MARK: - Save art to database
    
    func save() {
        
        guard let firebaseController = databaseController as? FirebaseController else {
            return
        }
        let rootRef = firebaseController.storage.reference()
        let testRef = rootRef.child("test.png")
        
        /*guard let canvas = canvas else {
            return
        }
        guard let data = canvas.getPNGData() else { return }*/
        let data = art!.getPNGData()!
        
        let _ = testRef.putData(data, metadata: nil) { (metadata, error) in
            if let error = error {
                print(error)
            }
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
