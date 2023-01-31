//
//  RequestUtil.swift
//  Reader
//
//  Created by Mephisto on 2021/4/7.
//

import Combine
import Foundation
import MobileCoreServices
import MyModel
import Photos
import SwifterSwift
import SwiftUI
import UIKit

public struct RequestManager<API> where API: APIProtocol {
    public init() {}

    public func request<Item>(endpoint: API) -> AnyPublisher<Item, Error> where Item: Decodable {
        let requestURL = setupRequestUrl(endpoint)
        return URLSession.shared
            .dataTaskPublisher(for: requestURL)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200
                else {
                    let httpResponse = response as? HTTPURLResponse
                    throw MyError.netEerrorData(data, httpResponse?.statusCode ?? -1)
                }
                return data
            }
            .decode(type: Item.self, decoder: appDecoder)
            .eraseToAnyPublisher()
    }

    public func requestData(endpoint: API) async throws -> (Data, URLResponse) {
        let requestURL = setupRequestUrl(endpoint)
        var data: Data, response: URLResponse
        if #available(iOS 15.0, *) {
            (data, response) = try await URLSession.shared.data(for: requestURL)
        } else {
            (data, response) = try await URLSession.shared.data(from: requestURL)
        }

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else {
            let httpResponse = response as? HTTPURLResponse
            throw MyError.netEerrorData(data, httpResponse?.statusCode ?? -1)
        }
        return (data, response)
    }

    public func downloadFile(endpoint: API) async throws -> (URL, URLResponse) {
        let requestURL = setupRequestUrl(endpoint)
        var url: URL, response: URLResponse
        if #available(iOS 15.0, *) {
            (url, response) = try await URLSession.shared.download(for: requestURL)
        } else {
            (url, response) = try await URLSession.shared.download(from: requestURL)
        }

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else {
            let httpResponse = response as? HTTPURLResponse
            throw MyError.errorDesc("network error:\(httpResponse?.statusCode ?? -1)")
        }

        let locationPath = url.path
        let fileName = response.suggestedFilename ?? ""
        guard locationPath != "", fileName != "" else { throw MyError.errorDesc("path or fileName is nil") }
        let fm = FileManager.default
        let documentUrl = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let downloadURL = documentUrl.appendingPathComponent("TimeDownload")
        if !fm.fileExists(atPath: downloadURL.path) {
            try fm.createDirectory(at: downloadURL, withIntermediateDirectories: true)
        }

        let filePath = downloadURL.path + "/" + fileName
        try fm.moveItem(atPath: locationPath, toPath: filePath)
        return (URL(fileURLWithPath: filePath), response)
    }
}

extension RequestManager {
    private func setupRequestUrl(_ endpoint: API) -> URLRequest {
        let queryURL = endpoint.baseURL.appendingPathComponent(endpoint.path)
        var components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem]()

        if endpoint.parameterEncoding == .URLEncoding {
            if let parameter = endpoint.parameters {
                for (_, value) in parameter.enumerated() {
//                    if let noNilValue = value.value {
//                        let queryValue = "\(noNilValue)"
//                        components.queryItems?.append(URLQueryItem(name: value.key, value: queryValue))
//                    }

                    let queryValue = "\(value.value)"
                    components.queryItems?.append(URLQueryItem(name: value.key, value: queryValue))
                }
            }
        }

        var requestURL = URLRequest(url: components.url!)
        requestURL.httpMethod = endpoint.method.string()
        let headers = endpoint.headers
        requestURL.allHTTPHeaderFields = headers
        requestURL.timeoutInterval = 30.0

        if endpoint.parameterEncoding == .FileEncoding {
            if let parameter = endpoint.parameters,
               let body = parameter[kBodyKey],
               let temp = body as? [String: Any],
               let data = parameter[kDataKey] as? Data
            {
                multipartParameter(for: &requestURL, with: temp, fileData: data)
            }
        }

        if endpoint.parameterEncoding == .JSONEncoding {
            if let parameter = endpoint.parameters {
                requestURL.httpBody = parameter.jsonData()
            }
        }

        return requestURL
    }

    private func multipartParameter(for requestURL: inout URLRequest, with parameters: [String: Any]?, fileData data: Data) {
        guard let parameters = parameters else {
            return
        }

        let boundary = "Boundary-\(UUID().uuidString)"
        let lineBreak = "\r\n"
        requestURL.setValue("multipart/form-data; boundary=\(boundary)",
                            forHTTPHeaderField: "Content-Type")

        var body = Data()
        // 添加普通参数数据
        for (key, value) in parameters {
            // 数据之前要用 --分隔线 来隔开 ，否则后台会解析失败
            body.appendString("--\(boundary)\(lineBreak)")
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\(lineBreak)")
        }

        let mimetype = mimeType(pathExtension: "txt")
        // 数据之前要用 --分隔线 来隔开 ，否则后台会解析失败
        body.appendString("--\(boundary)\(lineBreak)")
        let fileContent = "Content-Disposition: form-data; name=\"\("file")\"; filename=\"\("kindle.txt")\"\(lineBreak)"
        body.appendString(fileContent)
        body.appendString("Content-Type: \(mimetype)\r\n\r\n") // 文件类型
        body.append(data) // 文件主体
        body.appendString(lineBreak) // 使用\r\n来表示这个这个值的结束符

        // --分隔线-- 为整个表单的结束符
        body.appendString("--\(boundary)--\(lineBreak)")

        requestURL.httpBody = body
    }

    // 根据后缀获取对应的Mime-Type
    private func mimeType(pathExtension: String) -> String {
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                           pathExtension as NSString,
                                                           nil)?.takeRetainedValue()
        {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?
                .takeRetainedValue()
            {
                return mimetype as String
            }
        }
        // 文件资源类型如果不知道，传万能类型application/octet-stream，服务器会自动解析文件类
        return "application/octet-stream"
    }
}

extension Data {
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

@available(iOS, deprecated: 15.0, message: "Use the built-in API instead")
extension URLSession {
    func data(from url: URLRequest) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: url) { data, response, error in
                guard let data = data, let response = response else {
                    let error = error ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: error)
                }

                continuation.resume(returning: (data, response))
            }
            task.resume()
        }
    }

    func download(from url: URLRequest) async throws -> (URL, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let downloadTask = self.downloadTask(with: url) { url, response, error in
                guard let url = url, let response = response else {
                    let error = error ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: error)
                }
                continuation.resume(returning: (url, response))
            }
            downloadTask.resume()
        }
    }
}
