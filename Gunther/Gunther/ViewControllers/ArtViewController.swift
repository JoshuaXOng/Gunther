//
//  ArtViewController.swift
//  Gunther
//
//  Created by user184453 on 4/16/21.
//

import UIKit

class ArtViewController: UIViewController {

    var canvas: CanvasView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        canvas = CanvasView(width: 240, height: 450)
        guard let canvas = canvas else { return }
        canvas.backgroundColor = .white
        canvas.center = view.center
        view.addSubview(canvas)
    
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
