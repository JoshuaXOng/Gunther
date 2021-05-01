//
//  ArtViewController.swift
//  Gunther
//
//  Created by user184453 on 4/16/21.
//

import UIKit

class ArtViewController: UIViewController, UIColorPickerViewControllerDelegate, UIScrollViewDelegate, CanvasViewDelegate {
    
    var databaseController: DatabaseProtocol?
    var savedArt: SavedArt?
    
    @IBOutlet weak var scrollView: UIScrollView!
    var canvas: CanvasView?
    var art: Art?
    var tool: Tool?
    let colorPickerController = UIColorPickerViewController()
    var isDrawing = true
    
    @IBAction func SaveButton(_ sender: UIBarButtonItem) {
        self.updateSavedArt()
    }
    
    @IBAction func ColorPickerButton(_ sender: UIButton) {
        self.present(colorPickerController, animated: true, completion: nil)
    }
    
    @IBAction func DragButton(_ sender: UIButton) {
        scrollView.isScrollEnabled = !(scrollView.isScrollEnabled)
        isDrawing = !isDrawing
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup database
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        databaseController = appDelegate.databaseController
        
        // Setup scrollView and zooming functionality
        scrollView.backgroundColor = UIColor(red: 0.79, green: 0.83, blue: 0.89, alpha: 1)
        scrollView.minimumZoomScale = 1; scrollView.maximumZoomScale = 8
        scrollView.zoomScale = 1
        scrollView.isScrollEnabled = false
        scrollView.delegate = self
        
        /*
        // Setup a test saved art object.
        savedArt = SavedArt()
        savedArt?.id = "ThisIsATestID"
        savedArt?.name = "ATestArt"
        savedArt?.source = "GuntherPixi.png"
        savedArt?.width = "300" // Have to be a multiple of pixelSize.
        savedArt?.height = "300"
        savedArt?.pixelSize = "4" // Going lower vastly increases the amount of location/pixel classes instantiated.
        */
        
        insertSavedArtSource()
        
        // Setup colorPickerController
        colorPickerController.selectedColor = UIColor.black
        colorPickerController.delegate = self
        
        // Initialize a test tool
        tool = Pencil()
        tool!.size = 5 // 1,3,5,7,9,11
        
    }
    
    // MARK: - Setup canvas view with saved artwork.
    
    private func setupCanvasView(width: CGFloat, height: CGFloat) {
                    
        self.canvas = CanvasView(width: width, height: height)
        guard let canvas = self.canvas else {
            return
        }
        canvas.canvasViewDelegate = self
        
        self.scrollView.addSubview(canvas)
        self.scrollView.contentSize = CGSize(width: 1.4*width, height: 1.4*height)
        let centerOfSVContent = CGPoint(x: self.scrollView.contentSize.width/2, y: self.scrollView.contentSize.height/2)
        canvas.center = centerOfSVContent
        //self.scrollView.zoom(to: canvas.bounds, animated: false)
                    
        // Give shadow to canvas
        canvas.layer.shadowColor = UIColor.black.cgColor
        canvas.layer.shadowOpacity = 0.5
        canvas.layer.shadowOffset = .zero
        canvas.layer.shadowRadius = 2

        self.canvas?.setNeedsDisplay()
        
    }
    
    private func insertSavedArtSource() {
        
        guard let firebaseController = databaseController as? FirebaseController,
              let savedArt = self.savedArt,
              let savedArtSource = savedArt.source else {
            return
        }
        
        let savedArtRef = firebaseController.storage.reference(withPath: savedArtSource)
        savedArtRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            
            if let error = error {
                print(error)
            }
            
            else {
                
                guard let name = savedArt.name,
                      let width = savedArt.width,
                      let height = savedArt.height,
                      let pixelSize = savedArt.pixelSize else {
                    return
                }
                
                var imageOfSavedArt = UIImage(data: data!)
                imageOfSavedArt = UIImage.resizeImage(image: imageOfSavedArt!, targetSize: CGSize(width: Int(width)!, height: Int(height)!))
                
                self.art = Art(name: name, height: Int(height)!, width: Int(width)!, pixelSize: Int(pixelSize)!, image: imageOfSavedArt!)
                                
                DispatchQueue.main.async {
                    self.setupCanvasView(width: CGFloat(Int(width)!), height: CGFloat(Int(height)!))
                }
                
            }
            
        }
        
    }
    
    // MARK: - Implement CanvasViewDelegate
    
    func onTouchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !isDrawing {
            return
        }
        
        guard let canvas = canvas, let point = touches.first?.location(in: canvas), let art = art else {
            return
        }
        
        let x = Int(floor(point.x))
        let y = Int(floor(point.y))
        
        let area = tool?.nibArea(x: x/self.art!.pixelSize, y: y/self.art!.pixelSize)
        for point in area! {
            let x = point[0]*self.art!.pixelSize
            let y = point[1]*self.art!.pixelSize
            do {
                let location = try art.getLocation(x: x, y: y)
                location.clear()
                let pixel = Pixel(color: colorPickerController.selectedColor.cgColor)
                location.push(pixel: pixel)
            }
            catch { continue }
        }
        
    }
    
    // MARK: - Implement UIColorPickerViewControllerDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return canvas
    }
    
    // MARK: - Save art to database
    
    func updateSavedArt() {
        
        guard let firebaseController = databaseController as? FirebaseController,
              let savedArt = self.savedArt,
              let savedArtSource = savedArt.source else {
            return
        }
        
        let data = art!.getPNGData()!
        
        let savedArtRef = firebaseController.storage.reference(withPath: savedArtSource)
        let _ = savedArtRef.putData(data, metadata: nil) { (metadata, error) in
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
