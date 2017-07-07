//
//  Logger.swift
//  OpenWeatherDemo
//
//  Created by Kyle Watson on 7/6/17.
//  Copyright © 2017 Kyle Watson. All rights reserved.
//

import Foundation

/// A message logger for recording messages with different severity
protocol MessageLogger {
    func verboseMessage(_ item: Any)
    func debugMessage(_ item: Any)
    func infoMessage(_ item: Any)
    func warningMessage(_ item: Any)
    func errorMessage(_ item: Any)
}

struct LoggingLevel: OptionSet, Comparable {
    let rawValue: UInt
    init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
    static let verbose = LoggingLevel(rawValue: 0)
    static let debug = LoggingLevel(rawValue: 1)
    static let info = LoggingLevel(rawValue: 2)
    static let warning = LoggingLevel(rawValue: 4)
    static let error = LoggingLevel(rawValue: 8)
}

// make LoggingLevel conform to Comparable
func < (lhs: LoggingLevel, rhs: LoggingLevel) -> Bool {
    return lhs.rawValue < rhs.rawValue
}

/// A convenience struct for accessing defualt logging class.
struct Logger {
    static var loggingLevel: LoggingLevel = .verbose
    
    private static let logger: MessageLogger = EmojiLogger()
    
    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }()
    
    static func verbose(_ items: Any?..., file: String = #file, function: String = #function, line: Int = #line) {
        guard loggingLevel <= .verbose else { return }
        guard let url = URL(string: file) else { return }
        let fileName = url.deletingPathExtension().lastPathComponent
        let timestamp = dateFormatter.string(from: Date())
        logger.verboseMessage("\(timestamp) \(fileName).\(function):\(line) - \(stringify(items))")
    }
    
    static func debug(_ items: Any?...) {
        guard loggingLevel <= .debug else { return }
        logger.debugMessage(stringify(items))
    }
    
    static func info(_ items: Any?...) {
        guard loggingLevel <= .info else { return }
        logger.infoMessage(stringify(items))
    }
    
    static func warn(_ items: Any?...) {
        guard loggingLevel <= .warning else { return }
        logger.warningMessage(stringify(items))
    }
    
    static func error(_ items: Any?...) {
        guard loggingLevel <= .error else { return }
        logger.errorMessage(stringify(items))
    }
    
    private static func stringify(_ items: [Any?], withSeparator separator: String = " ") -> String {
        return items.map { type(of: ($0 ?? "") as Any) is AnyClass ? "\(type(of: $0!))" : String(describing: $0 ?? "nil") }
            .joined(separator: separator)
    }
}

/// An Emoji-based logger
class EmojiLogger: MessageLogger {
    
    func verboseMessage(_ item: Any) {
        print("⚙️ \(item)")
    }
    
    func debugMessage(_ item: Any) {
        print("💬 \(item)")
    }
    
    func infoMessage(_ item: Any) {
        print("ℹ️ \(item)")
    }
    
    func warningMessage(_ item: Any) {
        print("⚠️ \(item)")
    }
    
    func errorMessage(_ item: Any) {
        print("🚫 \(item)")
    }
}
