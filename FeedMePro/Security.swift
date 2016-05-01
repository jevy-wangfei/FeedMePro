//
//  Security.swift
//  FeedMePro
//
//  Created by jevy on 1/05/2016.
//  Copyright © 2016 jevy.wf. All rights reserved.
//

import Foundation
    
public class Security {
        class func md5(string string: String) -> String {
            var digest = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
            if let data = string.dataUsingEncoding(NSUTF8StringEncoding) {
                CC_MD5(data.bytes, CC_LONG(data.length), &digest)
            }
            
            var digestHex = ""
            for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
                digestHex += String(format: "%02x", digest[index])
            }
            
            return digestHex
        }
    }

}
