import Foundation
import CryptoKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let apiKey = "xxxxxXxxxXxxXxxxxxxxxxxxxxxxxxxxxxxxxxx"
let apiSecret = "xxxxxXxxxXxxXxxxxxxxxxxxxxxxxxxxxxxxxxx"

let urlPath = "/0/private/Balance"
let url = URL(string: "https://api.kraken.com\(urlPath)")!
let nonce = String(Int(Date().timeIntervalSince1970 * 1000))


let bodyString = "nonce=\(nonce)"
let bodyData = bodyString.data(using: .utf8)!


func generateKrakenSignature(path: String, nonce: String, postData: Data, secret: String) -> String {
   
    let sha256Digest = SHA256.hash(data: nonce.data(using: .utf8)! + postData)
    let fullMessage = path.data(using: .utf8)! + Data(sha256Digest)


    guard let keyData = Data(base64Encoded: secret) else {
        print("Could not decode API secret from Base64")
        return ""
    }
    

    let key = SymmetricKey(data: keyData)
    let hmac = HMAC<SHA512>.authenticationCode(for: fullMessage, using: key)
    return Data(hmac).base64EncodedString()
}

let signature = generateKrakenSignature(
    path: urlPath,
    nonce: nonce,
    postData: bodyData,
    secret: apiSecret
)

print("Nonce: \(nonce)")
print("Signature: \(signature)")

var request = URLRequest(url: url)
request.httpMethod = "POST"
request.httpBody = bodyData
request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
request.setValue(apiKey, forHTTPHeaderField: "API-Key")
request.setValue(signature, forHTTPHeaderField: "API-Sign")

let task = URLSession.shared.dataTask(with: request) { data, response, error in
    if let error = error {
        print("Request error: \(error)")
        return
    }

    if let httpResponse = response as? HTTPURLResponse {
        print("HTTP Status: \(httpResponse.statusCode)")
    }

    if let data = data, let responseText = String(data: data, encoding: .utf8) {
        print("Kraken Response:\n\(responseText)")
    }
}

task.resume()
