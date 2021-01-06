//
//  Refeicao.swift
//  eggplant-brownie
//
//  Created by Leticia Sousa Siqueira on 16/12/20.
//  Copyright © 2020 Leticia Sousa Siqueira. All rights reserved.
//

import UIKit

//NSCoding serve para converter um arquivo em bytes e para desconverter também
class Refeicao: NSObject, NSCoding {
    
    //MARK: - Atributos
    
    let nome: String
    let felicidade: Int
    var itens: Array<Item> = []
    
    //[Item] = [] irá aceitar instanciar uma refeicao com o item vazio, ou seja, sem passar itens
    init(nome: String, felicidade: Int, itens: [Item] = []){
        self.nome = nome
        self.felicidade = felicidade
        self.itens = itens
    }
    
    // MARK: - NSCoding
    
    //Codificando os valores das variáveis
    func encode(with aCoder: NSCoder) {
        aCoder.encode(nome, forKey: "nome") //forKey será utilizando na hora da desconverter/deserealizar
        aCoder.encode(felicidade, forKey: "felicidade")
        aCoder.encode(itens, forKey: "itens")
    }
    
    required init?(coder aDecoder: NSCoder) {
        nome = aDecoder.decodeObject(forKey: "nome") as! String
        felicidade = aDecoder.decodeInteger(forKey: "felicidade")
        itens = aDecoder.decodeObject(forKey: "itens") as! Array<Item>
    }
    
    // MARK: - Métodos
    
    func totalDeCalorias() -> Double{
        var total = 0.0
        
        for item in itens{
            total += item.calorias
        }
        
        return total
    }
    
    func detalhes() -> String{
        //Mensagem que será apresentada no alert contendo a felicidade e os ingredientes
        var mensagem = "Felicidade: \(felicidade)"
        
        //For para obter todos os itens utilizados naquela refeicao
        for item in itens{
            mensagem += ", \(item.nome) - calorias: \(item.calorias)"
        }
        
        return mensagem
    }

}
