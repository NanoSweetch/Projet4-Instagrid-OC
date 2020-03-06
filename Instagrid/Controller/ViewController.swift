//
//  ViewController.swift
//  Instagrid
//
//   Created by Maxime DUTOUR on 27/02/2020.
//  Copyright © 2020 Maxime DUTOUR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Configuring the radius of the grid view
               viewGrid.layer.cornerRadius = 15
               viewGridTopLeft.layer.cornerRadius = 4
               viewGridTopRight.layer.cornerRadius = 4
               viewGridBottomLeft.layer.cornerRadius = 4
               viewGridBottomRight.layer.cornerRadius = 4
        
        // Initialise l'annimation du swipe au premier lancement de l'application
    self.viewGrid.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture)))
        
    }
    
    // Outlet label text "Swipe [..] to share"
    @IBOutlet weak var swipeLabel: UILabel!
    
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
    
     // Fonction detection de l'action de swipe
     @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
         if gesture.state == .began{
             
         } else if gesture.state == .changed {
             let translation = gesture.translation(in: self.view)
             
             // En fonction des conditions d'orientation de l'appareil, le swipe est possible soit à gauche soit en haut
             if windowInterfaceOrientation?.isPortrait == true {
                 viewGrid.transform = CGAffineTransform(translationX: 0, y: translation.y)
             } else {
                 viewGrid.transform = CGAffineTransform(translationX: translation.x, y: 0)
             }
         } else if gesture.state == .ended {
             UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                 self.viewGrid.transform = .identity
             })
         }
     }
     
   // Fonction détection de l'orientation
     override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
          super.willTransition(to: newCollection, with: coordinator)
          
          coordinator.animate(alongsideTransition: { (context) in
              guard let windowInterfaceOrientation = self.windowInterfaceOrientation else { return }
              
             // Si l'appareil est en landscape le label change et le swipe aussi et inversement avec else
              if windowInterfaceOrientation.isLandscape {
                  // activate landscape changes
                 self.swipeLabel.text = "Swipe left to share"
                 self.viewGrid.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture)))
              } else {
                  // activate portrait changes
                 self.swipeLabel.text = "Swipe up to share"
                 self.viewGrid.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture)))
              }
          })
      }
      
      private var windowInterfaceOrientation: UIInterfaceOrientation? {
          return UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
    }
   
    //        let activityVC = UIActivityViewController(activityItems: [viewGrid as Any], applicationActivities: nil)
    //        activityVC.popoverPresentationController?.sourceView = self.view
    //
    //        self.present(activityVC, animated: true, completion: nil)
    
}
