//  Created by Axel Ancona Esselmann on 3/11/20.
//

import Foundation

public protocol StringRepresentable {
    var rawValue: String { get }
    init?(rawValue: String)
}

public extension StringRepresentable {
    var stringValue: String {
        return rawValue
    }
}
