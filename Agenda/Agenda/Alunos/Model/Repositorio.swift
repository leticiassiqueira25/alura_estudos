//
//  Repositorio.swift
//  Agenda
//
//  Created by Leticia Sousa Siqueira on 28/12/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit

class Repositorio: NSObject {
    
    func recuperaAlunos(completion:@escaping(_ listaDeAlaunos:Array<Aluno>) -> Void) {
        var alunos = AlunoDAO().recuperaAluno().filter({ $0.desativado == false })
        //Se eu rodei o app pela primeira vez e está vazio a lista
        if alunos.count == 0 {
            AlunoAPI().recuperaAlunos {
                alunos = AlunoDAO().recuperaAluno()
                completion(alunos)
            }
        } else {
            completion(alunos)
        }
    }
    
    func recuperaUltimosAlunos(_ versao: String, completion:@escaping() -> Void){
        AlunoAPI().recuperaUltimosAlunos(versao) {
            completion()
        }
    }
    
    func salvaAluno(aluno:Dictionary<String, Any>) {
        AlunoDAO().salvaAluno(dicionarioDeAluno: aluno)
        AlunoAPI().salvaAlunosNoServidor(parametros: [aluno]) { (salvo) in
            if salvo {
                self.atualizaAlunoSincronizado(aluno)
            }
        }
    }
    
    func deletaAluno(aluno: Aluno) {
        aluno.desativado = true
        AlunoDAO().atualizaContexto()
        guard let id = aluno.id else { return }
        
        AlunoAPI().deletaAluno(id: String(describing: id).lowercased()) { (apagado)
            in
            if apagado {
                AlunoDAO().deletaAluno(aluno: aluno)
            }
        }
        
    }
    
    func sincronizaAlunos() {
        enviaAlunosNaoSincronizados()
        sincronizaAlunosDeletados()
    }
    
    func enviaAlunosNaoSincronizados() {
        let alunos = AlunoDAO().recuperaAluno().filter({ $0.sincronizado == false })
        let listaDeParametros = criarJsonAluno(alunos)
        AlunoAPI().salvaAlunosNoServidor(parametros: listaDeParametros) { (salvo) in
            for aluno in listaDeParametros {
                self.atualizaAlunoSincronizado(aluno)
            }
        }
    }
    
    func sincronizaAlunosDeletados() {
        let alunos = AlunoDAO().recuperaAluno().filter({ $0.desativado == true })
        for aluno in alunos {
            deletaAluno(aluno: aluno)
        }
    }
    
    func criarJsonAluno(_ alunos:Array<Aluno>) -> Array<[String:Any]> {
        var listaDeParametros: Array<Dictionary<String, String>> = []
        for aluno in alunos {
            guard let id = aluno.id else { return [] }
            let parametros:Dictionary<String, String> = [
                "id": String(describing: id).lowercased(), //precisa utilizar o lowercased para o id ficar todo em minusculo
                "nome": aluno.nome ?? "", //o ?? serve para caso ele nao consiga extrair o valor irá setar "" ou seja string vazia
                "endereco": aluno.endereco ?? "",
                "telefone": aluno.telefone ?? "",
                "site": aluno.site ?? "",
                "nota": "\(aluno.nota)"
            ]
            
            listaDeParametros.append(parametros)
        }
        return listaDeParametros
    }
    
    func atualizaAlunoSincronizado(_ aluno:Dictionary<String, Any>) {
        var dicionario = aluno
        dicionario["sincronizado"] = true
        //Mudar o atributo sincronizado para verdadeiro
        AlunoDAO().salvaAluno(dicionarioDeAluno: dicionario)
    }
    
}
