//
//  File.swift
//  XZLibrary
//
//  Created by A big dot digit    on 2025/2/18.
//

import CommonCrypto
import Foundation

public extension Data {
    var md5: String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digestData = Data(count: length)

        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            self.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress,
                    let digestBytesBaseAddress = digestBytes.bindMemory(
                        to: UInt8.self
                    ).baseAddress
                {
                    let messageLength = CC_LONG(self.count)
                    CC_SHA256(
                        messageBytesBaseAddress,
                        messageLength,
                        digestBytesBaseAddress
                    )
                }
                return 0
            }
        }
        return digestData.map { String(format: "%02hhx", $0) }.joined()
    }
}
