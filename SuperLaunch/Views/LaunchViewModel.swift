//
//  LaunchViewModel.swift
//  SuperLaunch
//
//  Created by Ezra Magaram on 4/28/23.
//

import Foundation
final class LaunchViewModel:ObservableObject{
    @Published var enteredText = "" {
        didSet {
            if enteredText != "" {
                var maxDistance = 10000000000
                var appName = ""
                appNamesArray.forEach{ item in
                    let distance = levenshteinDistance(enteredText, item)
                    print("Distance for: ", item, "is ", distance)
                    if(distance < maxDistance) {
                        appName = item
                        maxDistance = distance
                    }
                }
                print("Started with : ", enteredText, "ended with: ", appName)
//                enteredText = ""
                openApp(appName: appName)
            }
        }
    }
    @Published var buttonCenterCoords:Keys = [:]
    let epsilon: CGFloat = 1.0
    func processPoints() -> String? {
        if let lastLine = lastLine {
            let epsilon: CGFloat = 2.0 // Choose an appropriate epsilon value based on your requirements
            let simplifiedPoints = ramerDouglasPeucker(lastLine.points, epsilon: epsilon)
            var currentBeam = Beam()
            (Unicode.Scalar("a").value...Unicode.Scalar("z").value).forEach({
                let letter = String(Unicode.Scalar($0) ?? " ")
                if(appNamesTrie.startsWith(prefix: letter)){
                    let new_path = PathBeam(prefix: letter, score: 1, type: .alignment)
                    add_alignment_search_paths(char:letter,
                                                             beam:currentBeam,
                                                             search_path:new_path,
                                                             point:simplifiedPoints[0],
                                                             keys:buttonCenterCoords)
                }
            })
            print("SPoints", simplifiedPoints)
            for point in simplifiedPoints.dropFirst() {
                currentBeam = getNextBeam(currentBeam: currentBeam, currentPoint: point, keys: buttonCenterCoords, dictionary: appNamesArray, appNamesTrie: appNamesTrie)
            }
            return currentBeam.paths[0].prefix
        }
        return nil
    }
    @Published var lastLine:Line? = nil {
        didSet {
            predicted = appNamesTrie.getWordWithPrefix(prefix:processPoints()!)!
            print("PRED",predicted)
        }
    }
    @Published var predicted:String = ""
    @Published var appNames = [String:String]()
    var appNamesArray: Array<String> = []
    var appNamesTrie=Trie()
    
    func loadJson(forName name: String) {
        do {
            if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
               if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves) as? [String: String] {
                   var lowercaseKeys = [String: String]()
                   for (key, value) in jsonObject {
                       let lowercaseKey = key.lowercased()
                       lowercaseKeys[lowercaseKey] = value
                   }
                   appNames = lowercaseKeys
                   appNamesArray = Array(lowercaseKeys.keys)
                   appNamesArray.forEach{name in
                       appNamesTrie.insert(word: name)
                   }
               } else {
                  print("Given JSON is not a valid dictionary object.")
               }
            }
         } catch {
            print(error)
         }
    }

    
    init() {
        loadJson(forName: "MyAppsMap")
    }
    
    func openApp(appName:String)->Bool {
        print("AN", appName.lowercased())
        guard let obj = objc_getClass("LSApplicationWorkspace") as? NSObject else { return false }
        let workspace = obj.perform(Selector(("defaultWorkspace")))?.takeUnretainedValue() as? NSObject
        let open = workspace?.perform(Selector(("openApplicationWithBundleID:")), with: appNames[appName.lowercased()] ?? "com.apple.mobilesafari") != nil
        return open
    }
    
}
