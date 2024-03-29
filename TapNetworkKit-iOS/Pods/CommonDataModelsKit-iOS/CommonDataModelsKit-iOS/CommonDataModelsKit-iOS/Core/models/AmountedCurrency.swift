//
//  AmountedCurrency.swift
//  goSellSDK
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Structure holding currency and the amount.
@objc public class AmountedCurrency: NSObject,Codable {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Currency.
    public var currency: TapCurrencyCode
    
    /// The decimal digits.
    public var decimalDigits: Int
    
    /// Amount.
    public var amount: Double
    
    /// Currency symbol.
    public var currencySymbol: String
    
    /// Currency flag icon url.
    public var flag: String
    
    /// Conversion factor to transaction currency from baclend
    public var rate: Double?
    
    /// Computes the displayble symbol. If backend provides a Symbol we use it, otherwise we use the provided currency code
    public var displaybaleSymbol:String {
        return currencySymbol
        //return currencySymbol.count == 1 ? currencySymbol : currency.appleRawValue
    }
    // MARK: Methods
    
    @objc public convenience init(_ currency: TapCurrencyCode, _ amount: Double, _ flag: String, _ decimalDigits: Int = 2, _ rate: Double = 1) {
        self.init(currency, amount, currency.symbolRawValue, flag, decimalDigits, rate)
    }
    
    @objc public init(_ currency: TapCurrencyCode, _ amount: Double, _ currencySymbol: String, _ flag: String, _ decimalDigits: Int = 2, _ rate: Double = 1) {
        
        self.currency       = currency
        self.amount         = amount
        self.currencySymbol = currencySymbol
        self.flag           = flag
        self.decimalDigits  = decimalDigits
        self.rate           = rate
    }
    
    // MARK: - Private -
    
    private enum CodingKeys: String, CodingKey {
        
        case currency       = "currency"
        case amount         = "amount"
        case currencySymbol = "symbol"
        case rate           = "rate"
        case flag           = "flag"
        case decimalDigits  = "decimal_digit"
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        return currency.appleRawValue == (object as? AmountedCurrency)?.currency.appleRawValue
    }
}
