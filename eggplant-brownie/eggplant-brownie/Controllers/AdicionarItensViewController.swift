//
//  AdicionarItensViewController.swift
//  eggplant-brownie
//
//  Created by Leticia Sousa Siqueira on 21/12/20.
//  Copyright © 2020 Leticia Sousa Siqueira. All rights reserved.
//

import UIKit

protocol AdicionaItensDelegate{
    func add(_ item: Item)
}



class AdicionarItensViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var nomeTextField: UITextField!
    @IBOutlet weak var caloriasTextFiled: UITextField!
    
    // MARK : - Atributos
    var delegate: AdicionaItensDelegate?
    
    init(delegate: AdicionaItensDelegate){
        super.init(nibName: "AdicionarItensViewController", bundle: nil)
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - IBAction
    
    @IBAction func adicionarItem(_ sender: Any) {
        
        guard let nome = nomeTextField.text, let calorias = caloriasTextFiled.text else {
            return
        }
        
        
        if let numeroDeCalorias = Double(calorias){
            let item = Item(nome: nome, calorias: numeroDeCalorias)
            
            //antes de ir para a tela anterior devemos adicionar o item
            delegate?.add(item)
            
            //navegar para a prox tela: navigationController.push()
            //navegar para a tela anterior: navigationController.pop()
            navigationController?.popViewController(animated: true)
        }
      
    }
    
}
