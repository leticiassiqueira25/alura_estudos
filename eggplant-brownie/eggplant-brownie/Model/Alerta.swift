//
//  Alerta.swift
//  eggplant-brownie
//
//  Created by Leticia Sousa Siqueira on 22/12/20.
//  Copyright © 2020 Leticia Sousa Siqueira. All rights reserved.
//

import UIKit

class Alerta {
    
    //controler foi criado pois o present só pode ser chamado em UIViewController
    let controller: UIViewController
    
    init(controller: UIViewController) {
        self.controller = controller
    }
    
    //titulo: String = "Atenção" é um valor padrão caso a pessoa não queira passar um titulo
    func exibe(titulo: String = "Atenção", mensagem: String) {
        //Cria a mensagem
        let alerta  = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        //Cria o botão
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        //Adiciona o botão ao UIAlertController
        alerta.addAction(ok)
        //Apresenta na tela
        controller.present(alerta, animated: true, completion: nil)
    }
    
}
