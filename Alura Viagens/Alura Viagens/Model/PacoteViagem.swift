//
//  PacoteViagem.swift
//  Alura Viagens
//
//  Created by Leticia Sousa Siqueira on 04/01/21.
//  Copyright © 2021 Leticia Sousa Siqueira. All rights reserved.
//

import UIKit

class PacoteViagem: NSObject {
    
    let nomeDoHotel:String
    let descricao:String
    let dataViagem:String
    let viagem:Viagem
    
    init(nomeDoHotel: String, descricao: String, dataViagem: String, viagem:Viagem) {
        self.nomeDoHotel = nomeDoHotel
        self.descricao = descricao
        self.dataViagem = dataViagem
        self.viagem = viagem
    }
}
