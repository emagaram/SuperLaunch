func levenshteinDistance(_ s1: String, _ s2: String) -> Int {
    let s1Chars = Array(s1)
    let s2Chars = Array(s2)
    let s1Length = s1Chars.count
    let s2Length = s2Chars.count
    
    if s1Length == 0 {
        return s2Length
    }
    
    if s2Length == 0 {
        return s1Length
    }
    
    var distanceMatrix = Array(repeating: Array(repeating: 0, count: s2Length + 1), count: s1Length + 1)
    
    for i in 0...s1Length {
        distanceMatrix[i][0] = i
    }
    
    for j in 0...s2Length {
        distanceMatrix[0][j] = j
    }
    
    for i in 1...s1Length {
        for j in 1...s2Length {
            let substitutionCost = s1Chars[i - 1] == s2Chars[j - 1] ? 0 : 1
            
            distanceMatrix[i][j] = min(
                distanceMatrix[i - 1][j] + 1,                                // deletion
                min(distanceMatrix[i][j - 1] + 1,                            // insertion
                    distanceMatrix[i - 1][j - 1] + substitutionCost)         // substitution
            )
        }
    }
    
    return distanceMatrix[s1Length][s2Length]
}
