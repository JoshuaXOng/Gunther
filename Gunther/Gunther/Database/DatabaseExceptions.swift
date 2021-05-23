//
//  DatabaseExceptions.swift
//  Gunther
//
//  Created by user184453 on 5/23/21.
//

import Foundation

enum DatabaseExceptions: Error {
    case catchAllException(String) // :]
    case invalidResource(String)
}
