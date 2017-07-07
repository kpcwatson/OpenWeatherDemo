//
//  RequestBuilder.swift
//  OpenWeatherDemo
//
//  Created by Kyle Watson on 7/6/17.
//  Copyright © 2017 Kyle Watson. All rights reserved.
//

import Foundation

enum RequestBuilderError: Error {
    case malformedUrl(href: String)
}

class RequestBuilder {
    
    enum HttpMethod: String {
        case HEAD, GET, POST, PUT, DELETE, OPTIONS
    }
    
    private let baseUrl: URL
    private var httpMethod = HttpMethod.GET
    private var pathTemplate: String?
    private var templateParameters: [String: Any]?
    
    init(baseUrl: URL) {
        self.baseUrl = baseUrl
    }
    
    func httpMethod(_ method: HttpMethod) -> RequestBuilder {
        httpMethod = method
        return self
    }
    
    func pathTemplate(_ template: String) -> RequestBuilder {
        pathTemplate = template
        return self
    }
    
    func templateParameters(_ params: [String: Any]) -> RequestBuilder {
        templateParameters = params
        return self
    }
    
    func build() throws -> URLRequest {
        var templateHref = baseUrl.absoluteString
        if let pathTemplate = pathTemplate {
            templateHref += pathTemplate
        }
        
        let href = URITemplate(template: templateHref).expand(templateParameters ?? [:])
        guard let url = URL(string: href) else {
            throw RequestBuilderError.malformedUrl(href: href)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        return request
    }
}
