//
//  Pokemon.swift
//  Pokedex
//
//  Created by Justus Karlsson on 2017-06-02.
//  Copyright © 2017 Justus Karlsson. All rights reserved.
//
import Alamofire
import Foundation

class Pokemon {
    private var _name : String
    private var _pokedexId: Int
    var description: String!
    var type: String!
    var defense: String!
    var attack: String!
    var height: String!
    var weight: String!
    var nextEvoText: String!
    var pokemonUrl: String!
    
    var name: String {
        return _name
    }
    var pokedexId: Int {
        return _pokedexId
    }
    
    init (name:String, pokedexId:Int) {
        _name = name
        _pokedexId = pokedexId
        pokemonUrl = URL_BASE + URL_POKEMON + String(pokedexId) + "/"
    }
    
    func downloadPokemonDetail (completed:@escaping DownloadComplete) {
        //Alamofire.request(pokemonUrl).responseJSON(response in )
    }
}
