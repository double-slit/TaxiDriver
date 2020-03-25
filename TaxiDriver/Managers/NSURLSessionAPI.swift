//
//  NSURLSessionAPI.swift
//  NotiphiMe
//
//  Created by Shivani Bajaj on 23/11/16.
//  Copyright © 2016 Shivani Bajaj. All rights reserved.
//

import UIKit
import MobileCoreServices

class NSURLSessionAPI: NSObject {
  
    //MARK:- Variables
    
  static let sharedInstance = NSURLSessionAPI()
    
    //MARK:- Lifecycle Methods
    
  override init() {
    super.init()
  }
  
  class func getJSON(withUrl url:String,withParameters params:[String:Any],success:@escaping ([String:Any]) -> (),failure:@escaping (String) -> ())
  {
    var urlToSend:String = ""
    var newUrl = url
    if params.count > 0 {
      newUrl = url + "?"
      for (key,value) in params {
        newUrl = "\(newUrl)\(key)=\(value)&"
      }
      urlToSend = newUrl.substring(to: newUrl.characters.index(newUrl.startIndex, offsetBy: newUrl.characters.count - 1))
    }
    
    urlToSend = urlToSend.replacingOccurrences(of: " ", with: "%20")
    
    var request = URLRequest(url: URL(string: urlToSend)!)
    let session = URLSession.shared
    request.httpMethod = "GET"
    
    let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
      
