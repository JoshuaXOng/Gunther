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

    var baseImage: UIImage?
    var isNew = false
    
    @IBOutlet weak var scrollView: UIScrollView!
    var canvas: CanvasView?
    var artManager: ArtManager?
    var art: Art?
    var tool: Tool?
    var toolPickerController = ToolPickerViewController()
    let colorPickerController = UIColorPickerViewController()
    var isDrawing = true
    
    @IBAction func SaveButton(_ sender: UIBarButtonItem) {
        self.updateSavedArt()
    }
    
    @IBAction func decreaseToolSizeButton(_ sender: UIButton) {
        /*let minToolSize = 1
        if (tool?.size)! >= minToolSize+1 {
            tool?.size! -= 1
        }*/
        art = artManager?.undo()
        self.canvas?.setNeedsDisplay()
    }
    
    @IBAction func increaseToolSizeButton(_ sender: UIButton) {
        //tool?.size! += 1
        art = artManager?.redo()
        self.canvas?.setNeedsDisplay()
    }
    
    @IBAction func ColorPickerButton(_ sender: UIButton) {
        self.present(colorPickerController, animated: true, completion: nil)
    }
    
    @IBAction func brushButton(_ sender: UIButton) {
        self.present(toolPickerController, animated: true, completion: nil)
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
        
        // Setup canvas view, art and graphics context.
        if isNew {
            
            guard let name = savedArt?.name,
                  let width = savedArt?.width, let height = savedArt?.height,
                  let pixelSize = savedArt?.pixelSize else {
                return
            }
            //setupCanvasView(width: CGFloat(Float(width)!), height: CGFloat(Float(height)!))
            
            if let baseImage = baseImage {
                art = Art(name: name, height: Int(height)!, width: Int(width)!, pixelSize: Int(pixelSize)!, image: baseImage)
            }
            else {
                art = Art(name: name, height: Int(height)!, width: Int(width)!, pixelSize: Int(pixelSize)!)
            }
            onArtAssigned()
        }
        else {
            assignArtFromSource() {
                self.onArtAssigned()
            }
        }
        
        // Setup colorPickerController
        colorPickerController.selectedColor = UIColor.black
        colorPickerController.delegate = self
        
        // Initialize a test tool
        tool = Pencil()
        tool!.size = toolPickerController.selectedToolSizeIndex+1//5 // 1,3,5,7,9,11
        
        // Setup toolPickerViewController.
        toolPickerController.toolPickerDelegate = self
        
    }
    
    // MARK: - Utils for canvas view setup
    
    private func setupCanvasView(width: CGFloat, height: CGFloat) {
                    
        self.canvas = CanvasView(width: width, height: height)
        guard let canvas = self.canvas else {
            return
        }
        canvas.canvasViewDelegate = self
        
        self.scrollView.addSubview(canvas)
        self.scrollView.contentSize = CGSize(width: width, height: height)
        //let centerOfSVContent = CGPoint(x: self.scrollView.contentSize.width/2, y: self.scrollView.contentSize.height/2) // This does not compute the center.
        //canvas.center = centerOfSVContent // Comment out!!!
        //self.scrollView.zoom(to: canvas.bounds, animated: false)
        //self.scrollView.contentOffset = centerOfSVContent
        let edges = UIEdgeInsets(top: 1*height, left: 0.5*width, bottom: 1*height, right: 0.5*width)
        scrollView.contentInset = edges
        scrollView.zoom(to: canvas.bounds, animated: false)
                    
        // Give shadow to canvas
        canvas.layer.shadowColor = UIColor.black.cgColor
        canvas.layer.shadowOpacity = 0.5
        canvas.layer.shadowOffset = .zero
        canvas.layer.shadowRadius = 2

        self.canvas?.setNeedsDisplay()
        
    }
    
    private func assignArtFromSource(completionHandler: @escaping () -> Void) {
        
        guard let firebaseController = databaseController as? FirebaseController,
              let savedArt = self.savedArt else {
            return
        }
        
        _ = firebaseController.fetchArtImageFromArt(art: savedArt) { image in
            
            guard let name = savedArt.name,
                  let width = savedArt.width,
                  let height = savedArt.height,
                  let pixelSize = savedArt.pixelSize else {
                return
            }
            
            self.art = Art(name: name, height: Int(height)!, width: Int(width)!, pixelSize: Int(pixelSize)!, image: image!)
            
            completionHandler()
            
        }
        
    }
    
    private func onArtAssigned() {
        
        setupCanvasView(width: CGFloat(art!.width), height: CGFloat(art!.height))
        artManager = ArtManager(art: art!)
        
    }
    
    // MARK: - CanvasViewDelegate
    
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
    
    func onTouchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isDrawing {
            return
        }
        artManager?.update(updatedArt: art!)
    }
    
    // MARK: - UIColorPickerViewControllerDelegate
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        //let centerOfSVContent = CGPoint(x: scrollView.contentSize.width/2, y: scrollView.contentSize.height/2)
        //canvas?.center = centerOfSVContent
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        //var size = CGSize()
        //size.width = CGFloat(art!.width)
        //size.height = CGFloat(art!.height)
        //scrollView.contentSize = size
        //print(scrollView.contentSize)
        return canvas
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        //let centerOfSVContent = CGPoint(x: scrollView.contentSize.width/2, y: scrollView.contentSize.height/2)
        //canvas?.center = centerOfSVContent
    }
    
    // MARK: - Database functions
    
    func updateSavedArt() {
        
        guard let firebaseController = databaseController as? FirebaseController,
              let savedArt = savedArt,
              let savedArtSource = savedArt.source else {
            return
        }
        
        let _ = firebaseController.addArtToUser(user: firebaseController.user, art: savedArt)
        
        firebaseController.putDataAtStorageRef(source: "UserArt/"+savedArtSource, data: (art?.getPNGData())!) {}
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*if segue.identifier == "ArtToToolsSegue" {
            let destination = segue.destination as? ToolPickerViewController
            toolPickerController = destination
            print(toolPickerController?.selectedToolTypeIndex)
            toolPickerController?.selectedToolSizeIndex = 1
        }*/
    }

}

extension ArtViewController: ToolPickerDelegate {
    
    func onBrushSelection(brushNO: Int) {
        
    }
    
    func onSizeSelection(sizeNO: Int) {
        tool?.size = sizeNO+1
    }
    
}
