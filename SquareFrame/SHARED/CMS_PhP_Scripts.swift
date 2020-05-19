/*--------------------------------------------------------------------------------------------------------------------------
    File: CMS_PhP_Scripts.swift
  Author: Kevin Messina
 Created: Apr 10, 2018
Modified: Apr 04, 2020
 
©2018-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
 
2020/04/04 - Added stringAndCountStruct()
--------------------------------------------------------------------------------------------------------------------------*/

struct stringAndCountStruct:Codable,Loopable {
    var id:UUID! // Primary Index
    var category:String!
    var numItems:Int!

    init (
        id:UUID = UUID(),
        category:String? = "",
        numItems:Int? = 0
    ){
        self.id = id
        self.category = category!
        self.numItems = numItems!
    }
    
    init(dictionary:[String:Any]) {
        self.category = dictionary["category"] as? String ?? ""
        self.numItems = Int(dictionary["numItems"] as? String ?? "")
    }

    func convertStructToDictionary(structure:stringAndCountStruct) -> [String:Any] {
        var dict:[String:Any] = [:]
            dict.updateValue(structure.category!, forKey: "category")
            dict.updateValue(structure.numItems!, forKey: "numItems")
                                                        
        return dict
    }

    func returnArray(arrayOfDictionaries:[[String:Any]]) -> [stringAndCountStruct] {
        var arr:[stringAndCountStruct] = []
        arrayOfDictionaries.forEach { (dict) in arr.append(stringAndCountStruct.init(dictionary: dict)) }
        
        return arr
    }
    
    func returnArrayOfDictionaries(arrayOfStructs:[stringAndCountStruct]) -> [[String:Any]] {
        var arr:[[String:Any]] = []
        arrayOfStructs.forEach { (item) in arr.append(stringAndCountStruct().convertStructToDictionary(structure: item) ) }
        
        return arr
    }
}

struct serverScriptNames {
    let Version:String = "1.01"
    let name:String = "Server Script Names"

    struct SERVER {
        static let isActive = "services_isActive.php"
        static let updateActive = "services_updateActive.php"
    }

    struct FULFILLMENT {
        static let getInfo = "getFulfillmentInfo.php"
    }
    
    struct SALESTAX {
        static let getTaxableStates = "getTaxableStates.php"
    }
    
    struct CART {
        static let getByCustomerID = "cart_getByCustomerID.php"
        static let addItem = "cart_addItem.php"
        static let convertToOrder = "cart_convertToOrder.php"
        static let getByID = "cart_getByCartID.php"
        static let list = "carts_list.php"
    }
    
    struct APP_IMAGES {
        static let getInfo = "getAppImagesInfo.php"
    }
    
    struct FRAME_GALLERY {
        static let getInfo = "getFrameGalleryInfo.php"
    }
    
    struct FRAMES {
        static let style = "frameStyle.php"
        static let color = "frameColor.php"
        static let size = "frameSize.php"
        static let matteColor = "matteColor.php"
        static let componentsList = "componentsList.php"
        
        struct SHAPES {
            static let add = "frameShapeAdd.php"
            static let update = "frameShapeUpdate.php"
            static let delete = "frameShapeDelete.php"
            static let exists = "frameShapeExists.php"
        }
        struct PRODUCTS {
            static let add = "frameProductAdd.php"
            static let update = "frameProductUpdate.php"
            static let delete = "frameProductDelete.php"
            static let exists = "frameProductExists.php"
            static let list = "frameProductList.php"
            static let inStock = "frameProductInStock.php"
        }
        struct COLORS {
            static let add = "frameColorAdd.php"
            static let update = "frameColorUpdate.php"
            static let delete = "frameColorDelete.php"
            static let exists = "frameColorExists.php"
        }
        struct STYLES {
            static let add = "frameStyleAdd.php"
            static let update = "frameStyleUpdate.php"
            static let delete = "frameStyleDelete.php"
            static let exists = "frameStyleExists.php"
        }
        struct SIZES {
            static let add = "frameSizeAdd.php"
            static let update = "frameSizeUpdate.php"
            static let delete = "frameSizeDelete.php"
            static let exists = "frameSizeExists.php"
        }
        struct MATTECOLORS {
            static let add = "matteColorAdd.php"
            static let update = "matteColorUpdate.php"
            static let delete = "matteColorDelete.php"
            static let exists = "matteColorExists.php"
        }
        struct PHOTOSIZES {
            static let add = "photoSizeAdd.php"
            static let update = "photoSizeUpdate.php"
            static let delete = "photoSizeDelete.php"
            static let exists = "photoSizeExists.php"
            static let List = "photoSizeList.php"
        }
        struct MATERIALS {
            static let add = "frameMaterialAdd.php"
            static let update = "frameMaterialUpdate.php"
            static let delete = "frameMaterialDelete.php"
            static let exists = "frameMaterialExists.php"
            static let List = "frameMaterialList.php"
        }
    }
    
