//
//  HeroFetcher.swift
//  MarvelDemo
//
//  Created by Apocalapsus on 18/08/19.
//  Copyright © 2019 Carlos. All rights reserved.
//

import Foundation
import CommonCrypto

enum HeroEndpoint: String {
    case heroStream = "https://gateway.marvel.com/v1/public/"
}

struct HeroFetcher: DataFetcher {
    let publicKey = "b35ccd7245dde29dd7be85364e8a70e2"
    let privateKey = "2c5d37bff0912ce6bf9f647e117908bda4751cf9"
    
    var md5: (String) -> String = { str in
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(str, CC_LONG(str.utf8.count), &digest)
        return digest.reduce("") {
            $0 + String(format: "%02x", $1)
        }
    }
    
    func fetchHeroStream(endpoint: HeroEndpoint, offset: Int, completion: @escaping ([String: Any]) -> ()) {
        let timestamp = String(Date().timeIntervalSinceReferenceDate)
        let hash = md5(timestamp + privateKey + publicKey)
        let endpointURL = endpoint.rawValue + "characters?apikey=\(publicKey)&hash=\(hash)&ts=\(timestamp)&offset=\(String(offset))"
        fetchData(urlStr: endpointURL, completion: completion)
    }
    
    func fetchHeroRecommndations(endpoint: HeroEndpoint, heroID: String, completion: @escaping ([String: Any]) -> ()) {
        let timestamp = String(Date().timeIntervalSinceReferenceDate)
        let hash = md5(timestamp + privateKey + publicKey)
        let endpointURL = endpoint.rawValue + "comics?apikey=\(publicKey)&hash=\(hash)&ts=\(timestamp)&characters=\(heroID)"
        fetchData(urlStr: endpointURL, completion: completion)
    }
}
