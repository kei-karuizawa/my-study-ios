//
//  KCKBundle.swift
//  KirihaCodeKit
//
//  Created by 河瀬雫 on 2022/1/10.
//

import Foundation

public extension Bundle {
    
    @objc
    static func kiriha_resource(forBundleName name: String) -> Bundle? {
        guard let bundle = Bundle.main.url(forResource: name, withExtension: "bundle") else {
            return nil
        }
        let currentBundle: Bundle? = Bundle(url: bundle)
        return currentBundle
    }
    
    @objc
    static func kiriha_resource(forClass aClass: AnyClass, resource: String) -> Bundle? {
        let bundle: Bundle = Bundle(for: aClass)
        guard let url = bundle.url(forResource: resource, withExtension: "bundle") else {
            return nil
        }
        return Bundle(url: url)
    }
    
    @objc
    static func kirihaBundle() -> Bundle {
        return Bundle.kiriha_resource(forBundleName: "Kiriha")!
    }
    
}

