//
//  Pencil.swift
//  Gunther
//
//  Created by user184453 on 4/23/21.
//

import Foundation

class Pencil: Tool {

    var size: Int?
    
    func nibArea(x: Int, y: Int) -> [[Int]]? {
        // Assumes we are working on an Art pixel-level -- i.e. the cordinate one whole unit to the right of a pixel is another seperate pixel.
        // Could be changed to supplied dimensions of canvas to instantly raise error.
        
        guard let size = self.size else { return nil }
        
        let offset = (size-1)/2
        let topLeft = [x-offset, y-offset] // Refer to coordinate system.
    
        var area = [[Int]]()
        for i in topLeft[0]..<topLeft[0]+size {
            for j in topLeft[1]..<topLeft[1]+size {
                area.append([i,j])
            }
        }
        
        return area
        
    }
    
}
