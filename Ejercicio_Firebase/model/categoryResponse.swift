//
//  categoryResponse.swift
//  Ejercicio_Firebase
//
//  Created by Jose Leoncio Quispe Rodriguez on 25/11/21.
//

import Foundation

class CategoryResponse {
    var userId: String?
    var name: String?
    var id: String?
    var imagen: String?
 
    init(userId:String?, name:String?, id:String?, imagen:String?) {
        self.userId = userId
        self.name = name
        self.id = id
        self.imagen = imagen
    }
}
