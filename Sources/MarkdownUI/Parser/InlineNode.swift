import Foundation

enum InlineNode: Sendable {
  case text(String)
  case softBreak
  case lineBreak
  case code(String)
  case html(String)
  case emphasis(children: [InlineNode])
  case strong(children: [InlineNode])
  case strikethrough(children: [InlineNode])
  case link(destination: String, children: [InlineNode])
  case image(source: String, children: [InlineNode])
}

extension InlineNode: Hashable {
  func hash(into hasher: inout Hasher) {
    switch self {
    case .text(let string):
      hasher.combine(0)
      hasher.combine(string)
    case .softBreak:
      hasher.combine(1)
    case .lineBreak:
      hasher.combine(2)
    case .code(let string):
      hasher.combine(3)
      hasher.combine(string)
    case .html(let string):
      hasher.combine(4)
      hasher.combine(string)
    case .emphasis(let children):
      hasher.combine(5)
      hasher.combine(children)
    case .strong(let children):
      hasher.combine(6)
      hasher.combine(children)
    case .strikethrough(let children):
      hasher.combine(7)
      hasher.combine(children)
    case .link(let destination, let children):
      hasher.combine(8)
      hasher.combine(destination)
      hasher.combine(children)
    case .image(let source, let children):
      hasher.combine(9)
      hasher.combine(source)
      hasher.combine(children)
    }
  }

  static func == (lhs: InlineNode, rhs: InlineNode) -> Bool {
    switch (lhs, rhs) {
    case (.text(let l), .text(let r)):
      return l == r
    case (.softBreak, .softBreak):
      return true
    case (.lineBreak, .lineBreak):
      return true
    case (.code(let l), .code(let r)):
      return l == r
    case (.html(let l), .html(let r)):
      return l == r
    case (.emphasis(let l), .emphasis(let r)):
      return l == r
    case (.strong(let l), .strong(let r)):
      return l == r
    case (.strikethrough(let l), .strikethrough(let r)):
      return l == r
    case (.link(let ld, let lc), .link(let rd, let rc)):
      return ld == rd && lc == rc
    case (.image(let ls, let lc), .image(let rs, let rc)):
      return ls == rs && lc == rc
    default:
      return false
    }
  }
}

extension InlineNode {
  var children: [InlineNode] {
    get {
      switch self {
      case .emphasis(let children):
        return children
      case .strong(let children):
        return children
      case .strikethrough(let children):
        return children
      case .link(_, let children):
        return children
      case .image(_, let children):
        return children
      default:
        return []
      }
    }

    set {
      switch self {
      case .emphasis:
        self = .emphasis(children: newValue)
      case .strong:
        self = .strong(children: newValue)
      case .strikethrough:
        self = .strikethrough(children: newValue)
      case .link(let destination, _):
        self = .link(destination: destination, children: newValue)
      case .image(let source, _):
        self = .image(source: source, children: newValue)
      default:
        break
      }
    }
  }
}
