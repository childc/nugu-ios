//
//  SessionManageable.swift
//  NuguAgents
//
//  Created by MinChul Lee on 2020/05/28.
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

public protocol SessionManageable: class {
    /// Adds a delegate to be notified of `Session` changes.
    /// - Parameter delegate: The object to add.
    func add(delegate: SessionDelegate)
    
    /// Removes a delegate from session-manager.
    /// - Parameter delegate: The object to remove.
    func remove(delegate: SessionDelegate)
    
    var activeSessions: [Session] { get }
    
    func set(session: Session)
    func activate(dialogRequestId: String, category: CapabilityAgentCategory)
    func deactivate(dialogRequestId: String, category: CapabilityAgentCategory)
}
