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

public extension Encodable {
    func encode() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }

    var jsonDict: [AnyHashable: Any?]? {
        guard let data = encode(),
            let dict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
            let jsonDict = dict as? [AnyHashable: Any?] else {
                return nil
        }

        return jsonDict
    }
}

public extension Decodable {
    static func parse(from json: Any) -> Self? {
        if let data = json as? Data {
            return try? JSONDecoder().decode(Self.self, from: data)
        }
        
        guard let data = try? JSONSerialization.data(withJSONObject: json, options: []),
            let value = try? JSONDecoder().decode(Self.self, from: data) else {
                return nil
        }
        
        return value
    }
    
    static func parse(fromArray json: Any) -> [Self]? {
        if let data = json as? Data {
            return try? JSONDecoder().decode([Self].self, from: data)
        }
        
        guard let data = try? JSONSerialization.data(withJSONObject: json, options: []),
            let value = try? JSONDecoder().decode([Self].self, from: data) else {
                return nil
        }
        
        return value
    }
}
