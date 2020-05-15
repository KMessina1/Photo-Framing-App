/*--------------------------------------------------------------------------------------------------------------------------
   File: CAS_ShippingRestAPI.swift
 Author: Kevin Messina
Created: December 5, 2017

©2017-2019 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES: Based on https://app.goshippo.com/api/
--------------------------------------------------------------------------------------------------------------------------*/

import SwiftyJSON
import Alamofire

// MARK: ├─➤ Shipping
struct Shippo {
    struct addressStruct {
        var company:String
        var name:String
        var address1:String
        var address2:String
        var city:String
        var state:String // 2-letter code
        var zipCode:String
        var country:String // 2-letter code
        
        init(
            company:String? = " ",
            name:String? = " ",
            address1:String? = " ",
            address2:String? = " ",
            city:String? = " ",
            state:String? = " ",
            zipCode:String? = " ",
            country:String? = "US"
        ) {
            self.company = company!
            self.name = name!
            self.address1 = address1!
            self.address2 = address2!
            self.city = city!
            self.state = state!
            self.zipCode = zipCode!
            self.country = country!
        }
    }

    struct packageStruct {
        var totalOrderWeight:String
        var totalWeightUnit:String // the unit needs to be “oz,” “g,” “lb,” or “kg.”
        var totalOrderPrice:String
        var orderCurrency:String
        
        init(
            totalOrderWeight:String? = " ",
            totalWeightUnit:String? = "lb", // the unit needs to be “oz,” “g,” “lb,” or “kg.”
            totalOrderPrice:String? = " ",
            orderCurrency:String? = "USD"
            ) {
            self.totalOrderWeight = totalOrderWeight!
            self.totalWeightUnit = totalWeightUnit!
            self.totalOrderPrice = totalOrderPrice!
            self.orderCurrency = orderCurrency!
        }
    }

    struct itemStruct {
        var title:String
        var SKU:String
        var quantity:String
        var weightPer:String
        var weightUnit:String
        var pricePer:String
        var currency:String
        
        init(
            title:String? = " ",
            SKU:String? = " ",
            quantity:String? = " ",
            weightPer:String? = " ",
            weightUnit:String? = " ",
            pricePer:String? = " ",
            currency:String? = "USD"
        ) {
            self.title = title!
            self.SKU = SKU!
            self.quantity = quantity!
            self.weightPer = weightPer!
            self.weightUnit = weightUnit!
            self.pricePer = pricePer!
            self.currency = currency!
        }
    }

    struct fieldNames {
        // Order
        static let orderName = "order name"
        static let orderDate = "order date" //The recommended format is YYYY-MM-DD.
        // Address
        static let recipientName = "recipient name"
        static let company = "company"
        static let streetLine1 = "street (line 1)"
        static let streetLine2 = "street (line 2)"
        static let city = "city"
        static let state = "state"  // 2-letter code
        static let zipCode = "zip code"
        static let country = "country"  // 2-letter code
        static let email = "email"
        static let phone = "phone"
        
        // Unusedd (Package)
        struct PACKAGE {
            static let totalOrderWeight = "total order weight"
            static let totalWeightUnit = "total weight unit" // the unit needs to be “oz,” “g,” “lb,” or “kg.”
            static let totalOrderPrice = "total order price"
            static let orderCurrency = "order currency"
        }
        
        struct ITEMS {// Unused (Items)
            static let itemTitle = "item title"
            static let SKU = "SKU"
            static let quantity = "quantity"
            static let weightPerItem = "weight per item"
            static let weightUnit = "weight unit"
            static let pricePerItem = "price per item"
            static let itemCurrency = "item currency"
        }
        
        struct OTHER {//Other...
            static let company = "company"
            static let streetNumber = "street number"
        }
    }

    struct exportCSV {
        var orderID:String // Order Name/ID
        var orderDate:String // The recommended format is yyyy-MM-dd.
        var address:addressStruct
        var email:String
        var phone:String
        var package:packageStruct
        var item:itemStruct
        
        init (
            orderID:String = "", // Order Name/ID
            orderDate:String = "", // The recommended format is yyyy-MM-dd.
            address:addressStruct = addressStruct.init(),
            email:String = "",
            phone:String = "",
            package:packageStruct = packageStruct.init(),
            item:itemStruct = itemStruct.init()
        ) {
            self.orderID = orderID
            self.orderDate = orderDate
            self.address = address
            self.email = email
            self.phone = phone
            self.package = package
            self.item = item
        }
    }
}


@objc(CAS_ShippingRestAPI) class CAS_ShippingRestAPI:NSObject {
    var Version:String! { return "1.00" }
}
