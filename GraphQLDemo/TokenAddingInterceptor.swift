//
//  TokenAddingInterceptor.swift
//  GraphQLDemo
//
//  Created by Thorben Hebbelmann on 29.12.21.
//

import Foundation
import Apollo

class TokenAddingInterceptor: ApolloInterceptor {
    let token = "<YOUR_TOKEN>"

    func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) {
            
            request.addHeader(name: "Authorization", value: "Bearer \(token)")
            chain.proceedAsync(request: request,
                               response: response,
                               completion: completion)
        }
}
