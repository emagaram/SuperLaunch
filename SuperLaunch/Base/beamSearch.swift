//
//  beamSearch.swift
//  SuperLaunch
//
//  Created by Ezra Magaram on 4/29/23.
//

import Foundation

enum PathType {
    case alignment
    case transition
}

class Beam {
    var paths: [Path] = []
}

struct Path {
    var prefix:String
    var score: Double
    var prev_point: Int
    var type: PathType
}

typealias XYPair = (x: Double, y: Double)
typealias Key = (key:Character, value:XYPair)
typealias Keys = [Character: XYPair]


let sigma = 15.0

func gaussianProbability(tappedPoint: XYPair,
                         keyCenter: XYPair,
                         sigma: Double) -> Double {
    let distanceSquared = pow(tappedPoint.x - keyCenter.x, 2) + pow(tappedPoint.y - keyCenter.y, 2)
    let variance = pow(sigma, 2)
    
    let probability = exp(-distanceSquared / (2 * variance))
    return probability
}

func add_alignment_search_paths (char:Character,
                                 beam:Beam,
                                 search_path:Path,
                                 point: XYPair,
                                 keys: Keys) {
    let charProbability = gaussianProbability(tappedPoint: point, keyCenter: keys[char]!, sigma: sigma)
    let newScore = search_path.score*charProbability
    beam.paths.append(Path(prefix: search_path.prefix, score: newScore, prev_point: search_path.prev_point+1, type: .alignment))
    
    
}

func add_transition_search_paths(beam: Beam, search_path: Path, keys: Keys, letter: Character, point: XYPair){
    let charProbability = gaussianProbability(tappedPoint: point, keyCenter: keys[letter]!, sigma: sigma)
    let newScore = search_path.score*charProbability
    beam.paths.append(Path(prefix: search_path.prefix, score: newScore, prev_point: search_path.prev_point+1, type: .transition))
}

func get_next_letters_from_path (path: String) -> [Character] {
    return []
}

/*
 keys: CENTER coordinates of each key along with their size,
 keyboard_width: Double
 keyboard_height: Double
 point: x y coordinates of the point in the path
 currentBeam: Current beam,
 dictionary: All app names and maybe shortcuts
 */
//The entire beamSearch function, returns the next beam
func getNextBeam (currentBeam: Beam, currentPoint: XYPair, keys: Keys, dictionary: [String]) -> Beam {
    let BEAM_SIZE = 10
    var next_beam = Beam.init()
    currentBeam.paths.forEach{ search_path in
        add_alignment_search_paths(char:search_path.prefix.last!, beam: next_beam, search_path: search_path, point: currentPoint, keys: keys)
        add_transition_search_paths(beam:next_beam,
                                    search_path:search_path,
                                    keys:keys,
                                    letter:search_path.prefix.last!,
                                    point:currentPoint
        )
        if search_path.type == .alignment {
            // Add transition search path for all the possible next letters
            var next_letters = get_next_letters_from_path(path:search_path.prefix)
            next_letters.forEach { letter in
                add_transition_search_paths(beam: next_beam, search_path: search_path, keys: keys, letter: letter, point: currentPoint)
            }
        }
    }
    // Descending order
    next_beam.paths.sort(by: {$0.score > $1.score})
    
    // Truncate
    while(next_beam.paths.count > BEAM_SIZE){
        next_beam.paths.removeLast()
    }
    
    //Normalize
    var totalProbability = 0.0
    currentBeam.paths.forEach { search_path in
        totalProbability+=search_path.score
    }
    let normalize = 1 / totalProbability
    currentBeam.paths.indices.forEach{ index in
        currentBeam.paths[index].score *= normalize
    }
    return next_beam
}
