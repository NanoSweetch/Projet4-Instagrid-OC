//
//  NavigationController.swift
//  Instagrid
//
//  Created by Maxime DUTOUR on 21/03/2020.
//  Copyright © 2020 Macbook pro. All rights reserved.
//

import UIKit

extension ViewGridController: UINavigationControllerDelegate {
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
     var windowInterfaceOrientation: UIInterfaceOrientation? {
        return UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
    }
}
