//
//  NetworkManager.swift
//  SurfaceTracker
//
//  Created by Алексей on 16.05.17.
//  Copyright © 2017 tetofa. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import ObjectMapper

class NetworkManager {
  static let baseUrl = "http://165.227.135.67"
  static let apiPrefix = "/"

  static func doRequest(_ path: APIPath, _ params: Parameters = [:], _ headers: HTTPHeaders = [:]) -> Promise<Any> {
    debugPrint(params)
    return Promise() { fullfill, reject in

      UIApplication.shared.isNetworkActivityIndicatorVisible = true
      let url = URL(string: self.baseUrl + self.apiPrefix + path.endpoint)!

      var headers = headers
      headers["accept"] = "application/json"

      Alamofire.request(url, method: path.method, parameters: params, encoding: path.encoding, headers: headers)
        .validate(statusCode: 200..<300)
        .responseJSON { response in
          UIApplication.shared.isNetworkActivityIndicatorVisible = false
          debugPrint(response)
          switch response.result {
          case .success:
            if let responseObj = Mapper<SurfaceTrackerResponse>().map(JSONObject: response.result.value) {
              guard let data = responseObj.data, responseObj.status == "ok" else { return reject(DataError.unknown) }
              fullfill(data)
            } else {
              reject(DataError.unexpectedResponseFormat)
            }
          case .failure:
            if let error = response.result.error {
              guard let alamofireError = error as? AFError else { return reject(error) }
              switch alamofireError {
              case .responseSerializationFailed(reason: .inputDataNilOrZeroLength):
                fullfill(())
              default:
                reject(error)
              }
            } else {
              reject(DataError.unexpectedResponseFormat)
            }
            reject(getError(response.response?.statusCode))
          }
      }
    }
  }

  static func getError(_ statusCode: Int?) -> DataError {
    guard let statusCode = statusCode else { return .unknown }

    switch statusCode {
    case 422: return .unprocessableData
    case 503, 500: return .serverUnavaliable
    default: return .unknown
    }
  }
}

class SurfaceTrackerResponse: Mappable {
  var status: String = ""
  var data: Any? = nil

  required init(map: Map) { }

  func mapping(map: Map) {
    status <- map["status"]
    data <- map["response"]
  }
}
