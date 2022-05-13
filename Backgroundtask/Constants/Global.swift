//Copyright © 2022 and Confidential to ___ORGANIZATIONNAME___ All rights reserved.

import Foundation

struct Global {
    
    /// Base url of the backend
    static var baseUrl: String{
       return "https://g2wtafacerecognition.gotowhoatalent.com/"
    }
    
    /// Email of the backend
    static var email: String{
       return "nguyenthuy1@gmail.com"
    }
    
    /// App name
    static var appName: String{
       return "Local Notification Sample"
    }
    
    //API key
    static var apiKey: String {
        return "Bl^ESKY!INT@GRV"
    }
    
    //Backgrounf task schedule time
    static var taskInterval: Int {
        return 1 * 60 //1 minutes
    }
}
