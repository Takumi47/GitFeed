//
//  HttpService.swift
//  GitFeed
//
//  Created by xander on 2023/3/17.
//

import Alamofire

protocol HttpService {
    var sessionManager: Session { get set }
    func request(_ urlRequest: URLRequestConvertible) -> DataRequest
}
