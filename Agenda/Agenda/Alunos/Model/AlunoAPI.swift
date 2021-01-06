//
//  AlunoAPI.swift
//  Agenda
//
//  Created by Leticia Sousa Siqueira on 27/12/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit
import Alamofire

class AlunoAPI: NSObject {
    
    // MARK: - Atributos
    lazy var url:String = {
        guard let url = Configuracao().getUrlPadrao() else { return ""}
        
        return url
    }()
    
    // MARK: - GET
    
    //Recupera os alunos salvos no servidor. Completion significa que só vai dar o retorno após fazer os passos anteriores
    func recuperaAlunos(completion:@escaping() -> Void) {
        Alamofire.request(url + "api/aluno", method: .get).responseJSON { (response) in
            switch response.result {
            case .success:
                //Primeiro precisamos converter os valores para um dicionário. Quando o servidor nos retorna o JSON com os alunos, precisamos transformá-lo (serializar) em um objeto para utilizar no nosso app. Como o servidor retorna uma variável do tipo "Any", ou seja, sem tipagem, o primeiro passo é converter o retorno para algum tipo de objeto para conseguirmos extrair seus valores. 
                if let resposta = response.result.value as? Dictionary<String, Any> {
                    self.serializaAlunos(resposta)
                    completion()
                }
                break
            case .failure:
                print(response.error!)
                completion()
                break
            }
        }
    }
    
    func recuperaUltimosAlunos(_ versao:String, completion:@escaping() -> Void) {
        Alamofire.request(url + "api/aluno/diff", method: .get, headers: ["datahora":versao]).responseJSON { (response) in
            switch response.result {
            case .success:
                print("ULTIMOS ALUNOS")
                if let resposta = response.result.value as? Dictionary<String, Any> {
                    self.serializaAlunos(resposta)
                }
                completion()
                break
            case .failure:
                print("FALHA")
                break
            }
        }
    }
    
    // MARK: - PUT

    func salvaAlunosNoServidor(parametros: Array<Dictionary<String, Any>>, completion:@escaping(_ salvo: Bool) -> Void) {
        
        guard let urlPadrao = Configuracao().getUrlPadrao() else { return }
        
        guard let url = URL(string: urlPadrao + "api/aluno/lista") else { return }
        
        var requisicao = URLRequest(url: url)
        requisicao.httpMethod = "PUT"
        //Transformando os dados em formato Data
        let json = try! JSONSerialization.data(withJSONObject: parametros, options: [])
        requisicao.httpBody = json
        //Especificando que o formato será json
        requisicao.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //Passando a requisicao configurada para o Alamofire
        Alamofire.request(requisicao).responseData { (resposta) in
            if resposta.error == nil {
                completion(true)
            } else {
                
            }
        }
        
    }
    
    // MARK: - DELETE
    
    func deletaAluno(id: String, completion:@escaping(_ apagado:Bool) -> Void) {
        Alamofire.request(url + "api/aluno/\(id)", method: .delete).responseJSON { (resposta) in
            switch resposta.result {
            case .success:
                completion(true)
                break
            case .failure:
                completion(false)
                print(resposta.result.error)
                break
            default: 
                break
            }
        }
        
    }
    
    // MARK: - Serializacao
    func serializaAlunos(_ resposta: Dictionary<String, Any>) {
        guard let listaDeAlunos = resposta["alunos"] as? Array<Dictionary<String, Any>> else { return }
        
        for dicionarioDeAluno in listaDeAlunos {
            guard let status = dicionarioDeAluno["desativado"] as? Bool else { return }
            if status {
                guard let idDoAluno = dicionarioDeAluno["id"] as? String else { return }
                guard let UUIDAluno = UUID(uuidString: idDoAluno) else { return }
                if let aluno = AlunoDAO().recuperaAluno().filter({ $0.id  == UUIDAluno }).first{
                    AlunoDAO().deletaAluno(aluno: aluno)
                }
            } else {
                 AlunoDAO().salvaAluno(dicionarioDeAluno: dicionarioDeAluno)
            }
           
        }
        
        AlunoUserDefaults().salvaVersao(resposta)
    }
    
}
