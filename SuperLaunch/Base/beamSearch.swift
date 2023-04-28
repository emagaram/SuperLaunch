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
    var paths: Array<Path> = []
}

struct Path {
    var prefix:String
    var score: Double
    var prev_point: Int
    var type: PathType
}

struct Coordinate {
    var x: Double
    var y: Double
}

func add_alignment_search_paths (next_char:Character,
                                 next_beam:Beam,
                                 search_path:Path,
                                 point: Coordinate) {
    
}

func add_transition_search_paths(next_beam: Beam, search_path: Path, prev_letter: Character, point: Coordinate){
    
}

func get_next_letters_from_path (path: String) -> Array<Character> {
    return []
}

/*
 keys: Need coordinates of each key along with their size
 point: x y coordinates of the point in the path
 currentBeam: Current beam,
 */
//The entire beamSearch function, returns the next beam
func getNextBeam (currentBeam: Beam, currentPoint: Coordinate, keys: Any) -> Beam {
    
    var next_beam = Beam.init()
    currentBeam.paths.forEach{ search_path in
        add_alignment_search_paths(next_char:search_path.prefix.last!, next_beam: next_beam, search_path: search_path, point: currentPoint)
        add_transition_search_paths(next_beam:next_beam,
                                    search_path:search_path,
                                    prev_letter:search_path.prefix.last!,
                                    point:currentPoint
        )
        if search_path.type == .alignment {
            // Add transition search path for all the possible next letters
            var next_letters = get_next_letters_from_path(path:search_path.prefix)
            next_letters.forEach { letter in
                add_transition_search_paths(next_beam: next_beam, search_path: search_path, prev_letter: letter, point: currentPoint)
            }
        }
        // currentBeam sort by Prob
        // currentBeam truncate
    }
    next_beam.paths.sort(by: {$0.score > $1.score})
    return next_beam
}
