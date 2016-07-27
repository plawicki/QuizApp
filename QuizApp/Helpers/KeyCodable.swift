//
//  KeyCodable.swift
//  QuizApp
//
//  Created by ITK developer User on 27.07.2016.
//  Copyright © 2016 ITK developer User. All rights reserved.
//

import CoreData

public protocol KeyCodable {
    associatedtype Keys: RawRepresentable
}