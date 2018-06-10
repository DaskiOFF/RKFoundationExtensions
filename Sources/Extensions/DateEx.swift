//
// The MIT License (MIT)
//
// Copyright (c) 2018 Roman Kotov
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// 

import Foundation

public extension Date {
    // MARK: - String Date with format
    func string(withFormat format: String) -> String {
        let dateFormatter = makeDateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }

    // MARK: - String Date and Time
    func string(withDateStyle dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
        let dateFormatter = makeDateFormatter()
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        
        return dateFormatter.string(from: self)
    }

    var short: String {
        let dateFormatter = makeDateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        return dateFormatter.string(from: self)
    }
    
    // MARK: - String Date
    /// ≈ 12.04.2018
    var shortDate: String {
        return string(withDateStyle: .short, timeStyle: .none)
    }
    
    /// ≈ 12 апр. 2018 г.
    var mediumDate: String {
        return string(withDateStyle: .medium, timeStyle: .none)
    }
    
    /// ≈ 12 апреля 2018 г.
    var longDate: String {
        return string(withDateStyle: .long, timeStyle: .none)
    }
    
    /// ≈ четверг, 12 апреля 2018 г.
    var fullDate: String {
        return string(withDateStyle: .full, timeStyle: .none)
    }
    
    // MARK: - String Time
    /// 1:30 PM
    var shortTime: String {
        return string(withDateStyle: .none, timeStyle: .short)
    }
    
    /// 1:30:50 PM
    var mediumTime: String {
        return string(withDateStyle: .none, timeStyle: .medium)
    }
    
    /// 1:30:50 PM GMT +3
    var longTime: String {
        return string(withDateStyle: .none, timeStyle: .long)
    }
    
    /// 1:30:50 PM Moscow Standard Time
    var fullTime: String {
        return string(withDateStyle: .none, timeStyle: .full)
    }
    
    // MARK: - Private
    private func makeDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        
        return dateFormatter
    }
}
