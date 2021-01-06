//
//  RemoveRefeicaoViewController.swift
//  eggplant-brownie
//
//  Created by Leticia Sousa Siqueira on 23/12/20.
//  Copyright © 2020 Leticia Sousa Siqueira. All rights reserved.
//

import UIKit

class RemoveRefeicaoViewController {
    
    let controller: UIViewController
    
    init(controller: UIViewController){
        self.controller = controller
    }
    
    //handler: estaremos mandando a responsabilidade do metodo de volta para o ViewController, utilizamos o Void quando nao tem retorno. O @escaping significa que esse handler só será executado quando houver uma ação do usuário
    func exibe(_ refeicao: Refeicao, handler: @escaping (UIAlertAction) -> Void) {
        //Controlador de alerta
        let alerta = UIAlertController(title: refeicao.nome, message: refeicao.detalhes(), preferredStyle: .alert)
        
        //Botao para fechar o alerta
        let botaoCancelar = UIAlertAction(title: "cancelar", style: .cancel)
        alerta.addAction(botaoCancelar)
        
        //Botao remover (Closure é quando passamos uma funcao dentro de outra funcao, nesse caso estamos passando a outra funcao a partir do handler, sempre que eu quero utilizar uma variavel da classe dentro de uma closure é preciso utilizar a palavra self)
        let botaoRemover = UIAlertAction(title: "remover", style: .destructive, handler: handler)
        alerta.addAction(botaoRemover)
        
        //Iremos apresentar essa alerta criado anteriormente
        controller.present(alerta, animated: true, completion: nil)
    }
}
