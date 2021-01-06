//
//  ViewController.swift
//  eggplant-brownie
//
//  Created by Leticia Sousa Siqueira on 16/12/20.
//  Copyright © 2020 Leticia Sousa Siqueira. All rights reserved.
//

import UIKit

//Boa práticas. Vai enxergar somente as informacoes de outra classe que realmente precisamos utilizar nessa, evita que o desenvolvedor acesse outras coisas e cometa erros
protocol AdicionaRefeicaoDelegate {
    func add(_ refeicao: Refeicao) //colocamos apenas o header da funcao que está na outra classe
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AdicionaItensDelegate {
    
    // MARK: - IBOutlet
    @IBOutlet weak var itensTableView: UITableView!
    
    
    // MARK: - Atributos
    
    //Variável que delega a responsabilidade de chamar uma funcao de outra classe, nesse caso estaremos utilizando para chamar uma funcao do RefeicoesTableViewController
    var delegate: AdicionaRefeicaoDelegate?
    
    //Variável com uma lista de itens que será apresentado na TableView da segunda tela
    var itens: [Item] = []
    
    var itensSelecionados: [Item] = []
    
    // MARK: - IBOutlets
    
    //O ! é para informar que a variavel terá um valor/incializador, já o ? quer dizer que vc nao tem certeza sobre o valor da variável e que ele precisa ser validada
    @IBOutlet var nomeTextField: UITextField?
    @IBOutlet var felicidadeTextFiedl: UITextField?
    
    
    // MARK: - View life cycle
    
    //É executado assim que a view termina de ser carregada, no selector estamos chamando a funcao adicionarItem. Esse target quer dizer onde esse metodo está, nesse caso ele está dentro dessa propria classe
    override func viewDidLoad() {
        let botaoAdicionaItem = UIBarButtonItem(title: "adicionar", style: .plain, target: self, action: #selector(adicionarItem))
        
        //Criando o botao programaticamente na tela
        navigationItem.rightBarButtonItem = botaoAdicionaItem
        
        recuperaItens()
    }
    
    func recuperaItens() {
        itens = ItemDao().recupera()
    }
    
    //Precisamos colocar o @objc no comeco da funcao
    @objc func adicionarItem() {
        //Criando um novo viewController (nesse caso referencia o .xib que criamos)
        let adicionarItensViewController = AdicionarItensViewController(delegate: self)
        navigationController?.pushViewController(adicionarItensViewController, animated: true)
    }
    
    @objc func add(_ item: Item) {
        itens.append(item)
        ItemDao().save(itens)
        
        if let tableView = itensTableView {
            tableView.reloadData()
        } else {
            //estamos chamando o metodo exibe() da classe Alerta
           Alerta(controller: self).exibe(mensagem: "Erro ao atualizar a tabela")
        }
    }
    
    // MARK: - UITableViewDataSource
    
    //Metodos referente ao TableView da segunda tela
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        let linhaDaTabela = indexPath.row
        let item = itens[linhaDaTabela]
        celula.textLabel?.text = item.nome
        
        return celula
    }
    
    // MARK: - UITableViewDelegate
    //Funcao para identificar quando o usuário seleciona um item na TableView da segunda tela
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let celula = tableView.cellForRow(at: indexPath) else {
            return
        }
        
        //Ao identificar o click se a celula estiver vazia ele marca o check se já estiver com o check e for clicada ele tirá o check
        if celula.accessoryType == .none{
            celula.accessoryType = .checkmark //Se o click for identificado ele coloca o check na celula
            
            let linhaDaTabela = indexPath.row
            itensSelecionados.append(itens[linhaDaTabela])
        } else {
            celula.accessoryType = .none
            
            //Para remover um item da lista caso o usuário tire o check
            let item = itens[indexPath.row]
            if let position = itensSelecionados.index(of: item){
                itensSelecionados.remove(at: position)
               
            }
            
        }
        
    }
    
    func recuperaRefeicaoDoFormulario() -> Refeicao? {
        //Validando os opcionais
        guard let nomeDaRefeicao = nomeTextField?.text else{
            return nil
        }
        
        //Primeiro extraio o valor do textField para depois converter para int
        guard let felicidadeDaRefeicao = felicidadeTextFiedl?.text, let felicidade = Int(felicidadeDaRefeicao) else{
            return nil
        }
        //Passando os valores para a classe Refeicao
        let refeicao = Refeicao(nome: nomeDaRefeicao, felicidade: felicidade, itens: itensSelecionados)
        refeicao.itens = itensSelecionados
        
        return refeicao
        
    }
    
    // MARK: - IBActions

    //Declar um metodo, @IBAction serve para linkar o botao
    @IBAction func adicionar(_ sender: Any) {
        
        if let refeicao = recuperaRefeicaoDoFormulario() {
            //Está chamando a classe da RefeicoesTableViewController
            delegate?.add(refeicao)
            
            //Evita que adicione várias telas, controla melhor o fluxo de telas do Storyboard ou seja, quando clicamos no botão de Back ou algum outro botão que deveria retornar para a tela anterior, além de abrir uma nova tela que refere-se a tela anterior, ele apenas fechará a tela atual para apresentar a primeira que já foi aberta, evita que gaste memória de abrir repetidamente uma mesma tela
            navigationController?.popViewController(animated: true)
        } else {
            Alerta(controller: self).exibe(mensagem: "Erro ao ler dados do formulário")
        }
        
    }
    
}