      if error != nil {
        DispatchQueue.main.async(execute: {
          
          failure(error!.localizedDescription)
        })
      }
      else {
        let httpResponse = response as! HTTPURLResponse
        if httpResponse.statusCode == 200
        {
          do {
            let responseDict = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            DispatchQueue.main.async(execute: {
              
              success(responseDict as! [String : Any])
            })
          }
          catch {
            
            DispatchQueue.main.async(execute: {
              
              failure("ErrorMsg")
            })
            
          }
        }
        else
        {
          DispatchQueue.main.async(execute: {
            
            failure("ErrorMsg")
          })
        }
      }
    })
    task.resume()
  }
  
  
  
  
    class func postWithImage(withUrl tourl:String,withParameters params:[String:Any],withFileNames files:[String:Data],success:@escaping ([String:Any]) -> (),failure:@escaping (String) -> ())
  {
    let url = URL(string: tourl)
    
    var request:URLRequest = URLRequest(url: url!)
    request.httpMethod = "POST"
    
    let boundary = generateBoundaryString()
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    let body = NSMutableData()
    let mimetype = "image/jpg"
    
    let session = URLSession.shared
    
    for (key,value) in params
    {
      body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
      body.append("Content-Disposition:form-data;name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
      body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
    }
    
    for (key,value) in files {
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"\(key)\"; filename=\"\(key).jpg\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(value)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
    }
    
    body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
    request.httpBody = body as Data
    
    let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
      
      guard let _:Data = data, let _:URLResponse = response, error == nil else {
        failure("ErrorMsg")
        return
      }
      let httpResponse = response as! HTTPURLResponse
      if httpResponse.statusCode == 200 {
        do {
          let jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
          
          DispatchQueue.main.async(execute: {
            success(jsonData as! [String : Any])
          })
        }
        catch {
          DispatchQueue.main.async(execute: {
            
            failure("ErrorMsg")
          })
        }
      }
      else {
        failure("ErrorMsg")
      }
    })
    task.resume()
  }
  
  
  
  class func postAudioVideo(withUrl tourl:String,withParameters params:[String:Any],withAudioData audio_data:Data,filename:String,parameterName:String,isAudio:Bool,success:@escaping ([String:Any]) -> (),failure:@escaping (String) -> ())
  {
    let url = URL(string: tourl)
    
    var request:URLRequest = URLRequest(url: url!)
    request.httpMethod = "POST"
    
    let boundary = generateBoundaryString()
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    let body = NSMutableData()
//    let fname = "\(filename).mp3"
    let fname = "\(filename)"
    let name = parameterName
//    let mimetype = "audio/mpeg"
    let mimetype = (isAudio) ? "audio/*" : "video/*"

    
    let session = URLSession.shared
    
    for (key,value) in params
    {
      body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
      body.append("Content-Disposition:form-data;name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
      body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
    }
    
    body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
    body.append("Content-Disposition:form-data; name=\"\(name)\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
    body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
    body.append(audio_data)
    body.append("\r\n".data(using: String.Encoding.utf8)!)
    
    
    body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
    request.httpBody = body as Data
    
    let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
      
      guard let _:Data = data, let _:URLResponse = response, error == nil else {
        failure("ErrorMsg")
        return
      }
      let httpResponse = response as! HTTPURLResponse
      if httpResponse.statusCode == 200 {
        do {
          let jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
          
          DispatchQueue.main.async(execute: {
            success(jsonData as! [String : Any])
          })
        }
        catch {
          DispatchQueue.main.async(execute: {
            
            failure("ErrorMsg")
          })
        }
      }
      else {
        failure("ErrorMsg")
      }
    })
    task.resume()
  }

  
  
  
  class func postJSONMultipart(withUrl tourl:String,withParameters params:[String:Any],imageDataArray:[Data],success:@escaping ([String:Any]) -> (),failure:@escaping (String) -> ())
  {
    let url = URL(string: tourl)
    
    var request:URLRequest = URLRequest(url: url!)
    request.httpMethod = "POST"
    
    let boundary = generateBoundaryString()
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    let body = NSMutableData()
    
    let mimetype = "image/jpg"
    
    let session = URLSession.shared
    
    for (key,value) in params
    {
      body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
      body.append("Content-Disposition:form-data;name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
      body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
    }
    
    
    var x:Int = 1
    if imageDataArray.count > 0 && imageDataArray.count <= 5
    {
      x = 1
      for i in 0..<imageDataArray.count
      {
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"image\(x)\"; filename=\"image\(x).jpg\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(imageDataArray[i])
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        x = x + 1
      }
    }
    else if imageDataArray.count > 5
    {
      x = 1
      for i in 0..<5
      {
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"image\(x)\"; filename=\"image\(x).jpg\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(imageDataArray[i])
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        x = x + 1
        x = x + 1
      }
      
    }
    
    
    
    body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
    request.httpBody = body as Data
    let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
      
      guard let _:Data = data, let _:URLResponse = response, error == nil else {
        failure("ErrorMsg")
        return
      }
      let httpResponse = response as! HTTPURLResponse
      print(httpResponse)
      if httpResponse.statusCode == 200 {
        do {
          let jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
          
          DispatchQueue.main.async(execute: {
            success(jsonData as! [String : Any])
          })
        }
        catch {
          DispatchQueue.main.async(execute: {
            
            failure("ErrorMsg")
          })
        }
      }
      else {
        failure("ErrorMsg")
      }
    })
    task.resume()
    
  }
  
  
  
  class func putJSON(withURL url:String,withParameters params:[String:Any],success:@escaping ([String:Any]) -> (),failure:@escaping (String) -> ())
  {
    var request = URLRequest(url: URL(string: url)!)
    let session = URLSession.shared
    request.httpMethod = "PUT"
    let parameters = params
    do {
      request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
    }
    catch {
      
    }
    
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Accept")
    
    let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
      
      if error == nil
      {
        let httpResponse = response as! HTTPURLResponse
        if httpResponse.statusCode == 200
        {
          do
          {
            let jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            
            DispatchQueue.main.async(execute: {
              
              success(jsonData as! [String : Any])
            })
            
          }
          catch {
            
            DispatchQueue.main.async(execute: {
              
              failure("ErrorMsg")
            })
          }
        }
        else
        {
          DispatchQueue.main.async(execute: {
            
            failure("ErrorMsg")
          })
        }
      }
      else
      {
        DispatchQueue.main.async(execute: {
          
          failure("ErrorMsg")
        })
      }
    })
    
    task.resume()
  }
  
  
  
  class func putWithImage(withUrl tourl:String,withParameters params:[String:Any],withFileNames files:[String:Data],success:@escaping ([String:Any]) -> (),failure:@escaping (String) -> ())
  {
    let url = URL(string: tourl)
    
    var request:URLRequest = URLRequest(url: url!)
    request.httpMethod = "PUT"
    
    let boundary = generateBoundaryString()
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    let body = NSMutableData()
    let mimetype = "image/jpg"
    
    let session = URLSession.shared
    
    for (key,value) in params
    {
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data;name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
    }
    
    for (key,value) in files {
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"\(key)\"; filename=\"\(key).jpg\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(value)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
    }
    
    body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
    request.httpBody = body as Data
    
    let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
        
        guard let _:Data = data, let _:URLResponse = response, error == nil else {
            failure("ErrorMsg")
            return
        }
        let httpResponse = response as! HTTPURLResponse
        if httpResponse.statusCode == 200 {
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                
                DispatchQueue.main.async(execute: {
                    success(jsonData as! [String : Any])
                })
            }
            catch {
                DispatchQueue.main.async(execute: {
                    
                    failure("ErrorMsg")
                })
            }
        }
        else {
            failure("ErrorMsg")
        }
    })
    task.resume()
  }
  
  
  
  class func postJSON(withURL url:String,withParameters params:[String:Any],withHeader header:String,success:@escaping ([String:Any]) -> (),failure:@escaping (String) -> ())
  {
    
    var request = URLRequest(url: URL(string: url)!)
    let session = URLSession.shared
    request.httpMethod = "POST"
//    let parameters = params
//    do {
//      request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
//    }
//    catch {
//      
//    }
    
    request.addValue("\(header)", forHTTPHeaderField: "Content-Type")
    request.addValue("\(header)", forHTTPHeaderField: "Accept")
  
  var paramStr:String = ""
  for (key,value) in params {
    paramStr = paramStr + "&" + "\(key)=\(value)"
  }
    if paramStr != "" {
      paramStr = paramStr.substring(from: paramStr.characters.index(paramStr.startIndex, offsetBy: 1))
    }
  
    request.httpBody = paramStr.data(using: .utf8)
    
    let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
      
      if error == nil
      {
        let httpResponse = response as! HTTPURLResponse
        
        print("Http Response is: \(httpResponse)")
        if httpResponse.statusCode == 200
        {
          do
          {
            
            let jsonData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            
//            var newJsonData = jsonData as! [String:Any]
            
            DispatchQueue.main.async(execute: {
              
              print("Json data is: \(jsonData)")
              success(jsonData as! [String : Any])
            })
          }
          catch {
            DispatchQueue.main.async(execute: {
              failure("Oops! some problem occured")
            })
          }
          
        }
          
        else
        {
          DispatchQueue.main.async(execute: {
            failure("Invalid Username or Password")
          })
        }
      }
      else
      {
        DispatchQueue.main.async(execute: {
          failure("ErrorMsg")
        })
      }
    })
    task.resume()
  }
  
  
  class func apiGetImageFromUrl(fromUrl urlStr:String,success:@escaping (UIImage) -> (),failure:@escaping (String) -> ())
  {
    let url = URL(string: urlStr)!
    let task = URLSession.shared.dataTask(with: url, completionHandler: { (responseData, response, error) in
      
      if let Rdata = responseData {
        DispatchQueue.main.async(execute: {
          if let image = UIImage(data: Rdata)
          {
            DispatchQueue.main.async(execute: {
              
              success(image)
            })
          }
          else
          {
            DispatchQueue.main.async(execute: {
              
              failure("ErrorMsg")
            })
          }
        })
      }
      else
      {
        DispatchQueue.main.async(execute: {
          
          failure("ErrorMsg")
        })
      }
    })
    task.resume()
  }
  
  
  class func generateBoundaryString() -> String {
    return "Boundary-\(UUID().uuidString)"
  }
  
}
