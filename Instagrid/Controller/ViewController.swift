//
//  ViewController.swift
//  Instagrid
//
//   Created by Maxime DUTOUR on 27/02/2020.
//  Copyright © 2020 Maxime DUTOUR. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Configuring the radius of the grid view
               viewGrid.layer.cornerRadius = 15
               viewGrid.layer.shadowRadius = 5
               viewGrid.layer.shadowOpacity = 0.5
               viewGridTopLeft.layer.cornerRadius = 4
               viewGridTopRight.layer.cornerRadius = 4
               viewGridBottomLeft.layer.cornerRadius = 4
               viewGridBottomRight.layer.cornerRadius = 4
        
        // Initialise l'animation du swipe au premier lancement de l'application
        // Initializes the annimation of the swipe at the first launch of the application.
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
    
    // Outlet collection button View Grid
    @IBOutlet weak var L1: UIButton!
    @IBOutlet weak var L2: UIButton!
    @IBOutlet weak var R1: UIButton!
    @IBOutlet weak var R2: UIButton!

    
    // Action button View Grid
    @IBAction func L1(_ sender: Any) {
    }
    @IBAction func L2(_ sender: Any) {
    }
    @IBAction func R1(_ sender: Any) {
    }
    @IBAction func R2(_ sender: Any) {
    }
    
    
    // Outlets Buttons Style
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
    // Configuring Button Styles and Actions
    enum StyleGrid {
        case rectangleTop, rectangleBottom, square
    }
    
   var style: StyleGrid = .rectangleBottom{
        didSet {
            setStyle(style)
        }
    }
    
    // En fonction du bouton sélectionné on cache une vue ou on les affiche et l'image du bouton est modifié
    // Depending on the selected button, a frame is hidden or displayed and the button image is changed.
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
    
     // enum pour set button hidden
    enum ButtonVGHid {
        case isHidden, show
    }
    var buttonState: ButtonVGHid = .show{
        didSet {
            setState(buttonState)
        }
    }
    private func setState(_ buttonState: ButtonVGHid) {
           switch buttonState {
           case .show:
            L1.isHidden = false
            L2.isHidden = false
            R1.isHidden = false
            R2.isHidden = false
           case .isHidden:
            L1.isHidden = true
            L2.isHidden = true
            R1.isHidden = true
            R2.isHidden = true
        }
    }
    
     // Fonction détection de l'action de swipe
     // Swipe action detection function
     @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        
        // Constante utiliser pour sortir la vue de l'écran pendant l'animation
        // Constant used to exit the screen view during animation
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        
        
         if gesture.state == .began{
            buttonState = .isHidden
            // Pour le statut .began rien ne se passe
            // For the status .began nothing happens
         } else if gesture.state == .changed {
            // Le statut changed permet de commencer le déplacement de la vue
            // The status changed allows you to start moving the view
             let translation = gesture.translation(in: self.view)
             // En fonction des conditions d'orientation de l'appareil, le swipe est possible soit à gauche soit en haut
             // Depending on the orientation of the device, the swipe is possible either to the left or to the top.
             if windowInterfaceOrientation?.isPortrait == true {
                 viewGrid.transform = CGAffineTransform(translationX: 0, y: translation.y)
             } else {
                 viewGrid.transform = CGAffineTransform(translationX: translation.x, y: 0)
             }
            
         } else if gesture.state == .ended {
            // Une fois le swipe terminé en fonction de l'orientation de l'écran l'animation s'active soit pour le swipe up soit pour le swipe left
            // Once the swipe is finished, depending on the screen orientation, the animation is activated either for the swipe up or for the swipe left.
            if windowInterfaceOrientation?.isPortrait == true {
                // Si le device est en mode portrait la vue quitte l'écran par le haut et réapparait au centre de l'écran
                // If the device is in portrait mode, the view leaves the screen from the top and reappears in the center of the screen.
                UIView.animate(withDuration: 0.4, animations: {
                              self.viewGrid.transform = CGAffineTransform(translationX: 0, y: -screenHeight)
                          }, completion: { (success) in
                              if success {
                                self.viewGrid.transform = .identity
                                self.viewGrid.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                                  UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                                      self.viewGrid.transform = .identity
                                  })
                              }
                          })
                shareVG()
                
            } else {
                // Si le device est en mode landscape la vue quitte l'écran par le côté et réapparait au centre de l'écran
                // If the device is in landscape mode the view leaves the screen from the side and reappears in the center of the screen.
                UIView.animate(withDuration: 0.4, animations: {
                              self.viewGrid.transform = CGAffineTransform(translationX: -screenWidth, y: 0)
                          }, completion: { (success) in
                              if success {
                                self.viewGrid.transform = .identity
                                self.viewGrid.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                                      self.viewGrid.transform = .identity
                                  })
                              }
                          })
                shareVG()

            }
            
         }
     }
    
    // Fonction de partage
    func shareVG(){
        // Récupération de la viewGrid pour la transformer en image
        UIGraphicsBeginImageContext(viewGrid.frame.size)
        viewGrid.layer.render(in: UIGraphicsGetCurrentContext()!)
        guard let imageVG = UIGraphicsGetImageFromCurrentImageContext() else {
            return
        }
    
        // Début de la séquance de partage
        // On récupère l'image généré pour l'envoyer à l'activity controller
        let activityViewController = UIActivityViewController(activityItems: [imageVG], applicationActivities: nil)
        
        // On ouvre la pop-up
        present(activityViewController, animated: true, completion: nil)
        buttonState = .show
    }
     
    // Fonction détection de l'orientation
    // Orientation detection function
     override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
          super.willTransition(to: newCollection, with: coordinator)
          
          coordinator.animate(alongsideTransition: { (context) in
              guard let windowInterfaceOrientation = self.windowInterfaceOrientation else { return }
              
             // Si l'appareil est en landscape le label change et le swipe aussi et inversement avec else
             // If the device is in landscape the label changes and the swipe as well and vice versa with else.
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
   
   
}
