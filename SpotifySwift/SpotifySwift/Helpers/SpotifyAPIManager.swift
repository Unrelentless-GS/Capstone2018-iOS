//
//import UIKit
//import Alamofire
//import SwiftyJSON
//import SafariServices
//class SpotifyAPIManager{
//    // Authentication Class
//
//    static let sharedInstance = SpotifyAPIManager()
//
//    let clientId = "6d3d63e867ba4181aa02dd56481c7554"
//    let clientSecret = "2ab8127996ed4fd0a34e52478db31aba"
//
//    var OAuthToken: String?
//    
//    var OAuthCompletionHandler:((NSError?) -> Void)?
//
//
//    init(){
//        if (hasOAuthToken()){
//
//
//           // addSessionHeader(key: "Authorization", value: "token \(OAuthToken)")
//        }
//    }
//
//    func hasOAuthToken() -> Bool{
//        if let token = self.OAuthToken{
//            return !token.isEmpty
//        }
//
//        return false
//    }
//
//    func startOAuthLogin(){
//        // Hardcoded Authentication address, remove later
//        let authPath =  "https://accounts.spotify.com/authorize?nolinks=true&nosignup=true&response_type=\(Constants.code)&scope=streaming&utm_source=spotify-sdk&utm_medium=ios-sdk&utm_campaign=ios-sdk&redirect_uri=\(Constants.redirectURI)&show_dialog=true&client_id=\(Constants.clientID)"
//
//
//
//
//      // Convert into URL
//        if let authURL = URL(string: authPath){
//
//            // Open Safari with link
//            UIApplication.shared.open(authURL, options: [:], completionHandler: nil)
//
//            processOAuthStep1Response(url: authURL)
//
//
//
//
//
//        }
//    }
//
//    func processOAuthStep1Response(url: URL){
//
//
//      let components = NSURLComponents(url: url, resolvingAgainstBaseURL: false)
//
//
//        SPTAuth.defaultInstance().spotifyWebAuthenticationURL()
//
//        var code: String?
//
//
//        //Finds code parameter
//        if let queryItems = components?.queryItems{
//            for item in queryItems{
//                print(item.value)
//
//                if (item.value?.lowercased() == "code"){
//                    code = item.value
//                    break
//                }
//            }
//        }
//
//        if let code = code{
//            let url1 = "https://accounts.spotify.com/api/token"
//            let parameters = ["grant_type": "authorization_code", "code": code, "redirect_uri": "spotiJson://", "client_id": clientId, "client_secret": clientSecret, ]
////
////            Alamofire.request("https://httpbin.org/get").responseJSON { (responseData) -> Void in
////                if((responseData.result.value) != nil) {
////                    let swiftyJsonVar = JSON(responseData.result.value!)
////                    print("WOOOOO")
////                    print(swiftyJsonVar)
////                }
////            }
//
////        }
////        let defaults = NSUserDefaults.standardUserDefaults()
////        defaults.setBool(false, forKey: "loadingOAuthToken")
////    }
////
//
//}
//}
//}
