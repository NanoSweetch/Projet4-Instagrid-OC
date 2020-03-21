//
//  ViewController.swift
//  Instagrid
//
//   Created by Maxime DUTOUR on 27/02/2020.
//  Copyright © 2020 Maxime DUTOUR. All rights reserved.
//

import UIKit

extension ViewController: UIImagePickerControllerDelegate {
    // MARK: - UIImagePickerController
    
    // Fonction d'ajout d'une photo depuis la galerie vers la view grid
    /// Function image picker
    /// - Parameters:
    ///   - picker: Call the UIImagePickerController
    ///   - info: Retrieves information from the selected image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if let selectedImageView = selectedImageView {
                selectedImageView.image = image
            }
        }
        self.dismiss(animated: true, completion: nil)
        changeAppearanceButton()
    }
}

extension ViewController: UINavigationControllerDelegate {
    // MARK: - UINavigationController
    
    // Fonction détection de l'orientation
    /// Orientation detection function
    /// - Parameters:
    ///   - newCollection: Detects a change in orientation based on the screen size.
    ///   - coordinator: Call UIViewControllerTransitionCoordinator
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        coordinator.animate(alongsideTransition: { (context) in
            guard let windowInterfaceOrientation = self.windowInterfaceOrientation else { return }
            
            // Si l'appareil est en landscape le label change et le swipe aussi et inversement en portrait
            // If the device is in landscape the label changes and the swipe as well and vice versa with portrait.
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

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Configuring the radius and shadow of the grid view
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
    
    // MARK: - IBAction functions
    
    // Action buttons views grid
     @IBAction func topLeft(_ sender: Any) {
         selectedImageView = viewGridTopLeft
         initialImgPicker()
     }
     @IBAction func topRight(_ sender: Any) {
         selectedImageView = viewGridTopRight
         initialImgPicker()
     }
     @IBAction func bottomLeft(_ sender: Any) {
         selectedImageView = viewGridBottomLeft
         initialImgPicker()
     }
     @IBAction func bottomRight(_ sender: Any) {
         selectedImageView = viewGridBottomRight
         initialImgPicker()
     }
    
    // Action Buttons Style
    @IBAction func buttonRectangleTop(_ sender: Any) {
        style = .rectangleTop
        viewsActive = .rectangleTopVerify
    }
    @IBAction func buttonRectangleBottom(_ sender: Any) {
        style = .rectangleBottom
        viewsActive = .rectangleBottomVerify
    }
    @IBAction func buttonSquare(_ sender: Any) {
        style = .square
        viewsActive = .squareVerify
    }

    /// Configuring Button Styles and Actions
    // Configuration des styles et actions des boutons
    enum StyleGrid {
        case rectangleTop, rectangleBottom, square
    }
    private var style: StyleGrid = .rectangleBottom{
        didSet {
            setStyle(style)
        }
    }
    
    // Depending on the selected button, a frame is hidden or displayed and the button image is changed.
    /// Determines the semantic button to assign style changes to it
    /// - Parameter style: Assigns the chosen case
    private func setStyle(_ style: StyleGrid) {
        switch style {
        case .rectangleTop:
            viewGridTopRight.isHidden = true
            topRight.isHidden = true
            viewGridBottomRight.isHidden = false
            bottomRight.isHidden = false
            buttonRectangleTopImg.setBackgroundImage(#imageLiteral(resourceName: "Layout Selected 1"), for: .normal)
            buttonRectangleBottomImg.setBackgroundImage(#imageLiteral(resourceName: "Layout 2"), for: .normal)
            buttonSquareImg.setBackgroundImage(#imageLiteral(resourceName: "Layout 3"), for: .normal)
        case .rectangleBottom:
            viewGridBottomRight.isHidden = true
            bottomRight.isHidden = true
            viewGridTopRight.isHidden = false
            topRight.isHidden = false
            buttonRectangleTopImg.setBackgroundImage(#imageLiteral(resourceName: "Layout 1"), for: .normal)
            buttonRectangleBottomImg.setBackgroundImage(#imageLiteral(resourceName: "Layout Selected 2"), for: .normal)
            buttonSquareImg.setBackgroundImage(#imageLiteral(resourceName: "Layout 3"), for: .normal)
        case .square:
            viewGridTopRight.isHidden = false
            topRight.isHidden = false
            viewGridBottomRight.isHidden = false
            bottomRight.isHidden = false
            buttonRectangleTopImg.setBackgroundImage(#imageLiteral(resourceName: "Layout 1"), for: .normal)
            buttonRectangleBottomImg.setBackgroundImage(#imageLiteral(resourceName: "Layout 2"), for: .normal)
            buttonSquareImg.setBackgroundImage(#imageLiteral(resourceName: "Layout Selected 3"), for: .normal)
        }
    }
    
    // MARK: - IBOutlets

    // Outlet for label text "Swipe [..] to share"
    @IBOutlet weak var swipeLabel: UILabel!
    
    // Outlets View Grid
    @IBOutlet weak var viewGrid: UIView!
    @IBOutlet weak var viewGridTopLeft: UIImageView!
    @IBOutlet weak var viewGridTopRight: UIImageView!
    @IBOutlet weak var viewGridBottomLeft: UIImageView!
    @IBOutlet weak var viewGridBottomRight: UIImageView!
    
    // Outlet add images Plus on button in views grid
    @IBOutlet weak var topLeft: UIButton!
    @IBOutlet weak var topRight: UIButton!
    @IBOutlet weak var bottomLeft: UIButton!
    @IBOutlet weak var bottomRight: UIButton!
    
    // Outlets Buttons Style
    @IBOutlet weak var buttonRectangleTopImg: UIButton!
    @IBOutlet weak var buttonRectangleBottomImg: UIButton!
    @IBOutlet weak var buttonSquareImg: UIButton!
    
    // Variable d'identification de la vue pour l'image picker
    // View identification variable for image picker
    private var selectedImageView: UIImageView?
    
    // MARK: - Swipe detection function
    
    // Fonction de détection de l'action swipe
    /// Swipe action detection function
    /// - Parameter gesture: Use UIPanGestureRecognizer
    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        // Fonction activeVerify est appelé pour vérifier le statut de isOK
        activeViewStatusCheck()
        if statusCheckForSwipe == true {
            if gesture.state == .began{
                // Start of detection
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
                // Once the swipe is finished, depending on the screen orientation, the animation is activated either for the swipe up or for the swipe left.
                
                // AnimateSwipe verifie si toutes les vues ont une image pour lancer l'animation sinon un message d'erreur apparait
                animateSwipe()
            } else if gesture.state == .cancelled {
                self.viewGrid.transform = .identity
            }
        } else {
            let alert = UIAlertController(title: "Incomplete Grid !", message: "Please add images inside the empty frames.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
        }
    }
    
    // MARK: - Disappear View Animation function
    
    // Fonction d'animation qui fait disparaitre la vue de l'écran
    /// Animation function that makes the screen view disappear
    private func animateSwipe(){
        if windowInterfaceOrientation?.isPortrait == true {
            // If the device is in portrait mode, the view leaves the screen from the top and reappears in the center of the screen.
            UIView.animate(withDuration: 0.4, animations: {
                self.viewGrid.transform = CGAffineTransform(translationX: 0, y: -700)
            }, completion: { (success) in
                if success {
                    self.shareViewGrid()
                }
            })
        } else {
            // If the device is in landscape mode the view leaves the screen from the side and reappears in the center of the screen.
            UIView.animate(withDuration: 0.4, animations: {
                self.viewGrid.transform = CGAffineTransform(translationX: -700, y: 0)
            }, completion: { (success) in
                if success {
                    self.shareViewGrid()
                }
            })
        }
    }
    
    // MARK: - Sharing function
    
    // Fonction de partage
    /// Sharing function
    private func shareViewGrid(){
        // Récupération de la viewGrid pour la transformer en image
        UIGraphicsBeginImageContext(viewGrid.frame.size)
        viewGrid.layer.render(in: UIGraphicsGetCurrentContext()!)
        guard let imageViewGrid = UIGraphicsGetImageFromCurrentImageContext() else {
            return
        }
        
        // Début de la séquance de partage
        // On récupère l'image généré pour l'envoyer à l'activity controller
        let activityViewController = UIActivityViewController(activityItems: [imageViewGrid], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            if success{
                self.resetAnimate()
            } else {
                self.resetAnimate()
            }
        }
        // On ouvre la pop-up de partage, puis si annulée ou complété on réinitialise les vues avec resetAnimate
        present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - Reset function
    
    /// resetAnimate allows to restore the original appearance of the views after use
    private func resetAnimate(){
        // Supprime les images pour repartir de zéro
        // Deletes images to start from scratch
        viewGridTopLeft.image = nil
        viewGridTopRight.image = nil
        viewGridBottomLeft.image = nil
        viewGridBottomRight.image = nil
        
        // Fait réapparaitre les boutons Plus
        // Makes the Plus button reappear
        changeAppearanceButton()
        // Lancement de l'animation du retour de la vue à l'écran
        self.viewGrid.transform = .identity
        self.viewGrid.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            self.viewGrid.transform = .identity
        })
    }
    
    // Fonction d'initialisation de l'image picker pour les boutons d'ajout d'image de la VG
    /// Image picker initialization function for the VG's add image buttons
    private func initialImgPicker() {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true)
    }
    
    // MARK: - Disappear Plus button function
    
    // Fonction de disparition et apparition du bouton Plus appelée si l'image a ajouté une image, si oui le bouton Plus disparait, mais reste cliquable pour pouvoir modifier l'image, sinon l'image Plus apparait
    /// Changes the appearance of the views when an image is added
    private func changeAppearanceButton(){
        viewGridTopLeft.image != nil ? topLeft.setImage(#imageLiteral(resourceName: "Clear"), for: .normal) : topLeft.setImage(#imageLiteral(resourceName: "Plus"), for: .normal)
        viewGridTopRight.image != nil ? topRight.setImage(#imageLiteral(resourceName: "Clear"), for: .normal) : topRight.setImage(#imageLiteral(resourceName: "Plus"), for: .normal)
        viewGridBottomLeft.image != nil ? bottomLeft.setImage(#imageLiteral(resourceName: "Clear"), for: .normal) : bottomLeft.setImage(#imageLiteral(resourceName: "Plus"), for: .normal)
        viewGridBottomRight.image != nil ? bottomRight.setImage(#imageLiteral(resourceName: "Clear"), for: .normal) : bottomRight.setImage(#imageLiteral(resourceName: "Plus"), for: .normal)
    }
    
    // MARK: - Verify nil image function
    
    // Vérification du statut des vues. Si toutes les vues sont non nil alors la var isOK passe à True et permet de déclencher la fonction swipe.
    /// Checks the status of the views to allow swipe activation if the conditions are met
    enum VerifyViewGrid {
        case rectangleTopVerify, rectangleBottomVerify, squareVerify
    }
    private var viewsActive: VerifyViewGrid = .squareVerify
    
    private var statusCheckForSwipe = false
    private func activeViewStatusCheck() {
        switch viewsActive {
        case .rectangleTopVerify:
            statusCheckForSwipe = viewGridTopLeft.image != nil && viewGridBottomLeft.image != nil && viewGridBottomRight.image != nil
        case .rectangleBottomVerify:
            statusCheckForSwipe = viewGridTopLeft.image != nil && viewGridTopRight.image != nil && viewGridBottomLeft.image != nil
        case .squareVerify:
            statusCheckForSwipe = viewGridTopLeft.image != nil && viewGridTopRight.image != nil && viewGridBottomLeft.image != nil && viewGridBottomRight.image != nil
        }
    }
}
