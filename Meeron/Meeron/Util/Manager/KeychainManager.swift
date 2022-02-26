//
//  KeychainManager.swift
//  Meeron
//
//  Created by 심주미 on 2022/02/26.
//

import Foundation
import Security

class KeychainManager {
    func saveLoginToken(accessToken:String, refreshToken:String) -> Bool {
        if read(service: "Meeron", account: "refreshToken") == nil {
            return create(service: "Meeron", account: "accessToken", value: accessToken) && create(service: "Meeron", account: "refreshToken", value: refreshToken) ? true : false
                
        }else{
            return update(service: "Meeron", account: "accessToken", value: accessToken) && update(service: "Meeron", account: "refreshToken", value: refreshToken) ? true : false
        }
        
    }
    
    func create(service:String, account:String, value:String) -> Bool {
        let query:NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecAttrGeneric: value
        ]
        return errSecSuccess == SecItemAdd(query, nil)
    }
    
    func update(service:String, account:String, value:String) -> Bool {
        let query:NSDictionary = [
            kSecClass:kSecClassGenericPassword,
            kSecAttrService:service,
            kSecAttrAccount:account
        ]
        let attributes:NSDictionary = [kSecAttrGeneric:value]
        
        return errSecSuccess == SecItemUpdate(query, attributes)
    }
    
    func read(service:String, account:String) -> String? {
        let query:NSDictionary = [
            kSecClass:kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecReturnData: true,
            kSecReturnAttributes: true,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        var item: CFTypeRef?
        if SecItemCopyMatching(query as CFDictionary, &item) != errSecSuccess {
            return nil
        }
        guard let existingItem = item as? [String:Any], let data = existingItem[kSecAttrGeneric as String] as? String else{
            return nil
        }
        return data
    }
    
    func delete(service:String, account:String) -> Bool {
        let query:NSDictionary = [
            kSecClass:kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ]
        return errSecSuccess == SecItemDelete(query)
    }
}
