//
//  Assembler.swift
//  MovieDB
//
//  Created by cuonghx on 6/1/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

protocol Assembler: class,
    MainAssembler,
    CheckinAssembler,
    MyCourseAssembler,
    AppAssembler {
    
}

final class DefaultAssembler: Assembler {
}
