//
//  ViewController.swift
//  Puissance4
//
//  Created by ludo iMac on 25/11/2018.
//  Copyright © 2018 ludo iMac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var gravity: UIGravityBehavior!
    var animator: UIDynamicAnimator!
    var collision: UICollisionBehavior!
  
    var jetonRouge: JetonRouge!
    var jetonJaune: JetonJaune!


    let coordHorizontal = [8,60,113,165,217,270,322]
    let coordVertical = [472,419.5,367,314.5,262,209.5]
    
    // Grille de jeux 0 = vide / R = jeton rouge / J = jeton jaune
    var grilleDeJeux = [["0","0","0","0","0","0"],["0","0","0","0","0","0"],["0","0","0","0","0","0"],["0","0","0","0","0","0"],["0","0","0","0","0","0"],["0","0","0","0","0","0"],["0","0","0","0","0","0"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
       creationJetonRouge(frameX: coordHorizontal[0], gravityA: CGFloat(coordHorizontal[0]), gravityB: CGFloat(coordVertical[1]))

    }
        
        
// Fonction création d'un Jeton rouge
    
    func creationJetonRouge (frameX:Int, gravityA: CGFloat, gravityB: CGFloat) {
       
        
        let imageRondeRouge = JetonRouge(frame: CGRect(x: frameX, y: 0, width: 45, height: 45))
        //imageRondeRouge.backgroundColor = UIColor.red
        view.addSubview(imageRondeRouge)

        
        creationGravity(jeton: imageRondeRouge, a: gravityA, b: gravityB)
    }

    // Fonction création d'un Jeton jaune (à faire)
    
    func creationJetonJaune () {
        
    }
    // Fonction création de la gravité
    
    func creationGravity (jeton: UIView, a: CGFloat, b:CGFloat) {
        
        animator = UIDynamicAnimator(referenceView: view)
        gravity = UIGravityBehavior(items: [jeton])
        animator.addBehavior(gravity)
        
        collision = UICollisionBehavior(items: [jeton])
        animator.addBehavior(collision)
        
        // set collision boundaries
        collision.addBoundary(withIdentifier: "Boundary" as NSCopying, from: CGPoint(x: a,y: b), to: CGPoint(x: a + 50, y: b))
        
        
        collision.collisionMode = .everything
        animator.addBehavior(collision)
    }
}

