//
//  NetworkInterceptorProvider.swift
//  GraphQLDemo
//
//  Created by Thorben Hebbelmann on 29.12.21.
//

import Foundation
import Apollo

class NetworkInterceptorProvider: DefaultInterceptorProvider {
    override func interceptors<Operation: GraphQLOperation>(for operation: Operation) -> [ApolloInterceptor] {
        var interceptors = super.interceptors(for: operation)
        interceptors.insert(TokenAddingInterceptor(), at: 0)
        return interceptors
    }
}

