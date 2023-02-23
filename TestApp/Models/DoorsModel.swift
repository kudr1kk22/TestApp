//
//  DoorsModel.swift
//  TestApp
//
//  Created by Eugene Kudritsky on 20.02.23.
//

import Foundation

struct DoorsModel: Decodable {
  let name: String
  let location: DoorLocation
  var status: DoorStatus
}

enum DoorStatus: String, Decodable {
  case lockedStatus = "Locked"
  case unlockedStatus = "Unlocked"
  case unlockingStatus = "Unlocking..."
}

enum DoorLocation: String, Decodable {
  case home = "Home"
  case garage = "Garage"
  case office = "Office"
}
