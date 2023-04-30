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
}
