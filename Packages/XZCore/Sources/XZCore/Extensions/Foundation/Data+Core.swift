//
//  Data+Core.swift
//  XZCore
//
//  Created by XZLibrary on 2025/1/26.
//

#if canImport(Foundation)
import Foundation

#if canImport(CommonCrypto)
import CommonCrypto

public extension Data {
    /// 计算Data的MD5哈希值
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
#endif

#endif