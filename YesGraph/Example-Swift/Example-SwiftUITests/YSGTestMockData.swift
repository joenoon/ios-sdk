//
//  YSGTestMockData.swift
//  Example-Swift
//
//  Created by Nejc Vivod on 11/10/15.
//  Copyright © 2015 Dal Rupnik. All rights reserved.
//

import Foundation
import YesGraphSDK

class YSGTestMockData: NSObject {
    class var mockContactList : [YSGContact] {
        var retList = [YSGContact]();
        let c1 = YSGContact();
        c1.name = "Daniel Higgins Jr.";
        c1.emails = ["d-higginsmac.com"];
        retList.append(c1);
        
        let c2 = YSGContact();
        c2.name = "Anna Haro";
        c2.emails = ["anna-haromac.com"];
        retList.append(c2);
        
        let c3 = YSGContact();
        c3.name = "Hank M. Zakroff";
        c3.emails = ["hank-zakroffmac.com"];
        retList.append(c3);
        
        let c4 = YSGContact();
        c4.name = "Kate Bell";
        c4.emails = ["kate-bellmac.com"];
        retList.append(c4);
        
        let c5 = YSGContact();
        c5.name = "John Appleseed";
        c5.emails = ["John-Appleseedmac.com"];
        retList.append(c5);
        
        let c6 = YSGContact();
        c6.name = "David Taylor";
        c6.phones = ["555-610-6679"];
        retList.append(c6);
        
        return retList;
    }
}