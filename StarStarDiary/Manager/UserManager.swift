//
//  UserManager.swift
//  StarStarDiary
//
//  Created by juhee on 2020/02/17.
//  Copyright © 2020 mash-up. All rights reserved.
//

import Foundation

final class UserManager {
    static let share = UserManager()
    
    private (set) var user: UserDto?
    
    func login(with user: UserDto) {
        self.user = user
    }
    
    func checkTokenValidation() {
        
    }
    
}
