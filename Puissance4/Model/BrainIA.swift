//
//  BrainIA.swift
//  Puissance4
//
//  Created by ludo iMac on 27/11/2018.
//  Copyright © 2018 ludo iMac. All rights reserved.
//

import UIKit


//  f-    +12    +14    +16
//  e-       +6  +7  +8
//  d-   -2  -1   X  +1   +2
//  c-       -8  -7  -6
//  b-    -16    -14    -12
//  a-
//      0   1   2   3   4   5   6

struct BrainIA {
    var mecanisme = Mecanisme()
    var laGrille:Set<Int> = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42]
    
    //Toujours jouer le premier pion au centre
    
    func playFirst () -> Int {
        return 3
    }
    
    //Fonction choix colonne fonction resultat grille
    
    func colonnePlayed (caseGrille: Int) -> Int {
        
        var resultat = 0
        switch caseGrille {
        case 1, 8, 15, 22, 29, 36:
            resultat = 0
        case 2, 9, 16, 23, 30, 37:
            resultat = 1
        case 3, 10, 17, 24, 31, 38:
            resultat = 2
        case 4, 11, 18, 25, 32, 39:
            resultat = 3
        case 5, 12, 19, 26, 33, 40:
            resultat = 4
        case 6, 13, 20, 27, 34, 41:
            resultat = 5
        case 7, 14, 21, 28, 35, 42:
            resultat = 6
        default:
            print("erreur désignation colonne pour Ia")
        }
        return resultat
    }
    
    // *****************ATTAQUE******************************************
    //fonction Attaque dès que 3 jetons aligner
    
    // Colonne
    func attaqueColonne () -> Int{
        var colonne = 3
        var resultat = 0
        var result:[Int] = []
        var colonnePossible:Set<Int> = []
        for x in mecanisme.grilleYellow {
            let possibilité2:Set<Int> = [x + 7]
            colonnePossible = colonnePossible.union(possibilité2)
            
            colonnePossible = laGrille.intersection(colonnePossible)
            colonnePossible.subtract(mecanisme.grilleRed)
            colonnePossible.subtract(mecanisme.grilleYellow)
        }
        
        if let exist = colonnePossible.first {
            result.append(exist)
            resultat = result.first!
            
        }
        
        if result.count > 1 {
            colonne = 3
        } else {
            if resultat != 0 {
                let combinaison = result + Array(mecanisme.grilleYellow)
                let min = (combinaison.min() ?? 0)
                
                if combinaison.sorted() == ([min,min + 7,min + 14,min + 21].sorted()) {
                    colonne = colonnePlayed(caseGrille: resultat)
                } else {
                    colonne = 3
                }
            }
        }
        print("jouer colonne1:\(colonne)")
        return colonne
    }
    
    //fonction test est ce que adverssaire a 3 jeton aligner et contrer
    
    // Ligne
    func attaqueLigne () -> Int{
        var colonne = 3
        
        var result:[Int] = []
        var resultat = 0
        let limiteGauche = [1,8,15,22,29,36]
        let limiteDroite = [7,14,21,28,35,42]
        
        for x in mecanisme.grilleYellow {
            if limiteGauche.contains(x) {
                
                var lignePossible:Set<Int> = [(x + 1)]
                
                
                lignePossible = laGrille.intersection(lignePossible)
                lignePossible.subtract(mecanisme.grilleRed)
                lignePossible.subtract(mecanisme.grilleYellow)
                
                if let exist = lignePossible.first {
                    result.append(exist)
                }
            } else if limiteDroite.contains(x) {
                
                var lignePossible:Set<Int> = [(x - 1)]
                
                lignePossible = laGrille.intersection(lignePossible)
                lignePossible.subtract(mecanisme.grilleRed)
                lignePossible.subtract(mecanisme.grilleYellow)
                
                if let exist = lignePossible.first {
                    result.append(exist)
                }
            } else {
                
                var lignePossible:Set<Int> = [(x - 1), (x + 1)]
                
                
                lignePossible = laGrille.intersection(lignePossible)
                lignePossible.subtract(mecanisme.grilleRed)
                lignePossible.subtract(mecanisme.grilleYellow)
                if let exist = lignePossible.first {
                    result.append(exist)
                    // print(result)
                }
            }
        }
        
        
        for solution in result {
            
            resultat = solution
            if resultat != 0 && ( mecanisme.grilleYellow.contains(resultat - 7) || mecanisme.grilleRed.contains(resultat - 7) ) {
                
                colonne = colonnePlayed(caseGrille: resultat)
                
            }
            
        }
        print("jouer colonne2:\(colonne)")
        return colonne
    }
    
    //fonction test est ce que adverssaire a 3 jeton aligner et contrer
    
    // Diagonale Gauche
    func attaqueDiagonaleGauche () -> Int{
        var colonne = 0
        var result:[Int] = []
        
        var resultat = 0
        let grilleImpossible = [1,2,3,8,9,15,42,41,35,40,34,28]
        for x in mecanisme.grilleYellow {
            if !grilleImpossible.contains(x) {
                var colonnePossible:Set<Int> = [(x - 6),(x + 6)]
                
                colonnePossible = laGrille.intersection(colonnePossible)
                colonnePossible.subtract(mecanisme.grilleRed)
                colonnePossible.subtract(mecanisme.grilleYellow)
                colonnePossible.subtract(Set(grilleImpossible))
                
                if let exist = colonnePossible.first {
                    result.append(exist)
                }
            }
        }
        for solution in result {
            
            resultat = solution
            if (resultat != 0 && ( mecanisme.grilleYellow.contains(resultat - 7) || mecanisme.grilleRed.contains(resultat - 7))) || resultat <= 7 {
                
                colonne = colonnePlayed(caseGrille: resultat)
            }
        }
        print("jouer colonne3:\(colonne)")
        return colonne
    }
    
    
    // Diagonale Droite
    func attaqueDiagonaleDroite () -> Int{
        var colonne = 0
        var result:[Int] = []
        
        var resultat = 0
        let grilleImpossible = [36,29,37,22,30,38,7,6,14,5,13,21]
        for x in mecanisme.grilleYellow {
            if !grilleImpossible.contains(x) {
                var colonnePossible:Set<Int> = [(x - 8),(x + 8)]
                
                colonnePossible = laGrille.intersection(colonnePossible)
                colonnePossible.subtract(mecanisme.grilleRed)
                colonnePossible.subtract(mecanisme.grilleYellow)
                colonnePossible.subtract(Set(grilleImpossible))
                
                if let exist = colonnePossible.first {
                    result.append(exist)
                    print(result)
                }
            }
        }
        for solution in result {
            
            resultat = solution
            if (resultat != 0 && ( mecanisme.grilleYellow.contains(resultat - 7) || mecanisme.grilleRed.contains(resultat - 7))) || resultat <= 7 {
                
                colonne = colonnePlayed(caseGrille: resultat)
                
            }
        }
        print("jouer colonne4:\(colonne)")
        return colonne
    }
    
    // *****************DEFENSE******************************************
    
    
    
    
    
    //Fonction IA play
    func iAPlay () -> Int {
        return 0
    }
}


