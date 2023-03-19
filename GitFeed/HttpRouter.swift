//
//  HttpRouter.swift
//  GitFeed
//
//  Created by xander on 2023/3/17.
//

import Alamofire


protocol HttpRouter {
    var baseUrlString: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get } // TODO:
    var parameters: Parameters? { get }
    func body() throws -> Data?
    func request(usingHttpService service: HttpService) throws -> DataRequest
}

extension HttpRouter {
    var headers: HTTPHeaders? { nil }
    var parameters: Parameters? { nil }
    func body() throws -> Data? { nil }
    
    func asUrlRequest() throws -> URLRequest {
        var comp = URLComponents(string: baseUrlString + path)!
        if let parameters = parameters, !parameters.isEmpty {
            var queryItems: [URLQueryItem] = []
            for (key, value) in parameters {
                guard let val = value as? String else { continue }
                queryItems.append(URLQueryItem(name: key, value: val))
            }
            comp.queryItems = queryItems
        }
        
        let url = try comp.asURL()
        var request = try URLRequest(url: url, method: method, headers: headers)
        request.httpBody = try body()
        
        return request
    }
    
    func request(usingHttpService service: HttpService) throws -> DataRequest {
        try service.request(asUrlRequest())
    }
}
