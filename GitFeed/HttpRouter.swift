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
        var url = try baseUrlString.asURL()
        url.appendPathComponent(path)
        
        var request = try URLRequest(url: url, method: method, headers: headers)
        request.httpBody = try body()
        
        return request
    }
    
    func request(usingHttpService service: HttpService) throws -> DataRequest {
        try service.request(asUrlRequest())
    }
}
