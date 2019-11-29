//
//  Link.swift
//  PhotoGallery
//
//  Created by YuriyFpc on 11/29/19.
//  Copyright © 2019 YuriyFpc. All rights reserved.
//

import RealmSwift

class Link: Object {
    @objc dynamic var url = ""
    @objc dynamic var date: Date = Date()
}
