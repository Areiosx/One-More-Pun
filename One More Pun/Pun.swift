//
//  Pun.swift
//  One More Pun
//
//  Created by Nicholas Laughter on 8/14/16.
//  Copyright © 2016 Areios. All rights reserved.
//

import Foundation

class Pun {
    
    let body: String
    let submitter: String
    let uuid: NSUUID
    let reportedCount: Int
    private let bodyKey = "Body"
    private let submitterKey = "Submitter"
    private let uuidKey = "UUID"
    private let reportedCountKey = "ReportedCount"
    
    init?(json: [String: AnyObject]) {
        guard let body = json[bodyKey] as? String,
            submmitter = json[submitterKey] as? String,
            uuid = json[uuidKey] as? NSUUID,
            reportedCount = json[reportedCountKey] as? Int else { return nil }
        self.body = body
        self.submitter = submmitter
        self.uuid = uuid
        self.reportedCount = reportedCount
    }
}