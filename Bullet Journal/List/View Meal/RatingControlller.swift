//
//  RatingControlller.swift
//  DemoAppBeenLoveMemoryLite
//
//  Created by dohien on 05/09/2018.
//  Copyright © 2018 dohien. All rights reserved.
//

import UIKit
@IBDesignable class RatingController: UIStackView {
    private var ratingButtons = [UIButton]()
    var rating = 0 {
        didSet{
            updateButtonSelectionStates()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    required init(coder: NSCoder){
        super.init(coder : coder)
        setupButtons()
    }
    @objc func ratingButtonTapped(button: UIButton){
        guard let index = ratingButtons.firstIndex(of: button)  else {
            fatalError("The Button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        // index (of) : Find the tapped button and return its index
        // Rating
        let selectedRating = index + 1
        if selectedRating == 0{
            // 0 star for default
            rating = 0
        } else {
            // Rating for the tapped star
            rating = selectedRating
        }
    }
    private func setupButtons(){
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
    
        let bundle = Bundle(for : type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        for index in 0..<starCount {
            let button = UIButton()
            // Set button's image
            button.setImage(emptyStar, for: .normal)
            button.setImage(highlightedStar, for: .selected)
            button.setImage(filledStar, for: .highlighted)
            button.setImage(filledStar, for: [.highlighted, .selected])
            // Setup the constrain star
            button.translatesAutoresizingMaskIntoConstraints = false
            // Setup the size for star
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            button.accessibilityLabel = "Set \(index + 1) star rating"
            
            button.addTarget(self, action: #selector(RatingController.ratingButtonTapped(button:)), for: .touchUpInside)
            addArrangedSubview(button)
            
            ratingButtons.append(button)
        }
        updateButtonSelectionStates()
    }
    // Setup star's size
    @IBInspectable var starSize: CGSize = CGSize(width: 30, height: 30){
        didSet{
            setupButtons()
        }
    }
    // Number of stars
    @IBInspectable var starCount: Int = 5 {
        didSet{
            setupButtons()
        }
    }
    // Updating button selection
    private func updateButtonSelectionStates(){
        for (index , button) in ratingButtons.enumerated(){
            button.isSelected = index < rating
            //
            let hinString: String?
            if rating == index + 1{
                hinString = "Tap to reset the rating to zero."
            }else{
                hinString = nil
            }
            //
            let valueString: String
            switch (rating) {
            case 0:
                valueString = "No rating set."
            case 1:
                valueString = "1 star set."
            default:
                valueString = "\(rating) stars set."
            }
            button.accessibilityHint = hinString
            button.accessibilityValue = valueString
        }
    }
    
}

