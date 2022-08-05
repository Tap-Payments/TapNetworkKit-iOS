//
//  NetworkManager.swift
//  CheckoutExample
//
//  Created by Kareem Ahmed on 8/20/20.
//  Copyright © 2020 Tap Payments. All rights reserved.
//

import TapApplicationV2
import CoreTelephony

public protocol NetworkManagerDelegate {
    func apiCallInProgress(status:Bool)
}

/// The shared network manager related to configure the network/api class between the SDK and the Server
public class NetworkManager: NSObject {
    // MARK: - Public Network Session Data
    
    public static var networkSessionConfigurator:TapNetworkSessionConfigurator = .init()
    
    /// Request completion closure.
    typealias RequestCompletionClosure = (URLSessionDataTask?, Any?, Error?) -> Void
    
    /// Inner Request completion closure.
    typealias InnerRequestCompletionClosure = (URLSessionDataTask?, Any?, Error?,TapLogStrackTraceRequstModel?) -> Void
    
    /// The singletong network manager
    public static let shared = NetworkManager()
    /// The network manager delegate
    public var delegate:NetworkManagerDelegate?
    /// The static headers to be sent with every call/request
    private var headers:[String:String] {
      return  NetworkManager.staticHTTPHeaders
    }
    private var networkManager: TapNetworkManager
    /// Defines if loging api calls to server
    public var enableLogging = false
    /// Defines if logging apu calls to console
    public var consoleLogging = false
    
    internal var loggedApis:[TapLogStackTraceEntryModel] {
        return networkManager.loggedInApiCalls
    }
    
    private override init () {
        networkManager = TapNetworkManager(baseURL: NetworkManager.networkSessionConfigurator.baseURL)
        networkManager.loggedInApiCalls = []
    }
    
    /// Used to clear any previous api stack trace log
    internal func resetStackTrace() {
        networkManager.loggedInApiCalls = []
    }
    
    /**
     Used to dispatch a network call with the needed configurations
     - Parameter routing: The path the request should hit.
     - Parameter resultType: A generic decodable class that the result will be parsed into.
     - Parameter body: A dictionay to pass any more data you want to pass as a body of the request.
     - Parameter httpMethod: The type of the http request.
     - Parameter completion: A block to be executed upon finishing the network call
     - Parameter onError: A block to be executed upon error
     */
    public func makeApiCall<T:Decodable>(routing: TapNetworkPath, resultType:T.Type,body:TapBodyModel? = .none, httpMethod: TapHTTPMethod = .GET, urlModel:TapURLModel? = .none, completion: TapNetworkManager.RequestCompletionClosure?,onError:TapNetworkManager.RequestCompletionClosure?) {
        // Inform th network manager if we are going to log or not
        networkManager.isRequestLoggingEnabled      = enableLogging
        networkManager.consolePrintLoggingEnabled   = consoleLogging
        
        // Group all the configurations and pass it to the network manager
        let requestOperation = TapNetworkRequestOperation(path: "\(NetworkManager.networkSessionConfigurator.baseURL)\(routing.rawValue)", method: httpMethod, headers: headers, urlModel: urlModel, bodyModel: body, responseType: .json)
        delegate?.apiCallInProgress(status: true)
        // Perform the actual request
        networkManager.performRequest(requestOperation, completion: { [weak self] (session, result, error) in
            //print("result is: \(String(describing: result))")
            //print("error: \(String(describing: error))")
            self?.delegate?.apiCallInProgress(status: false)
            //Check for errors
            if let error = error {
                onError?(session,result,error)
                return
            }
            // Check we need to do the on error callbak or not
            guard let correctParsing = result as? T else {
                guard let detectedError = self!.detectError(from: result, and: error) else {
                    return
                }
                onError?(session,result,detectedError)
                return
            }
            completion?(session, correctParsing, error)
            
        }, codableType: resultType)
    }
    
    
    /**
     Used to detect if an error occured whether a straight forward error like invalid parsing or a backend error
     - Parameter response: The data came from the backend, to check if itself has a backend error like "Invalid api key", this will have the highest prioirty to display
     - Parameter error: The error if any came from the network manager parser like invalid json, malformed data, etc.
     - Returns: An error that will have response error as a priority and nil of non of them containted a valid error
     */
    public func detectError(from response:Any?,and error:Error?) -> Error? {
        // First check the error coming from backend
        if let response = response {
            // Try to parse it into our error backend model
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .fragmentsAllowed)
                let decodedErrorResponse:ApiErrorModel = try JSONDecoder().decode(ApiErrorModel.self, from: jsonData)
                // Check if an error from backend was actually sent
                if !decodedErrorResponse.errors.isEmpty {
                    return decodedErrorResponse.errors[0].description
                }
            }catch{}
        }else if let error = error {
            // Now as there is no a backend error, time to check if there was a local error by parsing the json data
            return error
        }
        // All good!
        return nil
    }
}


/// Extension to the network manager when needed. To keep the network manager class itself clean and readable
internal extension NetworkManager {
    
    
    /// Static HTTP headers sent with each request. including device info, language and SDK secret keys
    static var staticHTTPHeaders: [String: String] {
        
        let secretKey = NetworkManager.secretKey()
        
        guard secretKey.tap_length > 0 else {
            
            fatalError("Secret key must be set in order to use goSellSDK.")
        }
        
        let applicationValue = applicationHeaderValue
        
        var result = [
            
            Constants.HTTPHeaderKey.authorization: "Bearer \(secretKey)",
            Constants.HTTPHeaderKey.application: applicationValue,
            Constants.HTTPHeaderKey.contentTypeHeaderName: Constants.HTTPHeaderValueKey.jsonContentTypeHeaderValue
        ]
        
        if let sessionToken = NetworkManager.networkSessionConfigurator.sessionToken, !sessionToken.isEmpty {
            
            result[Constants.HTTPHeaderKey.sessionToken] = sessionToken
        }
        
        if let middleWareToken = NetworkManager.networkSessionConfigurator.token {
            
            result[Constants.HTTPHeaderKey.token] = "Bearer \(middleWareToken)"
        }
        
        return result
    }
    
