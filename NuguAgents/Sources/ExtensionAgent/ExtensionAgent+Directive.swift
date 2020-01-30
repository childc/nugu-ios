//
//  ExtensionAgent+Directive.swift
//  NuguCore
//
//  Created by yonghoonKwon on 25/07/2019.
//  Copyright (c) 2019 SK Telecom Co., Ltd. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

import NuguCore

// MARK: - CapabilityDirectiveAgentable

extension ExtensionAgent {
    public enum DirectiveTypeInfo: CaseIterable {
        case action
    }
}

// MARK: - DirectiveTypeInforable

extension ExtensionAgent.DirectiveTypeInfo: DirectiveTypeInforable {
    public var namespace: String { "Extension" }
    
    public var name: String {
        switch self {
        case .action: return "Action"
        }
    }
    
    public var medium: DirectiveMedium {
        switch self {
        case .action: return .none
        }
    }
    
    public var isBlocking: Bool {
        switch self {
        case .action: return false
        }
    }
}