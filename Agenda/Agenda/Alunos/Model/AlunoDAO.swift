//
//  AlunoDAO.swift
//  Agenda
//
//  Created by Leticia Sousa Siqueira on 28/12/20.
//  Copyright © 2020 Alura. All rights reserved.
//

import UIKit
import CoreData

class AlunoDAO: NSObject {
    
    var gerenciadorDeResultados:NSFetchedResultsController<Aluno>?
    var contexto:NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func recuperaAluno() -> Array<Aluno> {
        let pesquisaAluno:NSFetchRequest<Aluno> = Aluno.fetchRequest()
        let ordenaPorNome = NSSortDescriptor(key: "nome", ascending: true)
        pesquisaAluno.sortDescriptors = [ordenaPorNome]
        
        gerenciadorDeResultados = NSFetchedResultsController(fetchRequest: pesquisaAluno, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try gerenciadorDeResultados?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
        //fetcheObjects retorna a lista do CoreData
        guard let listaDeAlunos = gerenciadorDeResultados?.fetchedObjects else { return [] }
        
        return listaDeAlunos
    }
    
    func salvaAluno(dicionarioDeAluno:Dictionary<String, Any>) {
        var aluno:NSManagedObject?
        guard let id = UUID(uuidString: dicionarioDeAluno["id"] as! String) else { return }
        
        //Serve como um for, vai percorrer todos os alunos que estão salvos localmente para identificar se o id já existe ou não
        let alunos = recuperaAluno().filter() { $0.id == id }
        
        //Se ele encontrou um aluno com esse mesmo id é porque ele já existe, então será criado
        if alunos.count > 0 {
            guard let alunoEncontrado = alunos.first else { return }
            aluno = alunoEncontrado
        } else {
            let entidade = NSEntityDescription.entity(forEntityName: "Aluno", in: contexto)
            aluno = NSManagedObject(entity: entidade!, insertInto: contexto)
        }
        
        aluno?.setValue(id, forKey: "id")
        aluno?.setValue(dicionarioDeAluno["nome"] as? String, forKey: "nome")
        aluno?.setValue(dicionarioDeAluno["endereco"] as? String, forKey: "endereco")
        aluno?.setValue(dicionarioDeAluno["telefone"] as? String, forKey: "telefone")
        aluno?.setValue(dicionarioDeAluno["site"] as? String, forKey: "site")
        aluno?.setValue(dicionarioDeAluno["sincronizado"] as? Bool, forKey: "sincronizado")
        
        guard let nota = dicionarioDeAluno["nota"] else { return }
        
        if (nota is String) {
            aluno?.setValue((dicionarioDeAluno["nota"] as! NSString).doubleValue, forKey: "nota")
        } else {
            //converte para String
            let conversaoDeNota = String(describing: nota)
            aluno?.setValue((conversaoDeNota as NSString).doubleValue, forKey: "nota")
        }
    
        atualizaContexto()

    }
    
    func deletaAluno(aluno: Aluno) {
        contexto.delete(aluno)
        atualizaContexto()
    }
    
    func atualizaContexto() {
        do {
            try contexto.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
}
