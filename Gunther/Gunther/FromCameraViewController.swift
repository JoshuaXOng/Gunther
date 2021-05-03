//
//  FromCameraViewController.swift
//  Gunther
//
//  Created by user184453 on 5/2/21.
//

import UIKit
import AVKit

class FromCameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    var session: AVCaptureSession?
    var device: AVCaptureDevice?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var captureOutput: AVCapturePhotoOutput?
    
    var croppedImage: UIImage?
    var width: Int?
    var height: Int?

    @IBAction func takePhotoButton(_ sender: UIButton) {
        captureOutput?.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize capture session.
        session = AVCaptureSession()
        guard let session = session else { return }
        
        // Configure capture session.
        guard let frontCamera = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        do {
            let captureInput = try AVCaptureDeviceInput(device: frontCamera)
            captureOutput = AVCapturePhotoOutput()
            session.addInput(captureInput)
            session.addOutput(captureOutput!)
        }
        catch {
            print("Well... You don't have a camera... Wait, that's me: \(error.localizedDescription)")
        }
        
        // Setup the preview layer for the capture stream.
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.frame = view.bounds
        previewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        guard let previewLayer = previewLayer else { return }
        view.layer.addSublayer(previewLayer)
        
        session.startRunning()
        
    }
    
    // MARK: - Implement AVCapturePhotoCaptureDelegate.
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        if let error = error {
            print("Photo output failed: \(error)")
            return
        }
        
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data)
        else {
            return
        }
        
        let topLeftOfCrop = CGPoint(x: (Int(image.size.width) - width!)/2, y: (Int(image.size.height) - height!)/2)
        let sizeOfCrop = CGSize(width: width!, height: height!)
        
        let region = CGRect(origin: topLeftOfCrop, size: sizeOfCrop)
        croppedImage = UIImage.cropImage(image: image, region: region)
        
        self.performSegue(withIdentifier: "SavedArtToArtSegue", sender: nil)
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FromPhotoToArtSegue" {
            let destination = segue.destination as? ArtViewController
            destination.is
            
        }
    }

}
