//
//  Repository.swift
//  MomCare
//
//  Created by Nam Ngây on 24/01/2022.
//

import Foundation

struct Repositories {
    let api: ApiService
    
    func createAdmin(numberPhone: String, completion: @escaping (BaseResult<Admin>) -> Void) {
        let input = AdminRequest(numberPhone: numberPhone)
        api.request(input: input) { (object : Admin?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
    
    func updateAdmin(idAdmin: String, avatar: String, name: String, address: String, email: String,
                     completion: @escaping (BaseResult<Admin>) -> Void) {
        let input = AdminRequest(idAdmin: idAdmin, avatar: avatar, name: name, address: address, email: email)
        api.request(input: input) { (object : Admin?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
    
    func getOneAdmin(idAdmin: String, completion: @escaping (BaseResult<Admin>) -> Void) {
        let input = AdminRequest(idAdmin: idAdmin)
        api.request(input: input) { (object: Admin?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
    
    func createUser(idAdmin: String, name: String, address: String, momBirth: String, numberPhone: String,
                    height: String, babyDateBorn: String, dateSave: String, note: String, avatar: String,
                    imagePregnant: String,
                    completion: @escaping (BaseResult<User>) -> Void) {
        let input = UserRequest(idAdmin: idAdmin, name: name, address: address, momBirth: momBirth, numberPhone: numberPhone, height: height, babyDateBorn: babyDateBorn, dateSave: dateSave, note: note, avatar: avatar, imagePregnant: imagePregnant)
        api.request(input: input) { (object : User?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
    
    func updateUser(idUser: String, name: String, address: String, momBirth: String, numberPhone: String,
                    height: String, babyDateBorn: String, dateSave: String, note: String, avatar: String,
                    imagePregnant: String,
                    completion: @escaping (BaseResult<User>) -> Void) {
        let input = UserRequest(idUser: idUser, name: name, address: address, momBirth: momBirth, numberPhone: numberPhone, height: height, babyDateBorn: babyDateBorn, dateSave: dateSave, note: note, avatar: avatar, imagePregnant: imagePregnant)
        api.request(input: input) { (object : User?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
    
    func getAllUser(idAdmin: String, completion: @escaping (BaseResult<SuperUser>) -> Void) {
        let input = UserRequest(idAdmin: idAdmin)
        api.request(input: input) { (object : SuperUser?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
    
    func getOneUser(idUser: String, completion: @escaping (BaseResult<User>) -> Void) {
        let input = UserRequest(idUser: idUser, type: .get)
        api.request(input: input) { (object : User?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
    
    func deleteUser(idUser: String, completion: @escaping (BaseResult<User>) -> Void) {
        let input = UserRequest(idUser: idUser)
        api.request(input: input) { (object : User?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
    
    func makeStar(idUser: String, isStar: Bool, completion: @escaping (BaseResult<User>) -> Void) {
        let input = UserRequest(idUser: idUser, isStar: isStar)
        api.request(input: input) { (object : User?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
    
    func createNote(idUser: String, time: String, image: String, completion: @escaping (BaseResult<HistoryNote>) -> Void) {
        let input = NoteRequest(idUser: idUser, time: time, image: image)
        api.request(input: input) { (object : HistoryNote?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
    
    func deleteNote(idNote: String, completion: @escaping (BaseResult<HistoryNote>) -> Void) {
        let input = NoteRequest(idNote: idNote)
        api.request(input: input) { (object : HistoryNote?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
    
    func getAllNote(idUser: String, completion: @escaping (BaseResult<HistoryNote>) -> Void) {
        let input = NoteRequest(idUser: idUser)
        api.request(input: input) { (object : HistoryNote?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
    
    func getOneNote(idNote: String, completion: @escaping (BaseResult<HistoryNote>) -> Void) {
        let input = NoteRequest(idNote: idNote, type: .get)
        api.request(input: input) { (object : HistoryNote?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
}
