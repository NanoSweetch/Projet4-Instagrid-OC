//
//  ViewController.swift
//  Instagrid
//
//   Created by Maxime DUTOUR on 27/02/2020.
//  Copyright © 2020 Maxime DUTOUR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Outlets View Grid
    @IBOutlet weak var viewGrid: UIView!
    @IBOutlet weak var viewGridTopLeft: UIImageView!
    @IBOutlet weak var viewGridTopRight: UIImageView!
    @IBOutlet weak var viewGridBottomLeft: UIImageView!
    @IBOutlet weak var viewGridBottomRight: UIImageView!
    
    // Outlets Buttons
    @IBOutlet weak var buttonRectangleTopImg: UIButton!
    @IBOutlet weak var buttonRectangleBottomImg: UIButton!
    @IBOutlet weak var buttonSquareImg: UIButton!
    
    
    // Action button
    @IBAction func buttonRectangleTop(_ sender: Any) {
        style = .rectangleTop
    }
    @IBAction func buttonRectangleBottom(_ sender: Any) {
        style = .rectangleBottom
    }
    @IBAction func buttonSquare(_ sender: Any) {
        style = .square
    }
    
    // Configuration des styles et actions des boutons
    enum StyleGrid {
        case rectangleTop, rectangleBottom, square
    }
    
   var style: StyleGrid = .rectangleBottom{
        didSet {
            setStyle(style)
        }
    }
    
    private func setStyle(_ style: StyleGrid) {
        switch style {
        case .rectangleTop:
            viewGridTopRight.isHidden = true
            viewGridBottomRight.isHidden = false
            buttonRectangleTopImg.setBackgroundImage(UIImage(named: "Layout Selected 1"), for: .normal)
            buttonRectangleBottomImg.setBackgroundImage(UIImage(named: "Layout 2"), for: .normal)
            buttonSquareImg.setBackgroundImage(UIImage(named: "Layout 3"), for: .normal)
          
        case .rectangleBottom:
             viewGridBottomRight.isHidden = true
             viewGridTopRight.isHidden = false
             buttonRectangleTopImg.setBackgroundImage(UIImage(named: "Layout 1"), for: .normal)
             buttonRectangleBottomImg.setBackgroundImage(UIImage(named: "Layout Selected 2"), for: .normal)
             buttonSquareImg.setBackgroundImage(UIImage(named: "Layout 3"), for: .normal)
           
        case .square:
            viewGridTopRight.isHidden = false
            viewGridBottomRight.isHidden = false
            buttonRectangleTopImg.setBackgroundImage(UIImage(named: "Layout 1"), for: .normal)
            buttonRectangleBottomImg.setBackgroundImage(UIImage(named: "Layout 2"), for: .normal)
            buttonSquareImg.setBackgroundImage(UIImage(named: "Layout Selected 3"), for: .normal)
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Configuring the radius of the grid view
               viewGrid.layer.cornerRadius = 15
               viewGridTopLeft.layer.cornerRadius = 4
               viewGridTopRight.layer.cornerRadius = 4
               viewGridBottomLeft.layer.cornerRadius = 4
               viewGridBottomRight.layer.cornerRadius = 4
    }


}

