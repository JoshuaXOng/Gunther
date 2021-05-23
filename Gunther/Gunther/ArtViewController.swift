//
//  ArtViewController.swift
//  Gunther
//
//  Created by user184453 on 4/16/21.
//

import UIKit

class ArtViewController: UIViewController, UIColorPickerViewControllerDelegate, UIScrollViewDelegate, CanvasViewDelegate, ToolPickerDelegate {
    
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
    let TOOL_INDEX_SIZE_OFFSET = 1
    let colorPickerController = UIColorPickerViewController()
    var isDrawing = true
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        updateSavedArt()
    }
    
    @IBAction func undoButton(_ sender: UIButton) {
        art = artManager?.undo()
        canvas?.setNeedsDisplay()
    }
    
    @IBAction func redoButton(_ sender: UIButton) {
        art = artManager?.redo()
        canvas?.setNeedsDisplay()
    }
    
    @IBAction func colorPickerButton(_ sender: UIButton) {
        present(colorPickerController, animated: true, completion: nil)
    }
    
    @IBAction func brushButton(_ sender: UIButton) {
        self.present(toolPickerController, animated: true, completion: nil)
    }

    @IBAction func dragButton(_ sender: UIButton) {
        scrollView.isScrollEnabled = !(scrollView.isScrollEnabled)
        isDrawing = !isDrawing
        if isDrawing {
            sender.tintColor = UIColor(red: 0.48, green: 0.72, blue: 0.51, alpha: 1)
        }
        else {
            sender.tintColor = UIColor(red: 0.15, green: 0.25, blue: 0.18, alpha: 1)
        }
    }
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup database
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        databaseController = appDelegate.databaseController
        
        setupScrollView()
        
        // Setup canvas view, art and graphics context.
        // Depending on the way the user enters ArtViewController, different variables can be nil.
        // Moreover, depending on where the user came from, art may have to be assiged asyncronously instead of syncronously.
        if isNew {
            
            guard let name = savedArt?.name,
                  let width = savedArt?.width, let height = savedArt?.height,
                  let pixelSize = savedArt?.pixelSize else {
                return
            }
            
            // User comes from 'start from camera'
            if let baseImage = baseImage {
                art = Art(name: name, height: Int(height)!, width: Int(width)!, pixelSize: Int(pixelSize)!, image: baseImage)
            }
            // User comes from 'start from blank canvas'
            else {
                art = Art(name: name, height: Int(height)!, width: Int(width)!, pixelSize: Int(pixelSize)!)
            }
            onArtAssigned()
            
        }
        else {
            // User comes from 'edit saved art'
            assignArtFromSource() { [self] in
                onArtAssigned()
            }
        }
        
        // Setup colorPickerController.
        colorPickerController.selectedColor = UIColor.black
        colorPickerController.delegate = self
        
        // Setup toolPickerViewController.
        toolPickerController.toolPickerDelegate = self
        
        // Initialize tool.
        tool = Pencil()
        tool!.size = toolPickerController.selectedToolSizeIndex + TOOL_INDEX_SIZE_OFFSET
        
    }
    
    // MARK: - Setup scroll view
    
    private func setupScrollView() {
        scrollView.backgroundColor = UIColor(red: 0.79, green: 0.83, blue: 0.89, alpha: 1)
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 8
        scrollView.zoomScale = 1
        scrollView.isScrollEnabled = false
        scrollView.delegate = self
    }
    
    // MARK: - Canvas and art setup utils
    
    private func setupCanvasView(width: CGFloat, height: CGFloat) {
                    
        self.canvas = CanvasView(width: width, height: height)
        guard let canvas = self.canvas else {
            return
        }
        canvas.canvasViewDelegate = self
        
        // Update scroll view.
        self.scrollView.addSubview(canvas)
        self.scrollView.contentSize = CGSize(width: width, height: height)
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
        
        do {
            try firebaseController.fetchArtImageFromArt(art: savedArt) { image in
                
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
        catch {
            print("Fetching art image, but (re)source is invalid.")
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
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return canvas
    }
    
    // MARK: - ToolPickerDelegate
    
    func onBrushSelection(brushNO: Int) {}
    
    func onSizeSelection(sizeNO: Int) {
        tool?.size = sizeNO + TOOL_INDEX_SIZE_OFFSET
    }
    
    // MARK: - Database functions
    
    func updateSavedArt() {
        
        guard let firebaseController = databaseController as? FirebaseController,
              let savedArt = savedArt,
              let source = savedArt.source else {
            return
        }
        
        firebaseController.putDataAtStorageRef(resource: firebaseController.USER_DIR+source, data: (art?.getPNGData())!) { error in
            let _ = firebaseController.addArtToUser(user: firebaseController.user, art: savedArt)
        }
        
    }
    
    // MARK: - Navigation
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    */

}


