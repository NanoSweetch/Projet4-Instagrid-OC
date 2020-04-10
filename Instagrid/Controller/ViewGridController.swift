//
//  ViewController.swift
//  Instagrid
//
//   Created by Maxime DUTOUR on 27/02/2020.
//  Copyright © 2020 Maxime DUTOUR. All rights reserved.
//

import UIKit

class ViewGridController: UIViewController {
    
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
    
    // View identification variable for image picker
    var selectedImageView: UIImageView?
    
    private var viewsActive: VerifyViewGrid = .squareVerify
    
    private var statusCheckForSwipe = false
    
    private var style: StyleGrid = .rectangleBottom{
        didSet {
            setStyle(style)
        }
    }
    
    enum VerifyViewGrid {
        case rectangleTopVerify, rectangleBottomVerify, squareVerify
    }
    
    /// Configuring Button Styles and Actions
    enum StyleGrid {
        case rectangleTop, rectangleBottom, square
    }
    
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
        
        // Initializes the annimation of the swipe at the first launch of the application.
        
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        
        upSwipe.direction = .up
        leftSwipe.direction = .left
        
        viewGrid.addGestureRecognizer(upSwipe)
        viewGrid.addGestureRecognizer(leftSwipe)
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
    
    enum Orientation {
        case landscape, portrait
    }
    
    private var orientation: Orientation = .portrait
    
    // MARK: - willTransition
    
    // Fonction détection de l'orientation
    /// Orientation detection function
    /// - Parameters:
    ///   - newCollection: Detects a change in orientation based on the screen size.
    ///   - coordinator: Call UIViewControllerTransitionCoordinator
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        coordinator.animate(alongsideTransition: { (context) in
            
            // If the device is in landscape the label changes and the swipe as well and vice versa with portrait.
            switch UIDevice.current.orientation {
            case .landscapeLeft, .landscapeRight:
                self.orientation = .landscape
                // activate landscape changes
                self.swipeLabel.text = "Swipe left to share"
            default:
                self.orientation = .portrait
                 self.swipeLabel.text = "Swipe up to share"
            }
           
        })
    }
    
    
    // MARK: - Swipe detection function
    
    /// Swipe action detection function
    /// - Parameter sender: Use UISwipeGestureRecognizer
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        //The activeViewStatus function is called to check if the frames are not nil according to the style.
        activeViewStatusCheck()
        // If statusCheckForSwipe == true then the handleSwipes is accessible
        if statusCheckForSwipe {
            animateSwipe(isUp: sender.direction == .up)
          
        } else {
            let alert = UIAlertController(title: "Incomplete Grid !", message: "Please add images inside the empty frames.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
        }
    }
    
    // MARK: - Disappear View Animation function
    
    /// Animation function that makes the screen view disappear
    private func animateSwipe(isUp: Bool){
        // isUp verifies that the direction of the swipe is adapted to the orientation of the device.
        if orientation == .portrait && isUp {
            // If the device is in portrait mode, the view leaves the screen from the top and reappears in the center of the screen.
            UIView.animate(withDuration: 0.4, animations: {
                self.viewGrid.transform = CGAffineTransform(translationX: 0, y: -700)
            }, completion: { (success) in
                if success {
                    self.shareViewGrid()
                }
            })
        } else if orientation == .landscape && !isUp {
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
    
    /// Sharing function
    private func shareViewGrid(){
        // Retrieving the viewGrid to transform it into an image
        UIGraphicsBeginImageContext(viewGrid.frame.size)
        viewGrid.layer.render(in: UIGraphicsGetCurrentContext()!)
        guard let imageViewGrid = UIGraphicsGetImageFromCurrentImageContext() else {
            return
        }
        
        // Beginning of the sharing sequence
        // We recover the generated image to send it to the activity controller.
        let activityViewController = UIActivityViewController(activityItems: [imageViewGrid], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            if success{
                self.resetAnimate()
            } else {
                self.resetAnimate()
            }
        }
        // Open the share pop-up, then if cancelled or completed, reset the views with resetAnimate.
        present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - Reset function
    
    /// resetAnimate allows to restore the original appearance of the views after use
    private func resetAnimate(){
        // Deletes images to start from scratch
        viewGridTopLeft.image = nil
        viewGridTopRight.image = nil
        viewGridBottomLeft.image = nil
        viewGridBottomRight.image = nil
        
        // Makes the Plus button reappear
        changeAppearanceButton()
        // Launching the animation of the return of the view on the screen
        self.viewGrid.transform = .identity
        self.viewGrid.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            self.viewGrid.transform = .identity
        })
    }
    
    /// Image picker initialization function for the VG's add image buttons
    private func initialImgPicker() {
        let image = UIImagePickerController()
        image.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        image.sourceType = .photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true)
    }
    
    // MARK: - Disappear Plus button function
    
    /// Changes the appearance of the views when an image is added
    func changeAppearanceButton(){
        viewGridTopLeft.image != nil ? topLeft.setImage(#imageLiteral(resourceName: "Clear"), for: .normal) : topLeft.setImage(#imageLiteral(resourceName: "Plus"), for: .normal)
        viewGridTopRight.image != nil ? topRight.setImage(#imageLiteral(resourceName: "Clear"), for: .normal) : topRight.setImage(#imageLiteral(resourceName: "Plus"), for: .normal)
        viewGridBottomLeft.image != nil ? bottomLeft.setImage(#imageLiteral(resourceName: "Clear"), for: .normal) : bottomLeft.setImage(#imageLiteral(resourceName: "Plus"), for: .normal)
        viewGridBottomRight.image != nil ? bottomRight.setImage(#imageLiteral(resourceName: "Clear"), for: .normal) : bottomRight.setImage(#imageLiteral(resourceName: "Plus"), for: .normal)
    }
    
    // MARK: - Verify nil image function
    
    /// Checks the status of the views to allow swipe activation if the conditions are met
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
