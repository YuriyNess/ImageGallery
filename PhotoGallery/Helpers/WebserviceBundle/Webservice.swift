//
//  Webservice.swift
//  Statistic
//
//  Created by YuriyFpc on 7/28/19.
//  Copyright © 2019 YuriyFpc. All rights reserved.
//

import Foundation

final class Webservice: NSObject {
    
    var errorPresenter: ((Error) -> Void)?
    private lazy var session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    
    func get<A>(resource: Resource<A>, completion: @escaping (A?) throws -> (), errorComplition: @escaping (Error?) -> ()) {
        guard let request = createGetRequest(resource: resource) else { return }
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                let webError = WebserviceError(code: .get, underlying: error)
                errorComplition(webError)
                return
            }
            do {
                try completion(resource.parse(data))
            } catch {
                let webError = WebserviceError(code: .get, underlying: error)
                errorComplition(webError)
            }
        }.resume()
    }
    
    func post<A>(resource: Resource<A>, completion: @escaping (A?) throws -> (), errorComplition: @escaping (Error?) -> ()) {
        
        do {
            guard let request = try createPostRequest(resource: resource) else { return }
            session.dataTask(with: request) { (data, response, error) in
                guard let data = data, error == nil else {
                    let webError = WebserviceError(code: .post, underlying: error)
                    errorComplition(webError)
                    return
                }
                do {
                    try completion(resource.parse(data))
                } catch {
                    let webError = WebserviceError(code: .post, underlying: error)
                    errorComplition(webError)
                }
            }.resume()
        } catch {
            errorComplition(error)
        }
    }
    
}

//MARK: Helper methods
extension Webservice {
    private func createGetRequest<A>(resource: Resource<A>) -> URLRequest? {
        var url = resource.url
        if let params = resource.params {
            url = createGETURLWithParams(url: url, params: params)!
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let headers = resource.headers {
            requestWithHeaders(request: &request, headers: headers)
        }
        
        return request
    }
    
    private func createPostRequest<A>(resource: Resource<A>) throws -> URLRequest? {
        var request = URLRequest(url: resource.url)
        request.httpMethod = "POST"
        
        if let params = resource.params {
                if JSONSerialization.isValidJSONObject(params) {
                    request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                } else {
                    throw WebserviceError(code: .createPostRequest, systemMsg: "Unable to serialize request params")
                }
        }
        
        if let headers = resource.headers {
            requestWithHeaders(request: &request, headers: headers)
        }
        
        return request
    }
    
    private func requestWithHeaders(request: inout URLRequest, headers: [String: String]) {
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
    }
    
    private func createGETURLWithParams(url: URL, params: [String: Any]) -> URL? {
        var paramsString = "?"
        let stringUrl = url.absoluteString
        for (index, key) in params.keys.enumerated() {
            if index > 0 {
                paramsString = paramsString + "&"
            }
            if let value = params[key] {
                paramsString = paramsString + key + "=" + "\(value)"
            }
        }
        let resultString = stringUrl + paramsString
        return URL(string: resultString)
    }
    
}

extension Webservice: URLSessionDelegate {

}
