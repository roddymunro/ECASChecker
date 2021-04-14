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
    
    private let baseUrl = URL(string: "https://services3.cic.gc.ca/ecas")!
    
    // MARK: - Application Status
    
    func getStatus(idType: String, idNum: String, lastName: String, birthDate: String, country: String, _ completion: @escaping (Result<Application, Error>) -> Void) {
        let endpoint = "authenticate.do"
        var request = URLRequest(url: baseUrl.appendingPathComponent(endpoint))
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("?0", forHTTPHeaderField: "sec-ch-ua-mobile")
        request.setValue("\"Google Chrome\";v=\"89\", \"Chromium\";v=\"89\", \";Not A Brand\";v=\"99\"", forHTTPHeaderField: "sec-ch-ua")
        
        let params = "lang=&_page=_target0&app=ecas&identifierType=\(idType)&identifier=\(idNum)&surname=\(lastName)&dateOfBirth=\(birthDate)&countryOfBirth=\(country)&_submit=Continue"
        let bodyData = params.data(using: .utf8)
        
        URLSession.shared.uploadTask(with: request, from: bodyData) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
            }
            
            if let url = response?.url {
                HTTPCookieStorage.shared.cookies(for: url)
            }
            
            if let data = data {
                if let status = self.parseApplicationStatus(String(data: data, encoding: .utf8) ?? "") {
                    completion(.success(status))
                } else {
                    completion(.failure(StatusError.applicationParsingError))
                }
            }
        }.resume()
    }
    
    private func parseApplicationStatus(_ content: String) -> Application? {
        do {
            let html = try SwiftSoup.parse(content)
            guard let table = try html.select("tbody").first() else { throw StatusError.applicationParsingError }
            let cols = try table.select("td")
            if cols.count == 2 {
                return Application(
                    name: try cols[0].text(),
                    sponsorStatus: .init(status: "Not Available"),
                    prStatus: .init(status: try cols[1].text(), endpoint: try cols[1].select("a").attr("href"))
                )
            } else if cols.count >= 3 {
                
                return Application(
                    name: try cols[0].text(),
                    sponsorStatus: .init(status: try cols[1].text(), endpoint: try cols[1].select("a").attr("href")),
                    prStatus: .init(status: try cols[2].text(), endpoint: try cols[2].select("a").attr("href"))
                )
            } else {
                throw StatusError.applicationParsingError
            }
            
        } catch Exception.Error(let type, let message) {
            print(type)
            print(message)
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    // MARK: - Application Status Details
    
    func getStatusDetail(from endpoint: String, _ completion: @escaping (Result<[String], Error>) -> Void) {
        var request = URLRequest(url: URL(string: "\(baseUrl.absoluteString)/\(endpoint)")!)
        request.httpMethod = "GET"
        
        if let cookie = HTTPCookieStorage.shared.cookies?.first {
            request.setValue("\(cookie.name)=\(cookie.value)", forHTTPHeaderField: "Cookie")
            request.httpShouldHandleCookies = true
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(error))
            }
            
            if let url = response?.url {
                print(url.absoluteString)
            }
            
            if let data = data {
                if let status = self.parseDetailStatus(String(data: data, encoding: .utf8) ?? "") {
                    completion(.success(status))
                } else {
                    completion(.failure(StatusError.statusParsingError))
                }
            }
        }.resume()
    }
    
    private func parseDetailStatus(_ content: String) -> [String]? {
        do {
            let html = try SwiftSoup.parse(content)
            if try html.select("ol").count > 1 {
                let list = try html.select("ol")[1]
                let items = try list.select("li")
                return try items.map {
                    try $0.text()
                }
            } else {
                throw StatusError.statusParsingError
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
