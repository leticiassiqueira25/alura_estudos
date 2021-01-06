//
//  RefeicaoDao.swift
//  eggplant-brownie
//
//  Created by Leticia Sousa Siqueira on 27/12/20.
//  Copyright © 2020 Leticia Sousa Siqueira. All rights reserved.
//

//DAO - Data Acess Object (Classe para persistencia de dados)

import Foundation

class RefeicaoDao{
    
    func save(_ refeicoes: [Refeicao]) {
        
        guard let caminho = recuperaCaminho() else {
            return
        }
        
        //Passamos quais informacoes queremos salvar, nessa caso será a lista de refeicoes
        do{
            let dados = try NSKeyedArchiver.archivedData(withRootObject: refeicoes, requiringSecureCoding: false)
            
            //Recuperamos os dados na variavel anterior agora vamos escreve-los no diretorio setado na variável caminho
            try dados.write(to: caminho)
        } catch {
            //Descricao do erro
            print(error.localizedDescription)
        }
        
    }
    
    func recupera() -> [Refeicao] {
        guard let caminho = recuperaCaminho() else {
            return []
        }
        
        //Pegar os dados de volta
        do {
            let dados = try Data(contentsOf: caminho)
            guard let refeicoesSalva = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(dados) as? Array<Refeicao> else {
                return [] 
            }
            
            return refeicoesSalva
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func recuperaCaminho() -> URL? {
        //Diretorio que irá salvar os arquivos (no documents de cada usuário)
        guard let diretorio = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        //Nome da pasta que estará no diretório documents
        let caminho = diretorio.appendingPathComponent("refeicao")
        
        return caminho
    }
    
}
