//
//  RefeicoesTableViewController.swift
//  eggplant-brownie
//
//  Created by Leticia Sousa Siqueira on 18/12/20.
//  Copyright © 2020 Leticia Sousa Siqueira. All rights reserved.
//

import UIKit

//Adicionar o ViewControllerDelegate para a outra classe ter acesso nessa
class RefeicoesTableViewController: UITableViewController, AdicionaRefeicaoDelegate {
    
    var refeicoes: [Refeicao] = []
    
    
    override func viewDidLoad() {
        refeicoes = RefeicaoDao().recupera()
    }
    
    
    //override significa que estamos sobrescrevendo um método que herdamos da classe mãe, nesse caso da UITableViewController
    
    //MARK: OS DOIS MÉTODOS ABAIXO SÃO OBRIGATÓRIOS QUANDO SE TRATA DE TableView
    
    //MARK: Método para especificar o número de linhas que a TableView vai ter
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //O número de linhas será de acordo com o número de elementos no Array
        return refeicoes.count
    }
    
    //MARK: Método para mostrar o conteúdo do Array que estará em cada célula da TableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Cria a célula
        let celula = UITableViewCell(style: .default, reuseIdentifier: nil)
        //Acessando as posições do Array
        let refeicao = refeicoes[indexPath.row]
        //Mostrando na tela como label os nomes acessados no Array que pertencem a classe Refeicao
        celula.textLabel?.text = refeicao.nome
        
        //Aciona quando o usuário faz um click longo, um gesto (target é o arquivo que será utilizado)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(mostrarDetalhes(_:)))
        celula.addGestureRecognizer(longPress)
        
        return celula
    }
    
    
    //O _ serve para ocultar os parametros ou seja na hora de chama-los vc só precisa declarar o valor
    
    //MARK: Esse método será chamado na View Controller 
    func add(_ refeicao: Refeicao) {
        refeicoes.append(refeicao)
        
        //Atualiza a tela de acordo com o que foi adicionado
        tableView.reloadData()
        
        RefeicaoDao().save(refeicoes)
    }
    
    //Será utilizado no GestureRecognizer
    @objc func mostrarDetalhes(_ gesture: UILongPressGestureRecognizer) {
        //O estado que o usuário está em relação ao gesture que eu coloquei na celula (.began signifca começo)
        if gesture.state == .began {
            //iremos utilizar o casting(as!) para transformar uma view generica em uma celula
            let celula = gesture.view as! UITableViewCell
            
            //Com a celula conseguimos recuperar o indexPath, ou seja qual linha da tabela foi clicada
            guard let indexPath = tableView.indexPath(for: celula) else {
                return
            }
            
            let refeicao = refeicoes[indexPath.row]
            
            RemoveRefeicaoViewController(controller: self).exibe(refeicao, handler: { alert in
                self.refeicoes.remove(at: indexPath.row)
                self.tableView.reloadData()
            })
        }
        
    }
    
   
    
    //MARK: Esse método prepara antes de seguir para o próximo ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Identifica se o segue é o adicionar, ajuda quando tiver mais telas com mais segues
        if segue.identifier == "adicionar" {
            //tenho acesso ao ViewController que ele irá apresentar
            if let viewController = segue.destination as? ViewController {
                viewController.delegate = self //Estamos falando que será a classe ViewController que irá implementar o protocolo de delegate
            }
        }
    }
    
}
