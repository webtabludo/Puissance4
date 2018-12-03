//
//  BrainIA.swift
//  Puissance4
//
//  Created by ludo iMac on 27/11/2018.
//  Copyright © 2018 ludo iMac. All rights reserved.
//

import UIKit

extension Array where Element: Equatable {
    func contains(array: [Element]) -> Bool {
        for item in array {
            if !self.contains(item) { return false }
        }
        return true
    }
}
//  f-    +12    +14    +16
//  e-       +6  +7  +8
//  d-   -2  -1   X  +1   +2
//  c-       -8  -7  -6
//  b-    -16    -14    -12
//  a-
//      0   1   2   3   4   5   6

struct BrainIA {
    var laGrille:Set<Int> = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42]
    var leftCenter = false
    var rightCenter = false
  
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
    func attaqueColonne (red: Set<Int>, yellow: Set<Int>) -> Int {
        var colonne = 3
        var result:[Int] = []
        for x in yellow {
            var colonnePossible:Set<Int> = [(x + 7)]
            
            colonnePossible = laGrille.intersection(colonnePossible)
            colonnePossible.subtract(red)
            colonnePossible.subtract(yellow)
            if let exist = colonnePossible.first {
                result.append(exist)
            }
        }
        
        for resultat in result {
            let combinaison = [resultat] + Array(yellow)
            let solution1:[Int] = [resultat,resultat + 7,resultat + 14,resultat + 21]
            let solution2:[Int] = [resultat,resultat + 7,resultat + 14,resultat - 7]
            let solution3:[Int] = [resultat,resultat + 7,resultat - 7,resultat - 14]
            let solution4:[Int] = [resultat,resultat - 7,resultat - 14,resultat - 21]
            if combinaison.sorted().contains(array: (solution1.sorted())) ||
                combinaison.sorted().contains(array: (solution2.sorted())) ||
                combinaison.sorted().contains(array: (solution3.sorted())) ||
                combinaison.sorted().contains(array: (solution4.sorted())) {
                colonne = colonnePlayed(caseGrille: resultat)
            } else {
                colonne = 3
            }
            
        }
        print("jouer ATK colonne:\(colonne)")
        return colonne
    }
    
    //fonction test est ce que adverssaire a 3 jeton aligner et contrer
    
    // Ligne
    func attaqueLigne (red: Set<Int>, yellow: Set<Int>) -> Int{
        var colonne = 3
        
        var result:[Int] = []
        var resultat = 0
        let limiteGauche = [1,8,15,22,29,36]
        let limiteDroite = [7,14,21,28,35,42]
        
        for x in yellow {
            if limiteGauche.contains(x) {
                
                var lignePossible:Set<Int> = [(x + 1)]

                lignePossible = laGrille.intersection(lignePossible)
                lignePossible.subtract(red)
                lignePossible.subtract(yellow)
                
                result.append(contentsOf: Array(lignePossible))

            } else if limiteDroite.contains(x) {
                
                var lignePossible:Set<Int> = [(x - 1)]
                lignePossible = laGrille.intersection(lignePossible)
                lignePossible.subtract(red)
                lignePossible.subtract(yellow)
                
                result.append(contentsOf: Array(lignePossible))

            } else {
                
                var lignePossible:Set<Int> = [(x - 1), (x + 1)]
                
                
                lignePossible = laGrille.intersection(lignePossible)
                lignePossible.subtract(red)
                lignePossible.subtract(yellow)
                result.append(contentsOf: Array(lignePossible))

            }
            let duplicates = Array(Set(result.filter({ (i: Int) in result.filter({ $0 == i }).count > 1})))
            if let exist = duplicates.first {
                resultat = exist
                if (resultat != 0 && ( yellow.contains(resultat - 7) || red.contains(resultat - 7))) || resultat <= 7 {
                    
                    colonne = colonnePlayed(caseGrille: resultat)
                }
            } else {
                for resultat in result{
                    let combinaison = [resultat] + Array(yellow)
                    
                    let solution1:[Int] = [resultat,resultat + 1,resultat + 2,resultat + 3]
                    let solution2:[Int] = [resultat,resultat - 1,resultat + 1,resultat + 2]
                    let solution3:[Int] = [resultat,resultat - 1,resultat - 2,resultat + 1]
                    let solution4:[Int] = [resultat,resultat - 1,resultat - 2,resultat - 3]
                    
                    if combinaison.sorted().contains(array: (solution1.sorted())) ||
                        combinaison.sorted().contains(array: (solution2.sorted())) ||
                        combinaison.sorted().contains(array: (solution3.sorted())) ||
                        combinaison.sorted().contains(array: (solution4.sorted())) {
                        if (resultat != 0 && ( yellow.contains(resultat - 7) || red.contains(resultat - 7))) || resultat <= 7 {
                            
                            colonne = colonnePlayed(caseGrille: resultat)
                        }
                    } else {
                        colonne = 3
                    }
                }
            }
        }
            
        print("jouer ATK ligne:\(colonne)")
        return colonne
    }
    
    //fonction test est ce que adverssaire a 3 jeton aligner et contrer
    
    // Diagonale Gauche
    func attaqueDiagonaleGauche (red: Set<Int>, yellow: Set<Int>) -> Int{
        var colonne = 3
        var result:[Int] = []
        
        var resultat = 0
        let grilleImpossible = [1,2,3,8,9,15,42,41,35,40,34,28]
        for x in yellow {
            if !grilleImpossible.contains(x) {
                var colonnePossible:Set<Int> = [(x - 6),(x + 6)]
                
                colonnePossible = laGrille.intersection(colonnePossible)
                colonnePossible.subtract(red)
                colonnePossible.subtract(yellow)
                colonnePossible.subtract(Set(grilleImpossible))

                result.append(contentsOf: Array(colonnePossible))
                
            }
        }

        let duplicates = Array(Set(result.filter({ (i: Int) in result.filter({ $0 == i }).count > 1})))
        if let exist = duplicates.first {
            resultat = exist
            if (resultat != 0 && ( yellow.contains(resultat - 7) || red.contains(resultat - 7))) || resultat <= 7 {
                
                colonne = colonnePlayed(caseGrille: resultat)
            }
            
        } else {
            for resultat in result {
                let combinaison = [resultat] + Array(yellow)
                
                let solution1:[Int] = [resultat,resultat + 6,resultat + 12,resultat + 18]
                let solution2:[Int] = [resultat,resultat - 6,resultat + 6,resultat + 12]
                let solution3:[Int] = [resultat,resultat - 6,resultat - 12,resultat + 6]
                let solution4:[Int] = [resultat,resultat - 6,resultat - 12,resultat - 18]
                
                if combinaison.sorted().contains(array: (solution1.sorted())) ||
                    combinaison.sorted().contains(array: (solution2.sorted())) ||
                    combinaison.sorted().contains(array: (solution3.sorted())) ||
                    combinaison.sorted().contains(array: (solution4.sorted())) {
                    if (resultat != 0 && ( yellow.contains(resultat - 7) || red.contains(resultat - 7))) || resultat <= 7 {
                        
                        colonne = colonnePlayed(caseGrille: resultat)
                    }
                } else {
                    colonne = 3
                }
            }
        }
        print("jouer ATK diagonale gauche:\(colonne)")
        return colonne
    }
    
    
    // Diagonale Droite
    func attaqueDiagonaleDroite (red: Set<Int>, yellow: Set<Int>) -> Int{
        var colonne = 3
        var result:[Int] = []
        
        var resultat = 0
        let grilleImpossible = [36,29,37,22,30,38,7,6,14,5,13,21]
        for x in yellow {
            if !grilleImpossible.contains(x) {
                var colonnePossible:Set<Int> = [(x - 8),(x + 8)]
                
                colonnePossible = laGrille.intersection(colonnePossible)
                colonnePossible.subtract(red)
                colonnePossible.subtract(yellow)
                colonnePossible.subtract(Set(grilleImpossible))

                result.append(contentsOf: Array(colonnePossible))
                
            }
        }

        let duplicates = Array(Set(result.filter({ (i: Int) in result.filter({ $0 == i }).count > 1})))
        if let exist = duplicates.first {
            resultat = exist
            if (resultat != 0 && ( yellow.contains(resultat - 7) || red.contains(resultat - 7))) || resultat <= 7 {
                
                colonne = colonnePlayed(caseGrille: resultat)
            }
        } else {
            for resultat in result {
                let combinaison = [resultat] + Array(yellow)
                
                let solution1:[Int] = [resultat,resultat + 8,resultat + 16,resultat + 24]
                let solution2:[Int] = [resultat,resultat - 8,resultat + 8,resultat + 16]
                let solution3:[Int] = [resultat,resultat - 8,resultat - 16,resultat + 8]
                let solution4:[Int] = [resultat,resultat - 8,resultat - 16,resultat - 24]
                
                if combinaison.sorted().contains(array: (solution1.sorted())) ||
                    combinaison.sorted().contains(array: (solution2.sorted())) ||
                    combinaison.sorted().contains(array: (solution3.sorted())) ||
                    combinaison.sorted().contains(array: (solution4.sorted())) {
                    if (resultat != 0 && ( yellow.contains(resultat - 7) || red.contains(resultat - 7))) || resultat <= 7 {
                        
                        colonne = colonnePlayed(caseGrille: resultat)
                    }
                } else {
                    colonne = 3
                }
            }
        }
        print("jouer ATK diagonale droite:\(colonne)")
        return colonne
    }
    
    // *****************DEFENSE******************************************
    
    //fonction Défense dès que 3 jetons aligner
    

    // Colonne
    func defenseColonne (red: Set<Int>, yellow: Set<Int>) -> Int {
        var colonne = 3
        var result:[Int] = []
        for x in red {
            var colonnePossible:Set<Int> = [(x + 7)]
            
            colonnePossible = laGrille.intersection(colonnePossible)
            colonnePossible.subtract(red)
            colonnePossible.subtract(yellow)
            if let exist = colonnePossible.first {
                result.append(exist)
            }
        }
        
        for resultat in result {
            let combinaison = [resultat] + Array(red)
            let solution1:[Int] = [resultat,resultat + 7,resultat + 14,resultat + 21]
            let solution2:[Int] = [resultat,resultat + 7,resultat + 14,resultat - 7]
            let solution3:[Int] = [resultat,resultat + 7,resultat - 7,resultat - 14]
            let solution4:[Int] = [resultat,resultat - 7,resultat - 14,resultat - 21]
            if combinaison.sorted().contains(array: (solution1.sorted())) ||
                combinaison.sorted().contains(array: (solution2.sorted())) ||
                combinaison.sorted().contains(array: (solution3.sorted())) ||
                combinaison.sorted().contains(array: (solution4.sorted())) {
                colonne = colonnePlayed(caseGrille: resultat)
            } else {
                colonne = 3
            }
            
        }
        print("jouer DEF colonne:\(colonne)")
        return colonne
    }
    
    //fonction test est ce que adverssaire a 3 jeton aligner et contrer
    
    // Ligne
    func defenseLigne (red: Set<Int>, yellow: Set<Int>) -> Int{
        var colonne = 3
        
        var result:[Int] = []
        var resultat = 0
        let limiteGauche = [1,8,15,22,29,36]
        let limiteDroite = [7,14,21,28,35,42]
        
        for x in red {
            if limiteGauche.contains(x) {
                
                var lignePossible:Set<Int> = [(x + 1)]
                
                
                lignePossible = laGrille.intersection(lignePossible)
                lignePossible.subtract(red)
                lignePossible.subtract(yellow)
                
                result.append(contentsOf: Array(lignePossible))
            } else if limiteDroite.contains(x) {
                
                var lignePossible:Set<Int> = [(x - 1)]
                
                lignePossible = laGrille.intersection(lignePossible)
                lignePossible.subtract(red)
                lignePossible.subtract(yellow)
                
                result.append(contentsOf: Array(lignePossible))
            } else {
                
                var lignePossible:Set<Int> = [(x - 1), (x + 1)]
                
                
                lignePossible = laGrille.intersection(lignePossible)
                lignePossible.subtract(red)
                lignePossible.subtract(yellow)
                result.append(contentsOf: Array(lignePossible))
            
        }
        let duplicates = Array(Set(result.filter({ (i: Int) in result.filter({ $0 == i }).count > 1})))
        if let exist = duplicates.first {
            resultat = exist
            if (resultat != 0 && ( yellow.contains(resultat - 7) || red.contains(resultat - 7))) || resultat <= 7 {
                
                colonne = colonnePlayed(caseGrille: resultat)
            }
        } else {
            for resultat in result{
                let combinaison = [resultat] + Array(red)

                let solution1:[Int] = [resultat,resultat + 1,resultat + 2,resultat + 3]
                let solution2:[Int] = [resultat,resultat - 1,resultat + 1,resultat + 2]
                let solution3:[Int] = [resultat,resultat - 1,resultat - 2,resultat + 1]
                let solution4:[Int] = [resultat,resultat - 1,resultat - 2,resultat - 3]
                
                if combinaison.sorted().contains(array: (solution1.sorted())) ||
                    combinaison.sorted().contains(array: (solution2.sorted())) ||
                    combinaison.sorted().contains(array: (solution3.sorted())) ||
                    combinaison.sorted().contains(array: (solution4.sorted())) {
                    if (resultat != 0 && ( yellow.contains(resultat - 7) || red.contains(resultat - 7))) || resultat <= 7 {
                        
                        colonne = colonnePlayed(caseGrille: resultat)
                    }
                } else {
                    colonne = 3
                }
            }
        }
    }
        print("jouer DEF ligne:\(colonne)")
        return colonne
    }

    //fonction test est ce que adverssaire a 3 jeton aligner et contrer
    
    // Diagonale Gauche
    func defenseDiagonaleGauche (red: Set<Int>, yellow: Set<Int>) -> Int{
        var colonne = 3
        var result:[Int] = []
        
        var resultat = 0
        let grilleImpossible = [1,2,3,8,9,15,42,41,35,40,34,28]
        for x in red {
            if !grilleImpossible.contains(x) {
                var colonnePossible:Set<Int> = [(x - 6),(x + 6)]
                
                colonnePossible = laGrille.intersection(colonnePossible)
                colonnePossible.subtract(red)
                colonnePossible.subtract(yellow)
                colonnePossible.subtract(Set(grilleImpossible))
                
                result.append(contentsOf: Array(colonnePossible))
                
            }
        }
       
        let duplicates = Array(Set(result.filter({ (i: Int) in result.filter({ $0 == i }).count > 1})))
        if let exist = duplicates.first {
            resultat = exist
            if (resultat != 0 && ( yellow.contains(resultat - 7) || red.contains(resultat - 7))) || resultat <= 7 {
                
                colonne = colonnePlayed(caseGrille: resultat)
            }

        } else {
        for resultat in result {
                let combinaison = [resultat] + Array(red)
         
                let solution1:[Int] = [resultat,resultat + 6,resultat + 12,resultat + 18]
                let solution2:[Int] = [resultat,resultat - 6,resultat + 6,resultat + 12]
                let solution3:[Int] = [resultat,resultat - 6,resultat - 12,resultat + 6]
                let solution4:[Int] = [resultat,resultat - 6,resultat - 12,resultat - 18]
                
                if combinaison.sorted().contains(array: (solution1.sorted())) ||
                    combinaison.sorted().contains(array: (solution2.sorted())) ||
                    combinaison.sorted().contains(array: (solution3.sorted())) ||
                    combinaison.sorted().contains(array: (solution4.sorted())) {
                    if (resultat != 0 && ( yellow.contains(resultat - 7) || red.contains(resultat - 7))) || resultat <= 7 {
                        
                        colonne = colonnePlayed(caseGrille: resultat)
                    }
                } else {
                    colonne = 3
                }
            }
        }
        print("jouer DEF diagonale gauche:\(colonne)")
        return colonne
    }
    
    
    // Diagonale Droite
    func defenseDiagonaleDroite (red: Set<Int>, yellow: Set<Int>) -> Int{
        var colonne = 3
        var result:[Int] = []
        
        var resultat = 0
        let grilleImpossible = [36,29,37,22,30,38,7,6,14,5,13,21]
        for x in red {
            if !grilleImpossible.contains(x) {
                var colonnePossible:Set<Int> = [(x - 8),(x + 8)]
                
                colonnePossible = laGrille.intersection(colonnePossible)
                colonnePossible.subtract(red)
                colonnePossible.subtract(yellow)
                colonnePossible.subtract(Set(grilleImpossible))

                result.append(contentsOf: Array(colonnePossible))
                
            }
        }

        let duplicates = Array(Set(result.filter({ (i: Int) in result.filter({ $0 == i }).count > 1})))
        if let exist = duplicates.first {
            resultat = exist
            if (resultat != 0 && ( yellow.contains(resultat - 7) || red.contains(resultat - 7))) || resultat <= 7 {
                
                colonne = colonnePlayed(caseGrille: resultat)
            }
        } else {
        for resultat in result {
                let combinaison = [resultat] + Array(red)
              
                let solution1:[Int] = [resultat,resultat + 8,resultat + 16,resultat + 24]
                let solution2:[Int] = [resultat,resultat - 8,resultat + 8,resultat + 16]
                let solution3:[Int] = [resultat,resultat - 8,resultat - 16,resultat + 8]
                let solution4:[Int] = [resultat,resultat - 8,resultat - 16,resultat - 24]
                
                if combinaison.sorted().contains(array: (solution1.sorted())) ||
                    combinaison.sorted().contains(array: (solution2.sorted())) ||
                    combinaison.sorted().contains(array: (solution3.sorted())) ||
                    combinaison.sorted().contains(array: (solution4.sorted())) {
                    if (resultat != 0 && ( yellow.contains(resultat - 7) || red.contains(resultat - 7))) || resultat <= 7 {
                        
                        colonne = colonnePlayed(caseGrille: resultat)
                    }
                } else {
                    colonne = 3
                }
            }
        }
        print("jouer DEF diagonale droite:\(colonne)")
        return colonne
    }
    
    
    
    //Fonction IA play
    mutating func iAPlay (red: Set<Int>, yellow: Set<Int>,commence: Bool) -> Int {
        var resultat = 13
        if commence == true {
        if defenseColonne(red: red, yellow: yellow) != 3 {
            resultat = defenseColonne(red: red, yellow: yellow)
            print("resultat1:\(resultat)")

        } else if defenseLigne(red: red, yellow: yellow) != 3 {
            resultat = defenseLigne(red: red, yellow: yellow)
            print("resultat2:\(resultat)")

        } else if defenseDiagonaleDroite(red: red, yellow: yellow) != 3 {
            resultat = defenseDiagonaleDroite(red: red, yellow: yellow)
            print("resultat3:\(resultat)")

        } else if defenseDiagonaleGauche(red: red, yellow: yellow) != 3 {
            resultat = defenseDiagonaleGauche(red: red, yellow: yellow)
            print("resultat4:\(resultat)")

        } else if attaqueColonne(red: red, yellow: yellow) != 3 {
            resultat = attaqueColonne(red: red, yellow: yellow)
            print("resultat5:\(resultat)")

        } else if attaqueLigne(red: red, yellow: yellow) != 3 {
            resultat = attaqueLigne(red: red, yellow: yellow)
            print("resultat6:\(resultat)")

        } else if attaqueDiagonaleDroite(red: red, yellow: yellow) != 3 {
            resultat = attaqueDiagonaleDroite(red: red, yellow: yellow)
            print("resultat7:\(resultat)")

        } else if attaqueDiagonaleGauche(red: red, yellow: yellow) != 3 {
            resultat = attaqueDiagonaleGauche(red: red, yellow: yellow)
            print("resultat8:\(resultat)")

        } else {
            if !red.contains(39) && !yellow.contains(39) && leftCenter == false && rightCenter == false {
            resultat = 3
                leftCenter = true
                rightCenter = false
            print("resultat9:\(resultat)")
            } else if !red.contains(38) && !yellow.contains(38) && leftCenter == true && rightCenter == false {
                resultat = 2
                leftCenter = false
                rightCenter = true
                print("resultat9:\(resultat)")
            } else if !red.contains(40) && !yellow.contains(40) && leftCenter == false && rightCenter == true {
                resultat = 4
                leftCenter = false
                rightCenter = false
                print("resultat9:\(resultat)")
            } else if !red.contains(37) && !yellow.contains(37) {
                resultat = 1
                print("resultat9:\(resultat)")
            } else if !red.contains(41) && !yellow.contains(41) {
                resultat = 5
                print("resultat9:\(resultat)")
            } else if !red.contains(36) && !yellow.contains(36) {
                resultat = 0
                print("resultat9:\(resultat)")
            } else if !red.contains(42) && !yellow.contains(42) {
                resultat = 6
                print("resultat9:\(resultat)")
            }
            
        }
        } else if commence == false {
            resultat = 2
        }
        return resultat
    }
}


