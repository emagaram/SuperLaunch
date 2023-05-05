class TrieNode {
    var children: [Character: TrieNode]
    var isEndOfWord: Bool
    
    init() {
        self.children = [Character: TrieNode]()
        self.isEndOfWord = false
    }
}

class Trie {
    private let root: TrieNode
    
    init() {
        self.root = TrieNode()
    }
    
    func insert(word: String) {
        var currentNode = root
        for char in word {
            if currentNode.children[char] == nil {
                currentNode.children[char] = TrieNode()
            }
            currentNode = currentNode.children[char]!
        }
        currentNode.isEndOfWord = true
    }
    
    func search(word: String) -> Bool {
        var currentNode = root
        for char in word {
            guard let nextNode = currentNode.children[char] else {
                return false
            }
            currentNode = nextNode
        }
        return currentNode.isEndOfWord
    }
    
    func startsWith(prefix: String) -> Bool {
        var currentNode = root
        for char in prefix {
            guard let nextNode = currentNode.children[char] else {
                return false
            }
            currentNode = nextNode
        }
        return true
    }
    func getWordWithPrefix(prefix: String) -> String? {
            var currentNode = root
            var word = prefix
            for char in prefix {
                guard let nextNode = currentNode.children[char] else {
                    return nil
                }
                currentNode = nextNode
            }
            
            return getWordHelper(node: currentNode, word: &word)
        }
        
        private func getWordHelper(node: TrieNode, word: inout String) -> String? {
            if node.isEndOfWord {
                return word
            }
            
            for (char, nextNode) in node.children {
                word.append(char)
                if let result = getWordHelper(node: nextNode, word: &word) {
                    return result
                }
                word.removeLast()
            }
            
            return nil
        }
}
