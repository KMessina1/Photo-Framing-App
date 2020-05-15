/*--------------------------------------------------------------------------------------------------------------------------
    File: eCommerce.swift
  Author: Kevin Messina
 Created: June 5, 2016
 
©2016-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
2018/04/03 - Removed Moltin Funcitonality.
--------------------------------------------------------------------------------------------------------------------------*/

//import Moltin
import Alamofire
import SwiftyJSON
import RappleProgressHUD


// MARK: - *** PUBLIC CONSTANTS ***


// MARK: - *** eCOMMERCE FUNCTIONS ***
@objc(eCommerce) class eCommerce:NSObject {
    var Version: String { return "2.20" }

    struct imageStruct:Loopable {
        var filename:String!
        var http:String!
        var https:String!
        
        init (filename:String,
              http:String,
              https:String
            ) {
            
            self.filename = filename
            self.http = http
            self.https = https
        }
    }
    
    struct itemStruct:Loopable {
        var id:String!
        var taxBand:String!
        var cartIdentifier:String!
        var quantity:Double!
        var sku:String!
        var title:String!
        var size:String!
        var color:String!
        var format:String!
        var weight:Double!
        var height:Double!
        var width:Double!
        var depth:Double!
        var stockLevel:Double!
        var category:String!
        var price:Double!
        var images:[imageStruct]!
        var collection:String!
        var brand:String!
        var brandDescription:String!

        init (id:String,
              taxBand:String,
              cartIdentifier:String,
              quantity:Double,
              sku:String,
              title:String,
              size:String,
              color:String,
              format:String,
              weight:Double,
              height:Double,
              width:Double,
              depth:Double,
              stockLevel:Double,
              category:String,
              price:Double,
              images:[imageStruct],
              collection:String,
              brand:String,
              brandDescription:String
            ) {
            
            self.id = id
            self.taxBand = taxBand
            self.cartIdentifier = cartIdentifier
            self.quantity = quantity
            self.sku = sku
            self.title = title
            self.size = size
            self.color = color
            self.format = format
            self.weight = weight
            self.height = height
            self.width = width
            self.depth = depth
            self.stockLevel = stockLevel
            self.category = category
            self.price = price
            self.images = images
            self.collection = collection
            self.brand = brand
            self.brandDescription = brandDescription
        }
    }

    struct customerStruct:Loopable {
        var id:String!
        var firstName:String!
        var lastName:String!
        var email:String!
        var mailingList:Bool!
        var orders:Int!
        var amount:Double!

        init (id:String? = "",
              firstName:String? = "",
              lastName:String? = "",
              email:String? = "",
              mailingList:Bool? = true,
              orders:Int? = 0,
              amount:Double? = 0.00
            ) {
            
            self.id = id
            self.firstName = firstName
            self.lastName = lastName
            self.email = email
            self.mailingList = mailingList
            self.orders = orders
            self.amount = amount
        }

        func isFilledOutWithoutID() -> Bool {
            return (
                firstName.isNotEmpty &&
                lastName.isNotEmpty &&
                email.isNotEmpty
            )
        }
        
        func isFilledOut() -> Bool {
            return (
                id.isNotEmpty &&
                firstName.isNotEmpty &&
                lastName.isNotEmpty &&
                email.isNotEmpty
            )
        }

        func isPartiallyFilledOut() -> Bool {
            return (
                firstName.isNotEmpty ||
                lastName.isNotEmpty ||
                email.isNotEmpty
            )
        }
    }

    struct paymentStruct:Loopable {
        var name:String!
        var number:String! // Formatted and encrypted when saving to local SQLite db.
        var type:String!  // Visa
        var typeCode:Int! // 0
        var expiration:String! // MM/YY
        var expMonth:Int! // MM
        var expYear:Int! // YY
        var cvn:String!
        var nickname:String! // Optional nickname of card
        var isDefault:Bool! // Optional is default credit card.
        
