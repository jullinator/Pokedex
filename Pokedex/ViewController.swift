//
//  ViewController.swift
//  Pokedex
//
//  Created by Justus Karlsson on 2017-06-02.
//  Copyright © 2017 Justus Karlsson. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemonArray = [Pokemon]()
    var selectedPokemon: Pokemon!
    var inSearchMode = false
    var searchText = ""
    var musicPlayer: AVAudioPlayer!
    
    var computedPokemon: Array<Pokemon> {
        if inSearchMode {
            return pokemonArray.filter({ $0.name.range(of: searchText) != nil })
        } else {
            return pokemonArray
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        parsePokemonCSV()
        initAudio()
    }
    
    func initAudio () {
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string:path!)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    func parsePokemonCSV (){
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            for row in rows {
                let pokedexId = Int(row["id"]!)!
                let name = row["identifier"]!
                let pokemon = Pokemon(name: name, pokedexId: pokedexId)
                pokemonArray.append(pokemon)
            }
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return computedPokemon.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPokemon = computedPokemon[indexPath.row]
        performSegue(withIdentifier: "PokemonDetailVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDetailVC" {
            guard let destination = segue.destination as? PokemonDetailVC else {
                fatalError()
            }
            destination.pokemon = selectedPokemon
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell else {
                fatalError("Not a PokeCell")
        }
        
        let pokemon = computedPokemon[indexPath.row]
        cell.configureCell(pokemon)
        return cell
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 105, height: 105)
    }
    
    @IBAction func musicBtnPressed (_ sender: UIButton) {
        if(musicPlayer.isPlaying){
            musicPlayer.pause()
            sender.alpha = 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
        } else {
            self.searchText = searchBar.text!.lowercased()
            inSearchMode = true
        }
        collection.reloadData()
    }

}

