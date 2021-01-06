//
//  ItemDao.swift
//  eggplant-brownie
//
//  Created by Leticia Sousa Siqueira on 27/12/20.
//  Copyright © 2020 Leticia Sousa Siqueira. All rights reserved.
//

import Foundation

class ItemDao {
    
    func save(_ itens: [Item]) {
        do {
            let dados = try NSKeyedArchiver.archivedData(withRootObject: itens, requiringSecureCoding: false)
            
            guard let caminho = recuperaDiretorio() else {
                return
            }
            
            try dados.write(to: caminho)
        } catch{
            print(error.localizedDescription)
        }
    }
    
    func recupera() -> [Item] {
        do {
            guard let diretorio = recuperaDiretorio() else { return [] }
            
            //Recuperar os dados salvos no arquivo
            let dados = try Data(contentsOf: diretorio)
            
            //Deserealizar os dados
            let  itensSalvos = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(dados) as! [Item]
            
            return itensSalvos
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func recuperaDiretorio() -> URL? {
        //Diretorio que irá salvar os arquivos (no documents de cada usuário)
        guard let diretorio = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        //Nome da pasta que estará no diretório documents
        let caminho = diretorio.appendingPathComponent("itens")
        
        return caminho
    }
    
}