        init (name:String? = "",
              number:String? = "",
              type:String? = "",
              typeCode:Int? = 0,
              expiration:String? = "",
              expMonth:Int? = 0,
              expYear:Int? = 0,
              cvn:String? = "",
              nickname:String? = "",
              isDefault:Bool? = false
            ){
         
            self.name = name
            self.number = number
            self.type = type
            self.typeCode = typeCode
            self.expiration = expiration
            self.expMonth = expMonth
            self.expYear = expYear
            self.cvn = cvn
            self.nickname = nickname
            self.isDefault = isDefault
        }

        func isFilledOut() -> Bool {
            return (
                self.name.isNotEmpty &&
                self.number.isNotEmpty &&
                self.cvn.isNotEmpty &&
                (self.expMonth > 0) &&
                (self.expYear > 0)
            )
        }

        func isExpired() -> Bool {
            let ExpMonth = self.expMonth
            let ExpYear = self.expYear
            let month = Date().monthNum
            let year = Date().yearNum
            
            let isExpired = (ExpYear! < year) || (ExpYear! == year && ExpMonth! < month)

            return isExpired
        }
    }
    
    struct addressStruct:Loopable {
        var id:String!
        var firstName:String!
        var lastName:String!
        var address1:String!
        var address2:String!
        var city:String!
        var state:String!
        var stateCode:String!
        var zip:String!
        var country:String!
        var countryCode:String!
        var phone:String!

        init (
            id:String? = "",
            firstName:String? = "",
            lastName:String? = "",
            address1:String? = "",
            address2:String? = "",
            city:String? = "",
            state:String? = "",
            stateCode:String? = "",
            zip:String? = "",
            country:String? = "",
            countryCode:String? = "",
            phone:String? = ""
        ) {
            self.id = id
            self.firstName = firstName
            self.lastName = lastName
            self.address1 = address1
            self.address2 = address2
            self.city = city
            self.state = state
            self.stateCode = stateCode
            self.country = country
            self.countryCode = countryCode
            self.zip = zip
            self.phone = phone
        }
        
        func isFilledOut() -> Bool {
            if lastName == nil { return false }
            
            return (
                lastName.isNotEmpty &&
                address1.isNotEmpty &&
                city.isNotEmpty &&
                state.isNotEmpty &&
                country.isNotEmpty &&
                zip.isNotEmpty
            )
        }

        func isPartiallyFilledOut() -> Bool {
            if lastName == nil { return false }
            
            return (
                lastName.isNotEmpty ||
                address1.isNotEmpty ||
                city.isNotEmpty ||
                state.isNotEmpty ||
                country.isNotEmpty ||
                zip.isNotEmpty
            )
        }
    }
    
    struct shipppingStruct:Loopable {
        var date:String!
        var type:String!
        var price:Double!
        var amount:Double!
        var method:Int!
        var company:String!
        var companyCode:String!
        var tracking:String!
        var delivered:String!

        init (
            date:String? = "",
            type:String? = "",
            price:Double? = 0.00,
            amount:Double? = 0.00,
            method:Int? = 0,
            company:String? = "",
            companyCode:String? = "",
            tracking:String? = "",
            delivered:String? = ""
        ){
            self.date = date
            self.type = type
            self.price = price
            self.amount = amount
            self.method = method
            self.company = company
            self.companyCode = companyCode
            self.tracking = tracking
            self.delivered = delivered
        }
    }
    
    func emptyCart(showProgressHud:Bool? = true)  -> Void {
        if !sharedFunc.NETWORK().displayMsgIfNotAvailable() { return }
        
        if showProgressHud! {
            sharedFunc.THREAD().doNow { waitHUD().show(msg:"Cart_Emptying".localized()) }
        }
        
        /* Empty Cart */
        sharedFunc.THREAD().doNow { waitHUD().hide() }
        
        self.resetCart()
    }
}

