//  Created by Axel Ancona Esselmann on 9/11/18.
//  Copyright © 2019 Axel Ancona Esselmann. All rights reserved.
//

import Foundation
import ValueTypeRepresentable

public struct URN {
    public let stringValue: String

    public var rawValue: String {
        return stringValue
    }

    public init?(stringValue: String) {
        self.stringValue = stringValue
        // todo: don't initialize if not a valid urn
    }

    public init?(rawValue: String) {
        self.init(stringValue: rawValue)
    }

    public var uuid: UUID {
        return UUID(uuidString: String(stringValue.suffix(36)))! // ! will be OK because initializers check validity
    }

    public var uuidString: String {
        return uuid.uuidString.lowercased()
    }

    public var components: [String] {
        stringValue.components(separatedBy: ":")
    }
}

extension URN: StringRepresentable {
    public init?(_ stringValue: String) {
        self.init(stringValue: stringValue)
    }
}

extension URN: Encodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.stringValue = try container.decode(String.self)
        // todo: throw if not a valid urn
    }
}

extension URN: Decodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(stringValue)
    }
}

extension URN: Equatable {
    public static func ==(lhs: URN, rhs: URN) -> Bool {
        return lhs.stringValue.lowercased() == rhs.stringValue.lowercased()
    }
}

public extension UUID {
    init?(urnString: String?) {
        guard
            let urnString = urnString,
            let uuidString = urnString.matches(for: "[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}").first
            else { return nil }

        self.init(uuidString: uuidString)
    }
}

public extension UUID {
    var serverString: String {
        return uuidString.lowercased()
    }
}

public extension String {
    func matches(for regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = self as NSString
            let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch {
            return []
        }
    }
}

public protocol UrnBased {
    static var urnBase: String { get }
}

extension UrnBased {
    public static func newUrn() -> URN { .new(Self.urnBase) }
}

public protocol UrnTypes {
    var rawValue: String { get }
}

extension URN {
    public static func new(_ root: String) -> URN {
        URN(type: root, uuid: UUID())
    }

    public static func new(_ root: UrnTypes) -> URN {
        new(root.rawValue)
    }

    public init<T>(type: T.Type, uuid: UUID) where T: UrnBased {
        self.init(type: type.urnBase, uuid: uuid)
    }

    public init(type: String, uuid: UUID) {
        self.init(stringValue: "\(type):\(uuid.uuidString.lowercased())")!
    }

    public init?(type: String, uuidString: String) {
        guard let uuid = UUID(uuidString: uuidString) else {
            return nil
        }
        self.init(type: type, uuid: uuid)
    }

    public init?<T>(type: T.Type, uuidString: String) where T: UrnBased {
        guard let uuid = UUID(uuidString: uuidString) else {
            return nil
        }
        self.init(type: type, uuid: uuid)
    }

    public init(type: String, fauxUuid: String) {
        self.init(stringValue: "\(type):\(fauxUuid)")!
    }

    public init<T>(type: T.Type, fauxUuid: String) where T: UrnBased {
        self.init(type: type.urnBase, fauxUuid: fauxUuid)
    }
}
