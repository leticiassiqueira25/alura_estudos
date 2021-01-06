//
//  ViewController.swift
//  Alura Viagens
//
//  Created by Leticia Sousa Siqueira on 29/12/20.
//  Copyright © 2020 Leticia Sousa Siqueira. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tabelaViagens: UITableView!
    @IBOutlet weak var viewHoteis: UIView!
    @IBOutlet weak var viewPacotes: UIView!
    
    
    let listaViagens:Array<Viagem> = ViagemDAO().retornaTodasAsViagens()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabelaViagens.dataSource = self
        self.tabelaViagens.delegate = self
        //para aredondar as bordas do botao
        self.viewPacotes.layer.cornerRadius = 10
        self.viewHoteis.layer.cornerRadius = 10 
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaViagens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Damos um casting (as!) para apontar para a classe responsavel
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let viagemAtual = listaViagens[indexPath.row]
        cell.configuraCelula(viagem: viagemAtual)
        return cell
    }
    
    //Altura da celula
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //Fazer uma verificacao para alterar a altura quando o usuario estiver usando Ipad, esse : significa else, ou seja, se for iphone seta 175 se não 260
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone ? 175  : 260
    }

}

