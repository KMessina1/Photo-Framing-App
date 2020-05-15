/*--------------------------------------------------------------------------------------------------------------------------
     File: StripeController.swift
   Author: Sascha Wise
  Created: Apr 15, 2018
 Modified:
 
©2018-2019 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES:
--------------------------------------------------------------------------------------------------------------------------*/

import Foundation
import Stripe
import Alamofire

class StripeController: NSObject, STPPaymentContextDelegate {
    var context: STPPaymentContext
    var delegate: StripeControllerDelegate
    init(host: UIViewController, customerId: String, amount: Int, delegate: StripeControllerDelegate) {
        let customerContext = STPCustomerContext(keyProvider: StripeAPI(customerId: customerId))
        self.delegate = delegate
        self.context = STPPaymentContext(customerContext: customerContext)
        super.init()
        self.context.delegate = self
        self.context.hostViewController = host
        self.context.paymentAmount = amount // This is in cents, i.e. $50 USD
        STPTheme.default().primaryForegroundColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1)
    }

    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        print("stripe failedToLoad")
        waitHUD().hideNow()
        sharedFunc.ALERT().show(
            title:"Order.Payment.NotSelected.Title".localized(),
            style:.error,
            msg:"Order.Payment.NotSelected.Msg".localized(),
            delay: 1.0
        )

        delegate.failed(with: error)
    }
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        if paymentContext.selectedPaymentOption != nil {
            delegate.selected()
        }
    }

    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        delegate.completed(with: paymentResult, completion: completion)
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        /* Payment Failed */
        if let error = error {
            waitHUD().hideNow()
            sharedFunc.ALERT().show(
                title:"Order_Payment_Denied_Title".localized(),
                style:.error,
                msg:"Order_Payment_Denied_Msg".localized(),
                delay: 1.0
            )
            
            delegate.failed(with: error)
        }
        
        if status == STPPaymentStatus.error {
            // error code
            print("stripe error")
        }else if status == STPPaymentStatus.userCancellation { // Including ApplePay not configured
            // cancellation code
            print("stripe cancelled")
            waitHUD().hideNow()
            sharedFunc.ALERT().show(
                title:"Order.Payment.NotSelected.Title".localized(),
                style:.error,
                msg:"Order.Payment.NotSelected.Msg".localized(),
                delay: 1.0
            )
        }
    }

    func choose() {
        context.presentPaymentOptionsViewController()
    }
    
    func pay() {
        context.requestPayment()
    }
}

protocol StripeControllerDelegate {
    func completed(with paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock)
    func failed(with error: Error)
    func selected()
}

class StripeAPI: NSObject, STPCustomerEphemeralKeyProvider {
    var customerId: String
    init(customerId: String) {
        self.customerId = customerId
    }
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        let url = "\( appInfo.COMPANY.SERVER.SCRIPTS.stripe! )/\( serverScriptNames.STRIPE.ephemeral_keys )"
        
        let params = [
            "api_version": apiVersion,
            "customer_id": customerId
        ]
        
        Server().dumpParams(params)
        
        Alamofire.request(url, method: .post, parameters: params)
        .validate(statusCode: 200..<300)
        .responseJSON { responseJSON in
            switch responseJSON.result {
            case .success(let json):
                completion(json as? [String: AnyObject], nil)
            case .failure(let error):
                simPrint().error("\( debugPrint(error) )",function:#function,line:#line)
                completion(nil, error)
            }
        }
    }
}
