//
//  WebHelper.swift
//  Hepsiburada
//
//  Created by macbookair on 22.09.2018.
//  Copyright © 2018 Erim Kurt. All rights reserved.
//

import UIKit

open class WebHelper: NSObject {

    var pathUrl = "https://www.hepsiburada.com/api/"
    
    enum JSONServices : String{
        case userInterfaceSchema = "UserInterfaceSchema"
        case list = "List"
        case productList = "ProductList"
        case carousel = "Carousel"
        case banner = "Banner"
    }
    
    static let sharedInstance: WebHelper = {
        let instance = WebHelper()
        return instance
    } ()
    
    //MARK: Get Product Grid List
    open func getProductGrid(success: ((_ response : Any) -> ())? = nil){
        let url = URL(string: "\(pathUrl)\(JSONServices.productList.rawValue)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            do {
                //Dummy JSON Local File
                let jsonData = try JSONDecoder().decode([ProductGrid].self, from: self.loadJSON(resourceName: "\(JSONServices.productList.rawValue)"))
                //print(jsonData)
                success!(jsonData)
            } catch {
                print("\(error)")
            }
        }
        task.resume()
    }
    
    //MARK: Get Banner List
    open func getList(success: ((_ response : Any) -> ())? = nil){
        let url = URL(string: "\(pathUrl)\(JSONServices.list.rawValue)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            do {
                //Dummy JSON Local File
                let jsonData = try JSONDecoder().decode([List].self, from: self.loadJSON(resourceName: "\(JSONServices.list.rawValue)"))
                //print(jsonData)
                success!(jsonData)
            } catch {
                print("\(error)")
            }
        }
        task.resume()
    }
    
    //MARK: Get User Interface Schema
    open func getUserInterfaceSchema(success: ((_ response : Any) -> ())? = nil){
        let url = URL(string: "\(pathUrl)\(JSONServices.userInterfaceSchema.rawValue)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            do {
                //Dummy JSON Local File
                let jsonData = try JSONDecoder().decode([UserSchema].self, from: self.loadJSON(resourceName: "\(JSONServices.userInterfaceSchema.rawValue)"))
                //print(jsonData)
                success!(jsonData)
            } catch {
                print("\(error)")
            }
        }
        task.resume()
    }
    
    //MARK: Get Carousel Gallery
    open func getCarousel(success: ((_ response : Any) -> ())? = nil){
        let url = URL(string: "\(pathUrl)\(JSONServices.carousel.rawValue)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            do {
                //Dummy JSON Local File
                let jsonData = try JSONDecoder().decode(Carousel.self, from: self.loadJSON(resourceName: "\(JSONServices.carousel.rawValue)"))
                //print(jsonData)
                success!(jsonData)
            } catch {
                print("\(error)")
            }
        }
        task.resume()
    }
    
    //MARK: Get Product Banner
    open func getBanner(success: ((_ response : Any) -> ())? = nil){
        let url = URL(string: "\(pathUrl)\(JSONServices.banner.rawValue)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            do {
                //Dummy JSON Local File
                let jsonData = try JSONDecoder().decode(Banner.self, from: self.loadJSON(resourceName: "\(JSONServices.banner.rawValue)"))
                //print(jsonData)
                success!(jsonData)
            } catch {
                print("\(error)")
            }
        }
        task.resume()
    }

    open func loadJSON(resourceName: String) -> Data{
        if let path = Bundle.main.path(forResource: resourceName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
            } catch {
                // handle error
            }
        }
        return Data()
    }
}
