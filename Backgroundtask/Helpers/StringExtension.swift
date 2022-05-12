//Copyright © 2022 and Confidential to ___ORGANIZATIONNAME___ All rights reserved.
   

import Foundation

public extension Optional where Wrapped == String {
    
    /// Unwrap string, return empty string when nil
    var safeUnwrapped: String {
        guard let self = self else { return "" }
        return self
    }
    
}
