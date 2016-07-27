//
//  ConfigurableCell.swift
//  QuizApp
//
//  Created by ITK developer User on 27.07.2016.
//  Copyright © 2016 ITK developer User. All rights reserved.
//

protocol ConfigurableCell {
    associatedtype DataSource
    func configureForObject(object: DataSource)
}