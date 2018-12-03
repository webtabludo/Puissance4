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
    

    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var boutonValider: UIButton!
    
    @IBOutlet weak var slider: UISlider!
    var victoire =  false
    let positionsCurseur = [8,60,113,165,217,270,322]
    
    let coordHorizontal = [8,60,113,165,217,270,322]
    let coordVertical = [473,419.5,367,314.5,262,209.5]
    
    var positCurseur = 8
    var mecanisme = Mecanisme()
    var remplissageColonne = 0
    var brain = BrainIA()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mecanisme.grilleVide = Array(repeating: "O", count: 42)
        mecanisme.coordonnées = Dictionary(uniqueKeysWithValues: zip(1...42,mecanisme.grilleVide))
        
    }
    
    // Fonction popup Alert fin de jeu
    
    func alerte(winner: String) {
        
        let alert = UIAlertController(title: "Game Over", message: winner, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
            
            // self.view.subviews.forEach { $0.removeFromSuperview() }
            for v in self.view.subviews{
                if v is JetonJaune {
                    v.removeFromSuperview()
                } else if v is JetonRouge {
                    v.removeFromSuperview()
                }
            }
            self.victoire = false
            self.positCurseur = 8
            self.remplissageColonne = 0
            self.mecanisme.grilleDeJeux = [[],[],[],[],[],[],[]]
            self.mecanisme.grilleVide = []
            self.mecanisme.coordonnées = [:]
            self.mecanisme.grilleRed = []
            self.mecanisme.grilleYellow = []

        }
        let backView = alert.view.subviews.last?.subviews.last
        backView?.layer.cornerRadius = 10.0
        backView?.backgroundColor = UIColor.yellow
        
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
    }
    // Slider + Mouvement flèche
    
    @IBAction func slider(_ sender: UISlider) {
        let currentValue = coordHorizontal[Int(sender.value)]
        positCurseur = currentValue
        UIView.animate(withDuration: 0, animations: {
            self.arrow.frame.origin.x = CGFloat(self.positCurseur)
        }, completion: nil)
    }
    
    // Bouton valider
    
    @IBAction func valideAction(_ sender: UIButton) {
        var gravityBoundary = boundary(positCurseur: positCurseur)

        creationJetonRouge(frameX: positCurseur, gravityB: CGFloat(gravityBoundary))
        
        // Ajouter le jeton dans la grille
        let colonne = addJeton()
        
        updateGlobal(jeton: "R", colonne: colonne, remplissageColonne: remplissageColonne)
        if mecanisme.testVictoire(grilleJeton: mecanisme.grilleRed) == true {
            print("victoire rouge")
            alerte(winner: "vous avez gagné")
            
        } else if (mecanisme.grilleRed.count + mecanisme.grilleYellow.count) == 42 {
            alerte(winner: "Egalité")
        }
        boutonValider.isEnabled = false
        //IA Play
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {

            let choix = self.brain.iAPlay(red: self.mecanisme.grilleRed, yellow: self.mecanisme.grilleYellow)
            self.positCurseur = self.positionsCurseur[choix]
            self.slider.setValue(Float(choix), animated: true)
            UIView.animate(withDuration: 0, animations: {
                self.arrow.frame.origin.x = CGFloat(self.positCurseur)
            }, completion: nil)
            

            gravityBoundary = self.boundary(positCurseur: self.positCurseur)
            self.creationJetonJaune(frameX: self.positCurseur, gravityB: CGFloat(gravityBoundary))
            
            let colonneIA = self.addJeton()
            self.updateGlobal(jeton: "J", colonne: colonneIA, remplissageColonne: self.remplissageColonne)
            if self.mecanisme.testVictoire(grilleJeton: self.mecanisme.grilleYellow) == true {
                print("victoire jaune")
                self.alerte(winner: "I'm the best")

            } else if (self.mecanisme.grilleRed.count + self.mecanisme.grilleYellow.count) == 42 {
                self.alerte(winner: "Egalité")
                
            }
            self.boutonValider.isEnabled = true
        }
    }
    
    //Fonction ajouter le jeton dans la grille
    
    func addJeton () -> Int {
        var colonne = 0
        switch positCurseur {
        case 8:
            colonne = 0
        case 60:
            colonne = 1
        case 113:
            colonne = 2
        case 165:
            colonne = 3
        case 217:
            colonne = 4
        case 270:
            colonne = 5
        case 322:
            colonne = 6
        default:
            print("impossible")
        }
        return colonne
    }
    
    //Fonction création de la boundary player
    
    func boundary (positCurseur: Int) -> Double {
        var gravityBoundary = 0.0
        switch positCurseur {
        case 8:
            remplissageColonne = mecanisme.grilleDeJeux[0].count
            gravityBoundary = coordVertical[remplissageColonne]
        case 60:
            remplissageColonne = mecanisme.grilleDeJeux[1].count
            gravityBoundary = coordVertical[remplissageColonne]
        case 113:
            remplissageColonne = mecanisme.grilleDeJeux[2].count
            gravityBoundary = coordVertical[remplissageColonne]
        case 165:
            remplissageColonne = mecanisme.grilleDeJeux[3].count
            gravityBoundary = coordVertical[remplissageColonne]
        case 217:
            remplissageColonne = mecanisme.grilleDeJeux[4].count
            gravityBoundary = coordVertical[remplissageColonne]
        case 270:
            remplissageColonne = mecanisme.grilleDeJeux[5].count
            gravityBoundary = coordVertical[remplissageColonne]
        case 322:
            remplissageColonne = mecanisme.grilleDeJeux[6].count
            gravityBoundary = coordVertical[remplissageColonne]
        default:
            print("impossible")
            
        }
        
        return gravityBoundary
    }
    
    
    
    // Fonction mise à jour BDD + test victoire
    
    func updateGlobal (jeton: String, colonne: Int, remplissageColonne: Int) {
        
        mecanisme.ajouterJeton(jeton: jeton, colonne: colonne)
        
        mecanisme.coordonnées.updateValue(jeton, forKey: (remplissageColonne * 7) + (colonne + 1))
        print("mecanisme.coordonnées:\(mecanisme.coordonnées)")
        for (key,value) in mecanisme.coordonnées {
            if value == "R" {
                mecanisme.grilleRed.insert(key)
                print("GrilleRed:\(mecanisme.grilleRed)")
            } else if value == "J" {
                mecanisme.grilleYellow.insert(key)
                print("GrilleYellow:\(mecanisme.grilleYellow)")
            }
        }
    }

    
    // Fonction création d'un Jeton Rouge
    
    func creationJetonRouge (frameX:Int, gravityB: CGFloat) {
        
        
        let imageRondeRouge = JetonRouge(frame: CGRect(x: frameX, y: 0, width: 45, height: 45))
        
        view.addSubview(imageRondeRouge)
        
        
        creationGravity(jeton: imageRondeRouge, a: CGFloat(frameX), b: gravityB)
    }
    
    // Fonction création d'un Jeton jaune
    
    func creationJetonJaune (frameX:Int, gravityB: CGFloat) {
        let imageRondeJaune = JetonJaune(frame: CGRect(x: frameX, y: 0, width: 45, height: 45))
        
        view.addSubview(imageRondeJaune)
        
        
        creationGravity(jeton: imageRondeJaune, a: CGFloat(frameX), b: gravityB)
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

