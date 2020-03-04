//
//  ViewController.swift
//  Instagrid
//
//   Created by Maxime DUTOUR on 27/02/2020.
//  Copyright © 2020 Maxime DUTOUR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var viewGridTopLeft: UIButton!
    @IBOutlet weak var viewGridTopRight: UIButton!
    @IBOutlet weak var viewGridBottomLeft: UIButton!
    @IBOutlet weak var viewGridBottomRight: UIButton!
    
    
  
    
    
    // Action button
    
    @IBAction func buttonRectangleBottom(_ sender: Any) {
        setStyle(.rectangleBottom)
    }
    
    @IBAction func buttonRectangleTop(_ sender: Any) {
        setStyle(.rectangleTop)
    }
    
    @IBAction func buttonSquare(_ sender: Any) {
        setStyle(.square)
    }
    
    // Configuration des styles et actions des boutons
    enum StyleGrid {
        case rectangleTop, rectangleBottom, square
    }
    
//    var style: StyleGrid = .rectangleBottom{
//        didSet {
//            setStyle(style)
//        }
//    }
    
    private func setStyle(_ style: StyleGrid) {
        switch style {
        case .rectangleTop:
            viewGridTopRight.isHidden = true
            viewGridBottomRight.isHidden = false
            //rationTopLeftView.isActive = false
            //rationBottomLeftView.isActive = true
            
            
//            buttonGridImageLeft.setBackgroundImage(UIImage(named: "Layout Selected 1"), for: .normal)
//            buttonGridImageCenter.setBackgroundImage(UIImage(named: "Layout 2"), for: .normal)
//            buttonGridImageRight.setBackgroundImage(UIImage(named: "Layout 3"), for: .normal)
          
        case .rectangleBottom:
             viewGridBottomRight.isHidden = true
             viewGridTopRight.isHidden = false
             //rationTopLeftView.isActive = true
             //rationBottomLeftView.isActive = false
//             buttonGridImageLeft.setBackgroundImage(UIImage(named: "Layout 1"), for: .normal)
//             buttonGridImageCenter.setBackgroundImage(UIImage(named: "Layout Selected 2"), for: .normal)
//             buttonGridImageRight.setBackgroundImage(UIImage(named: "Layout 3"), for: .normal)
           
        case .square:
            viewGridTopRight.isHidden = false
            viewGridBottomRight.isHidden = false
            //rationTopLeftView.isActive = true
            //rationBottomLeftView.isActive = true
//            buttonGridImageLeft.setBackgroundImage(UIImage(named: "Layout 1"), for: .normal)
//            buttonGridImageCenter.setBackgroundImage(UIImage(named: "Layout 2"), for: .normal)
//            buttonGridImageRight.setBackgroundImage(UIImage(named: "Layout Selected 3"), for: .normal)
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