    struct PASSCODES {
        static let list = "accounts_list.php"
        static let update = "accounts_update.php"
        static let validate = "accounts.php"
    }
    
    struct FAQ {
        static let list = "FAQ_list.php"
    }
    
    struct EMAILADDRESSES {
        static let list = "emailer_list.php"
        static let update = "emailer_update.php"
    }
    
    struct ADDRESSES {
        static let exists = "addressExists.php"
        static let add = "addressAdd.php"
        static let update = "addressUpdate.php"
        static let delete = "addressDelete.php"
        static let searchForMatch = "address_searchForMatch.php"
        static let search = "addressSearch.php"
        static let allByCustomerID = "addressListByCustomerID.php"
    }
    
    // MARK: -
    struct COUPONS {
        static let search = "coupons_search.php"
        static let list = "coupons_list.php"
        static let codeExists = "coupon_exists.php"
        static let codeAndIdExists = "coupon_codeAndIDExists.php"
        static let delete = "coupon_delete.php"
        static let add = "coupon_add.php"
        static let update = "coupon_update.php"
    }
    
    // MARK: -
    struct REDEMPTIONS {
        static let list = "redemptions_list.php"
        static let used = "redemptions_alreadyRedeemed.php"
        static let add = "redemptions_add.php"
    }
    
    // MARK: -
    struct CUSTOMER {
        static let componentsList = "customersComponentsList.php"
        static let getAll = "listCustomers.php"
//        static let add = "customerAdd.php"
        static let update = "customerUpdate.php"
        static let exists = "customerExists.php"
        static let mailingList = "mailingList_list.php"
        static let search = "customerSearchByEmail.php"
        static let searchOrAdd = "customerSearchByEmailorAdd.php"
        static let mailingListUpdate = "customer_updateMailingList.php"
        static let addWithAddress = "customer_addWithAddress.php"
        static let updateWithAddress = "customer_updateWithAddress.php"
    }
    
    // MARK: -
    struct EMAIL {
        static let getAllAddresses = "emailer_list.php"

        struct CUSTOMER {
            static let confirmation = "sendEmail_customerConfirmation.php"
            static let tracking = "sendEmail_customerTracking.php"
            static let trackingTest = "sendEmail_customerTrackingTest.php"
        }
        struct COMPANY {
            static let sendOrderFiles = "sendEmail_companyOrderFiles.php"
            static let resendOrderFiles = "resendEmail_companyOrderFiles.php"
        }
    }
    
    // MARK: -
    struct FILES {
        static let upload = "moveUploadedOrderFile.php"
        static let getDirectoryFiles = "getAllFilesInDirectory.php"
        static let serverFileExists = "folderAndfileNameExists.php"
    }
    
    // MARK: -
    struct FUNCTIONS {
        static let getPHPVersion = "getPHPVersion.php"
    }
    
    // MARK: -
    struct KNOWLEDGEBASE {
        static let list = "knowledgebaseList.php"
    }
    
    // MARK: -
    struct SCRIPTLOGS {
        static let list = "scriptLogsList.php"
        static let listCategory = "scriptLogsListByCategoryAndDate.php"
    }
    
    // MARK: -
    struct TEAMS {
        static let list = "teamsList.php"
    }
    
    // MARK: -
    struct RESOURCES {
        static let list = "resourcesList.php"
    }
    
    // MARK: -
    struct ORDERS {
        static let add = "orderAdd.php"
        static let exists = "orderExists.php"
        static let items = "getOrderItems.php"
        static let addItem = "orderAddItem.php"
        static let list = "ordersList.php"
        static let listByStatus = "ordersList_byStatus.php"
        static let listGifts = "orderList_Gifts.php"
        static let listStatuses = "orderList_Statuses.php"
        static let listIssues = "orderIssues.php"
        static let listCustOrders = "orderList_CustomerID.php"
        static let listByDateRange = "ordersList_byDateRange.php"
        static let listByOrderNum = "ordersList_byOrderNum.php"
        static let convertFromMoltin = "ConvertOrderCustomerAndAddresses.php"
        static let completeOrder = "pay.php"
        static let completeTestOrder = "pay_new.php"
        static let resetTestOrders = "resetTestOrders.php"
        static let resetConvertedOrders = "ConvertResetOrders.php"
        static let getOrderFiles = "getOrderFiles.php"
        static let createServerFolder = "createOrderNumFolder.php"
        static let updateOrderStatus = "updateOrderStatus.php"
        static let updateOrderShippingInfo = "updateOrderShippingInfo.php"
        static let updateOrderDeliveryInfo = "updateOrderDeliveryInfo.php"
    }
    
    // MARK: -
    struct SHIPPING {
        static let validateAddress = "Shippo_validateAddress.php"
        static let shippo = "Shippo.php"
    }
    
    // MARK: -
    struct STRIPE {
        static let ephemeral_keys = "ephemeral_keys.php"
    }
}
