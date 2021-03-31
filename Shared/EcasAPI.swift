//
//  EcasAPI.swift
//  ECASChecker
//
//  Created by Roddy Munro on 29/03/2021.
//

import Foundation
import SwiftSoup

class EcasAPI {
    
    private init() { }
    static let shared = EcasAPI()
    
    private let url = URL(string: "https://services3.cic.gc.ca/ecas/authenticate.do")!
    
    func getStatus(idType: String, idNum: String, lastName: String, birthDate: String, country: String, _ completion: @escaping (Result<ApplicationStatus, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("?0", forHTTPHeaderField: "sec-ch-ua-mobile")
        request.setValue("\"Google Chrome\";v=\"89\", \"Chromium\";v=\"89\", \";Not A Brand\";v=\"99\"", forHTTPHeaderField: "sec-ch-ua")
        
        let params = "lang=&_page=_target0&app=ecas&identifierType=\(idType)&identifier=\(idNum)&surname=\(lastName)&dateOfBirth=\(birthDate)&countryOfBirth=\(country)&_submit=Continue"
        let bodyData = params.data(using: .utf8)
        
        URLSession.shared.uploadTask(with: request, from: bodyData) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
            }
            
            if let data = data {
                if let status = self.parseWebContent(String(data: data, encoding: .utf8) ?? "") {
                    completion(.success(status))
                } else {
                    completion(.failure(StatusError.parsingError))
                }
            }
        }.resume()
    }
    
    func parseWebContent(_ content: String) -> ApplicationStatus? {
        do {
            let html = try SwiftSoup.parse(content)
            guard let table = try html.select("tbody").first() else { throw StatusError.parsingError }
            let cols = try table.select("td")
            if cols.count == 2 {
                return ApplicationStatus(name: try cols[0].text(), sponsorStatus: "Not Available", prStatus: try cols[1].text())
            } else if cols.count >= 3 {
                return ApplicationStatus(name: try cols[0].text(), sponsorStatus: try cols[1].text(), prStatus: try cols[2].text())
            } else {
                throw StatusError.parsingError
            }
            
        } catch Exception.Error(let type, let message) {
            print(type)
            print(message)
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
