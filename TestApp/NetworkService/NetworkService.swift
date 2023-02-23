//
//  NetworkService.swift
//  TestApp
//
//  Created by Eugene Kudritsky on 20.02.23.
//

import Foundation

final class NetworkService {

  //MARK: - Send request

  func getDoors(completion: @escaping (Result<[DoorsModel], Error>) -> Void) {
    print("Calling API")
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
      print("Return Result")
      let models = self.prepareModels()
      completion(.success(models))
    }
  }

  //MARK: - Send door open verification

  func sendDoorOpenVerification(completion: @escaping (Result<DoorStatus, NSError>) -> Void) {
    print("Send request verification")
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
      print("Return verification result")
      self.prepareVerificationResult(completion: completion)
      DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
        print("Status locked")
        let status = DoorStatus.lockedStatus
        completion(.success(status))
      }
    }
  }

  //MARK: - Prepare Verification

  private func prepareVerificationResult(completion: @escaping (Result<DoorStatus, NSError>) -> Void) {
    let status = DoorStatus.unlockedStatus
    let error: NSError? = nil
    guard error == nil else {
      return completion(.failure(NSError(domain: "", code: 0)))
    }
    print("Status updated")
    completion(.success(status))
  }

  //MARK: - Prepare Models

  private func prepareModels() -> [DoorsModel] {
    let models = [
      DoorsModel(name: "Door 1", location: .office, status: .lockedStatus),
      DoorsModel(name: "Door 2", location: .home, status: .lockedStatus),
      DoorsModel(name: "Door 3", location: .garage, status: .lockedStatus),
      DoorsModel(name: "Door 4", location: .office, status: .lockedStatus),
      DoorsModel(name: "Door 5", location: .office, status: .lockedStatus),
      DoorsModel(name: "Door 6", location: .home, status: .lockedStatus)
    ]
    return models
  }
}
