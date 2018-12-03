//
//  Mecanisme.swift
//  Puissance4
//
//  Created by ludo iMac on 27/11/2018.
//  Copyright © 2018 ludo iMac. All rights reserved.
//

import UIKit

struct Mecanisme {
    
    
    //  f-  36  37  38  39  40  41  42
    //  e-  29  30  31  32  33  34  35
    //  d-  22  23  24  25  26  27  28
    //  c-  15  16  17  18  19  20  21
    //  b-  8   9   10  11  12  13  14
    //  a-  1   2   3   4   5   6   7
    //      0   1   2   3   4   5   6
    
    // Grille de jeux 0 = vide / R = jeton rouge / J = jeton jaune
    
    var grilleDeJeux: [[String]] = [[],[],[],[],[],[],[]]
    var grilleVide: [String] = []
    var coordonnées: [Int:String] = [:]
    
    var grilleRed:Set<Int> = []
    var grilleYellow:Set<Int> = []
    
    let configurationGagnante = [[1,8,15,22].sorted(),[29,8,15,22].sorted(),[36,29,15,22].sorted(),[2,9,16,23].sorted(),[30,9,16,23].sorted(),[37,30,16,23].sorted(),[3,10,17,24].sorted(),[31,10,17,24].sorted(),[31,38,17,24].sorted(),[4,11,18,25].sorted(),[32,11,18,25].sorted(),[32,39,18,25].sorted(),[5,12,19,26].sorted(),[33,12,19,26].sorted(),[33,40,19,26].sorted(),[6,13,20,27].sorted(),[34,13,20,27].sorted(),[34,41,20,27].sorted(),[7,14,21,28].sorted(),[35,14,21,28].sorted(),[35,42,21,28].sorted(),[1,2,3,4].sorted(),[5,2,3,4].sorted(),[5,6,3,4].sorted(),[5,6,7,4].sorted(),[8,9,10,11].sorted(),[12,9,10,11].sorted(),[12,13,10,11].sorted(),[12,13,14,11].sorted(),[15,16,17,18].sorted(),[19,16,17,18].sorted(),[19,20,17,18].sorted(),[19,20,21,18].sorted(),[22,23,24,25].sorted(),[26,23,24,25].sorted(),[26,27,24,25].sorted(),[26,27,28,25].sorted(),[29,30,31,32].sorted(),[33,30,31,32].sorted(),[33,34,31,32].sorted(),[33,34,35,32].sorted(),[36,37,38,39].sorted(),[40,37,38,39].sorted(),[40,41,38,39].sorted(),[40,41,42,39].sorted(),[15,23,31,39].sorted(),[8,16,24,32].sorted(),[16,24,32,40].sorted(),[1,9,17,25].sorted(),[33,9,17,25].sorted(),[33,41,17,25].sorted(),[2,10,18,26].sorted(),[34,10,18,26].sorted(),[34,42,18,26].sorted(),[3,11,19,27].sorted(),[35,11,19,27].sorted(),[4,12,20,28].sorted(),[22,16,10,4].sorted(),[5,11,17,23].sorted(),[29,11,17,23].sorted(),[6,12,18,24].sorted(),[30,12,18,24].sorted(),[30,36,18,24].sorted(),[7,13,19,25].sorted(),[31,13,19,25].sorted(),[31,37,19,25].sorted(),[14,20,26,32].sorted(),[38,20,26,32].sorted(),[21,27,33,39].sorted()]
    
    
    
    
    
    
    
    
    
    mutating func ajouterJeton (jeton: String, colonne: Int) {
        
        grilleDeJeux[colonne].append(jeton)
        
        
    }
    
    // Donne toute les combinaison possibel en fonction ce qui a été joué
    
    func combinations<T>(source: [T], takenBy : Int) -> [[T]] {
        if(source.count == takenBy) {
            return [source]
        }
        
        if(source.isEmpty) {
            return []
        }
        
        if(takenBy == 0) {
            return []
        }
        
        if(takenBy == 1) {
            return source.map { [$0] }
        }
        
        var result : [[T]] = []
        
        let rest = Array(source.suffix(from: 1))
        let subCombos = combinations(source: rest, takenBy: takenBy - 1)
        result += subCombos.map { [source[0]] + $0 }
        result += combinations(source: rest, takenBy: takenBy)
        return result
    }
    // Fonction  test victoire
    func testVictoire (grilleJeton: Set<Int>) -> Bool {
        var isVictorious = false
        let grille = Array(grilleJeton)
        let resultat = combinations(source: grille, takenBy: 4)
        print("les conf gagnante possible:\(resultat)")
        
        for solution in resultat {
            
            if configurationGagnante.contains(solution.sorted()) {
                isVictorious = true
            }
        }
        print("victoire:\(isVictorious)")
        return isVictorious
    }
}




