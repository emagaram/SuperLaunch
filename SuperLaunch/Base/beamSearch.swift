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
    var paths: [PathBeam] = []
}

struct PathBeam {
    var prefix:String
    var score: Double
    var prev_point: CGPoint?
    var type: PathType
}

typealias Key = (key:String, value:CGPoint)
typealias Keys = [String: CGPoint]


let sigma = 15.0

func gaussianProbability(tappedPoint: CGPoint,
                         keyCenter: CGPoint,
                         sigma: Double) -> Double {
    let distanceSquared = pow(tappedPoint.x - keyCenter.x, 2) + pow(tappedPoint.y - keyCenter.y, 2)
    let variance = pow(sigma, 2)
    
    let probability = exp(-distanceSquared / (2 * variance))
    return probability
}

func add_alignment_search_paths (char:String,
                                 beam:Beam,
                                 search_path:PathBeam,
                                 point: CGPoint,
                                 keys: Keys) {
    let charProbability = gaussianProbability(tappedPoint: point, keyCenter: keys[char]!, sigma: sigma)
    let newScore = search_path.score*charProbability
    beam.paths.append(PathBeam(prefix: search_path.prefix, score: newScore, prev_point: search_path.prev_point, type: .alignment))
    
    
}

func add_transition_search_paths(beam: Beam, search_path: PathBeam, keys: Keys, letter: String, point: CGPoint){
    let charProbability = gaussianProbability(tappedPoint: point, keyCenter: keys[letter]!, sigma: sigma)
    let newScore = search_path.score*charProbability
    beam.paths.append(PathBeam(prefix: search_path.prefix+letter, score: newScore, prev_point: search_path.prev_point, type: .transition))
}

func get_next_letters_from_path (path: String, appNamesTrie:Trie) -> [String] {
    var result: [String] = []
    func processChar(c:UInt32){
        let letter = Character(Unicode.Scalar(c) ?? " ")
        var pathCopy = path + letter.lowercased()
        if(appNamesTrie.startsWith(prefix: pathCopy)){
            result.append(letter.lowercased())
        }
    }
    (Unicode.Scalar("a").value...Unicode.Scalar("z").value).forEach({
        processChar(c:$0)
    })
    (Unicode.Scalar("0").value...Unicode.Scalar("9").value).forEach{
        processChar(c: $0)
    }
    processChar(c: Unicode.Scalar(" ").value)
    return result
    
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
func getNextBeam (currentBeam: Beam, currentPoint: CGPoint, keys: Keys, dictionary: [String], appNamesTrie: Trie) -> Beam {
    let BEAM_SIZE = 10
    let next_beam = Beam.init()
    currentBeam.paths.forEach{ search_path in
        let next_letters = get_next_letters_from_path(path:search_path.prefix, appNamesTrie: appNamesTrie)
        add_alignment_search_paths(char:search_path.prefix.last!.lowercased(), beam: next_beam, search_path: search_path, point: currentPoint, keys: keys)
        
        if(next_letters.contains(search_path.prefix.last!.lowercased())){
            add_transition_search_paths(beam:next_beam,
                                        search_path:search_path,
                                        keys:keys,
                                        letter:search_path.prefix.last!.lowercased(),
                                        point:currentPoint
            )
        }
        
        if search_path.type == .alignment {
            // Add transition search path for all the possible next letters
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
        print(currentBeam.paths[index].prefix)
    }
    print("")
    return next_beam
}
