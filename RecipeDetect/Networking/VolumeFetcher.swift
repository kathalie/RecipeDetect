//
//  VolumeFetcher.swift
//  RecipeDetect
//
//  Created by Kathryn Verkhogliad on 24.06.2024.
//

import Foundation
import ARKit

fileprivate let volumeApi = "https://us-central1-ml-ar-ios.cloudfunctions.net/calculate"

func fetchVolume(pointCloud: [simd_float3], completion: @escaping (Result<Volume, Error>) -> Void) {
    guard let url = URL(string: "https://us-central1-ml-ar-ios.cloudfunctions.net/calculate") else {
        fatalError("Invalid URL")
    }

    var pointData = ""
    for point in pointCloud {
        pointData.append("\(point.x) \(point.y) \(point.z)\n")
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let bodyDict: [String: String] = ["point_cloud": pointData]
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: bodyDict, options: [])
        request.httpBody = jsonData
    } catch {
        completion(.failure(error))
        return
    }

    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            let errorDescription = HTTPURLResponse.localizedString(forStatusCode: statusCode)
            completion(.failure(NSError(domain: "HTTPError", code: statusCode, userInfo: [NSLocalizedDescriptionKey: errorDescription])))
            return
        }
 
        do {
            if let data = data {
                let volume = try JSONDecoder().decode(Volume.self, from: data)
                completion(.success(volume))
            } else {
                completion(.failure(NSError(domain: "ResponseError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data in response"])))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    task.resume()
}
