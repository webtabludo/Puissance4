//
//  RondImage.swift
//  Puissance4
//
//  Created by ludo iMac on 26/11/2018.
//  Copyright © 2018 ludo iMac. All rights reserved.
//



import UIKit

class JetonRouge: UIView {
    
    // Besoin si image créé de manière programatique
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupRondRouge()
        
    }
    
    // Besoin si image créée de manière storyboard ou xib (on peut laisser les deux)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupRondRouge()
        
    }
    
    func setupRondRouge() {
        
        layer.cornerRadius = frame.height / 2
        layer.borderColor = UIColor.red.cgColor
        
        layer.borderWidth = 50
        clipsToBounds = true
        contentMode = .scaleAspectFill
    }
    
}
