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
    // A FINIR
    // Empêcher le swipe si pas de photos FAIT!
    // Animations fini réapparition de la grid que si partage finies ou annuler
    // Animation retour si annuler ??
    // ! ALfa pour boutton plus FAIT!
    // ! modifier nom des bouttons FAIT!
    // ! voir ligne 206
    // ! créer la doc
    // ! https://stackoverflow.com/questions/33090477/how-to-perform-action-after-uiactivityviewcontroller-called-and-then-closed
    
    // Outlet label text "Swipe [..] to share"
    @IBOutlet weak var swipeLabel: UILabel!
    
    // Outlets View Grid
    @IBOutlet weak var viewGrid: UIView!
    @IBOutlet weak var viewGridTopLeft: UIImageView!
    @IBOutlet weak var viewGridTopRight: UIImageView!
    @IBOutlet weak var viewGridBottomLeft: UIImageView!
    @IBOutlet weak var viewGridBottomRight: UIImageView!
    
    // Outlet add images button View Grid
    @IBOutlet weak var topLeft: UIButton!
    @IBOutlet weak var topRight: UIButton!
    @IBOutlet weak var bottomLeft: UIButton!
    @IBOutlet weak var bottomRight: UIButton!
    
    // Variable d'identification de la vue pour l'image picker
    // View identification variable for image picker
    var selectedImageView: UIImageView?
    // Action button View Grid
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
    
    // Outlets Buttons Style
    @IBOutlet weak var buttonRectangleTopImg: UIButton!
    @IBOutlet weak var buttonRectangleBottomImg: UIButton!
    @IBOutlet weak var buttonSquareImg: UIButton!
    
    // Action button
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
    
    // Enum permettant de cacher les boutons quand le swip est actif
    // Enum to hide or show the buttons when the swip is active or not
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
            topLeft.isHidden = false
            topRight.isHidden = false
            bottomLeft.isHidden = false
            bottomRight.isHidden = false
        case .isHidden:
            topLeft.isHidden = true
            topRight.isHidden = true
            bottomLeft.isHidden = true
            bottomRight.isHidden = true
        }
    }
    
    // Fonction détection de l'action de swipe
    // Swipe action detection function
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        activeVerify()
        if isOk == true {
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
            // Once the swipe is finished, depending on the screen orientation, the animation is activated either for the swipe up or for the swipe left.
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
    
    
    
    // Fonction de partage
    func shareViewGrid(){
        // Récupération de la viewGrid pour la transformer en image
        UIGraphicsBeginImageContext(viewGrid.frame.size)
        viewGrid.layer.render(in: UIGraphicsGetCurrentContext()!)
        guard let imageViewGrid = UIGraphicsGetImageFromCurrentImageContext() else {
            return
        }
        
        // Début de la séquance de partage
        // On récupère l'image généré pour l'envoyer à l'activity controller
        let activityViewController = UIActivityViewController(activityItems: [imageViewGrid], applicationActivities: nil)
        
        // On ouvre la pop-up
        present(activityViewController, animated: true, completion: nil)
        self.viewGrid.transform = .identity
        self.viewGrid.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            self.viewGrid.transform = .identity
        })
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
    
    // Fonction d'initialisation de l'image picker pour les boutons d'ajout d'image de la VG
    // Image picker initialization function for the VG's add image buttons
    func initialImgPicker() {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true)
    }
    
    // Function image picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if let selectedImageView = selectedImageView {
                selectedImageView.image = image
            }
        }
        self.dismiss(animated: true, completion: nil)
        changeAppearanceButton()
    }
    
    
    // Fonction appelé si l'image a ajouter une image, si oui le bouton Plus disparait, mais reste cliquable pour pouvoir modifier l'image
    func changeAppearanceButton(){
        if viewGridTopLeft.image != nil{
            topLeft.setImage(#imageLiteral(resourceName: "Clear"), for: .normal)
        }
        if viewGridTopRight.image != nil{
            topRight.setImage(#imageLiteral(resourceName: "Clear"), for: .normal)
        }
        if viewGridBottomLeft.image != nil{
            bottomLeft.setImage(#imageLiteral(resourceName: "Clear"), for: .normal)
        }
        if viewGridBottomRight.image != nil{
            bottomRight.setImage(#imageLiteral(resourceName: "Clear"), for: .normal)
        }
    }
    
    func animateSwipe(){
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
                         // mettre le shareViewGrid iic
                         
                         // prendre ce code et l'ajouter à la fin de l'animation du sharevg avec le code stack de aurélien
                         // sans oublier de remettre ce code dan une uiview.animate sinon il ne lira pas le .identity
                         self.viewGrid.transform = .identity
                         self.viewGrid.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                         UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                             self.viewGrid.transform = .identity
                         })
                     }
                 })
                 shareViewGrid()
                 
             }
    }
    
    enum VerifyViewGrid {
        case rectangleTopVerify, rectangleBottomVerify, squareVerify
    }
    var viewsActive: VerifyViewGrid = .squareVerify
    
    var isOk = false
    private func activeVerify() {
        switch viewsActive {
        case .rectangleTopVerify:
            if viewGridTopLeft.image != nil && viewGridBottomLeft.image != nil && viewGridBottomRight.image != nil {
                isOk = true
            } else {
                isOk = false
            }
        case .rectangleBottomVerify:
            if viewGridTopLeft.image != nil && viewGridTopRight.image != nil && viewGridBottomLeft.image != nil {
                isOk = true
            } else {
                isOk = false
            }
        case .squareVerify:
            if viewGridTopLeft.image != nil && viewGridTopRight.image != nil && viewGridBottomLeft.image != nil && viewGridBottomRight.image != nil {
                isOk = true
            } else {
                isOk = false
            }
        }
    }
}
