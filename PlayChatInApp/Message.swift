//
//  Message.swift
//  PlayChatInApp
//
//  Created by Chowdhury Md Rajib Sarwar on 16/1/19.
//  Copyright © 2019 Chowdhury Md Rajib Sarwar. All rights reserved.
//

import UIKit

class Message: NSObject {
    var fromId: String?
    var text: String?
    var timestamp: NSNumber?
    var toId: String?
    
    /*
     fromId = Wcktmh6W3GOOnTYussneFxC0ikH2;
     text = "";
     timestamp = 1547648758;
     toId = dgPx08VSoKQ2lAcxlzO1j2Dh0Qp2;
     */
    
    func initWithInfo(info: [String: AnyObject]) {
        if let fromId = info["fromId"] as? String {
            self.fromId = fromId
        }
        if let text = info["text"] as? String {
            self.text = text
        }
        if let timestamp = info["timestamp"] as? NSNumber {
            self.timestamp = timestamp
        }
        if let toId = info["toId"] as? String {
            self.toId = toId
        }
    }
}
