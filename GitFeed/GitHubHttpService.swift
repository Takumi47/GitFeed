//
//  GitHubHttpService.swift
//  GitFeed
//
//  Created by xander on 2023/3/17.
//

import Alamofire

class GitHubHttpService: HttpService {
    
    var sessionManager: Session = .default
    
    func request(_ urlRequest: URLRequestConvertible) -> DataRequest {
        sessionManager.request(urlRequest).validate(statusCode: 200..<400)
    }
}
