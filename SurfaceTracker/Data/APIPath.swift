//
//  APIPath.swift
//  SurfaceTracker
//
//  Created by Алексей on 17.05.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import Alamofire

enum APIPath {
  case sendBumps
  case fetchBumps

  var endpoint: String {
    switch self {
    case .sendBumps, .fetchBumps:
      return "bumps"
    }
  }

  var successCode: Int {
    switch self {
    case .sendBumps:
      return 201
    default:
      return 200
    }
  }

  var method: HTTPMethod {
    switch self {
    case .sendBumps:
      return .post
    default:
      return .get
    }
  }

  var encoding: ParameterEncoding {
    switch method {
    case .get, .delete:
      return URLEncoding.default
    default:
      return JSONEncoding.default
    }
  }

}