    /// HTTP headers that contains the device and app info
    static var applicationHeaderValue: String {
        
        var applicationDetails = NetworkManager.applicationStaticDetails()
        
        let localeIdentifier = NetworkManager.networkSessionConfigurator.localeIdentifier
        
        applicationDetails[Constants.HTTPHeaderValueKey.appLocale] = localeIdentifier
        
        if let deviceID = NetworkManager.networkSessionConfigurator.deviceID {
            
            applicationDetails[Constants.HTTPHeaderValueKey.deviceID] = deviceID
        }
        
        let result = (applicationDetails.map { "\($0.key)=\($0.value)" }).joined(separator: "|")
        
        return result
    }
    
    /**
     Used to fetch the correct secret key based on the selected SDK mode
     - Returns: The sandbox or production secret key based on the SDK mode
     */
    static func secretKey() -> String {
        return (NetworkManager.networkSessionConfigurator.sdkMode == .sandbox) ? NetworkManager.networkSessionConfigurator.secretKey.sandbox : NetworkManager.networkSessionConfigurator.secretKey.production
    }
    
    
    /// A computed variable that generates at access time the required static headers by the server.
    static private func applicationStaticDetails() -> [String: String] {
        
        guard let bundleID = TapApplicationPlistInfo.shared.bundleIdentifier, !bundleID.isEmpty else {
         
         fatalError("Application must have bundle identifier in order to use goSellSDK.")
         }
        
        //let bundleID = "company.tap.goSellSDKExamplee"
        
        let sdkPlistInfo = TapBundlePlistInfo(bundle: Bundle(for: NetworkManager.self))
        
        guard let requirerVersion = sdkPlistInfo.shortVersionString, !requirerVersion.isEmpty else {
            
            fatalError("Seems like SDK is not integrated well.")
        }
        let networkInfo = CTTelephonyNetworkInfo()
        let providers = networkInfo.serviceSubscriberCellularProviders
        
        let osName = UIDevice.current.systemName
        let osVersion = UIDevice.current.systemVersion
        let deviceName = UIDevice.current.name
        let deviceNameFiltered =  deviceName.tap_byRemovingAllCharactersExcept("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ123456789")
        let deviceType = UIDevice.current.model
        let deviceModel = UIDevice.current.localizedModel
        var simNetWorkName:String? = ""
        var simCountryISO:String? = ""
        
        if providers?.values.count ?? 0 > 0, let carrier:CTCarrier = providers?.values.first {
            simNetWorkName = carrier.carrierName
            simCountryISO = carrier.isoCountryCode
        }
        
        
        let result: [String: String] = [
            
            Constants.HTTPHeaderValueKey.appID: bundleID,
            Constants.HTTPHeaderValueKey.requirer: Constants.HTTPHeaderValueKey.requirerValue,
            Constants.HTTPHeaderValueKey.requirerVersion: requirerVersion,
            Constants.HTTPHeaderValueKey.requirerOS: osName,
            Constants.HTTPHeaderValueKey.requirerOSVersion: osVersion,
            Constants.HTTPHeaderValueKey.requirerDeviceName: deviceNameFiltered,
            Constants.HTTPHeaderValueKey.requirerDeviceType: deviceType,
            Constants.HTTPHeaderValueKey.requirerDeviceModel: deviceModel,
            Constants.HTTPHeaderValueKey.requirerSimNetworkName: simNetWorkName ?? "",
            Constants.HTTPHeaderValueKey.requirerSimCountryIso: simCountryISO ?? "",
        ]
        
        return result
    }
    
    
    
    struct Constants {
        
        internal static let authenticateParameter = "authenticate"
        
        fileprivate static let timeoutInterval: TimeInterval            = 60.0
        fileprivate static let cachePolicy:     URLRequest.CachePolicy  = .reloadIgnoringCacheData
        
        fileprivate static let successStatusCodes = 200...299
        
        fileprivate struct HTTPHeaderKey {
            
            fileprivate static let authorization    = "Authorization"
            fileprivate static let application      = "application"
            fileprivate static let sessionToken     = "session_token"
            fileprivate static let contentTypeHeaderName        = "Content-Type"
            fileprivate static let token                = "token"
            
            //@available(*, unavailable) private init() { }
        }
        
        fileprivate struct HTTPHeaderValueKey {
            
            fileprivate static let appID                = "app_id"
            
            fileprivate static let appLocale                = "app_locale"
            fileprivate static let deviceID                = "device_id"
            fileprivate static let requirer                = "requirer"
            fileprivate static let requirerOS            = "requirer_os"
            fileprivate static let requirerOSVersion        = "requirer_os_version"
            fileprivate static let requirerValue            = "SDK"
            fileprivate static let requirerVersion        = "requirer_version"
            fileprivate static let requirerDeviceName        = "requirer_device_name"
            fileprivate static let requirerDeviceType        = "requirer_device_type"
            fileprivate static let requirerDeviceModel    = "requirer_device_model"
            fileprivate static let requirerSimNetworkName    = "requirer_sim_network_name"
            fileprivate static let requirerSimCountryIso    = "requirer_sim_country_iso"
            fileprivate static let jsonContentTypeHeaderValue   = "application/json"
            
            //@available(*, unavailable) private init() { }
        }
    }
}
