import Foundation
import CryptoKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let apiKey = "XXXXXXXXXXXXXXXXX"
let apiSecret = "XXXXXXXXXXXXXXXXX"
let window = "10000"
let baseUrl = "https://api.bitvavo.com"
let method = "GET"
let path = "/v2/account"
let body = ""

let timestamp = String(Int(Date().timeIntervalSince1970 * 1000))
let message = timestamp + method + path + body

func hexStringToData(_ hexString: String) -> Data? {
    var data = Data()
    var hex = hexString
    while hex.count > 0 {
        let c = hex.prefix(2)
        hex = String(hex.dropFirst(2))
        if let b = UInt8(c, radix: 16) {
            data.append(b)
        } else {
            return nil
        }
    }
    return data
}

guard let secretData = hexStringToData(apiSecret) else {
    fatalError("Failed to decode secret hex string!")
}

let key = SymmetricKey(data: secretData)
let signatureHmac = HMAC<SHA256>.authenticationCode(for: Data(message.utf8), using: key)
let signatureHex = signatureHmac.map { String(format: "%02x", $0) }.joined()

let config = URLSessionConfiguration.default
config.httpAdditionalHeaders = ["Connection": "close"]
let session = URLSession(configuration: config)

print("Timestamp: \(timestamp)")
print("Message to sign: \(message)")
print("Signature (Hex): \(signatureHex)")

var request = URLRequest(url: URL(string: baseUrl + path)!)
request.httpMethod = method
request.setValue(apiKey, forHTTPHeaderField: "Bitvavo-Access-Key")
request.setValue(timestamp, forHTTPHeaderField: "Bitvavo-Access-Timestamp")
request.setValue(signatureHex, forHTTPHeaderField: "Bitvavo-Access-Signature")
request.setValue(window, forHTTPHeaderField: "Bitvavo-Access-Window")
request.setValue("application/json", forHTTPHeaderField: "Content-Type")
request.setValue("CeLaTradeX/1.0 (MacOS)", forHTTPHeaderField: "User-Agent")
request.setValue("close", forHTTPHeaderField: "Connection")

let task = session.dataTask(with: request) { data, response, error in
    if let error = error {
        print("Error:", error)
        return
    }
    if let http = response as? HTTPURLResponse {
        print("HTTP status:", http.statusCode)
    }
    if let data = data, let text = String(data: data, encoding: .utf8) {
        print("Raw response:\n\(text)")
    }
}
task.resume()
