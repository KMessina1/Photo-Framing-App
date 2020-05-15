/*--------------------------------------------------------------------------------------------------------------------------
    File: VC_Orders.swift
  Author: Kevin Messina
 Created: Jan 26, 2016
Modified: Apr 4, 2018
 
 ©2016-2020 Creative App Solutions, LLC. - All Rights Reserved.
 ----------------------------------------------------------------------------------------------------------------------------
 2018-04-04 - Migrated from Moltin.
 2016-09-19 - Converted to Swift
--------------------------------------------------------------------------------------------------------------------------*/

// MARK: - *** GLOBAL CONSTANTS ***

class VC_Orders:
    UIViewController,
    UITableViewDelegate,UITableViewDataSource
{
    
    // MARK: - *** FUNCTIONS ***
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle  {
        return .none
    }
    
    func getData() {
        lbl_Customer_Name.text = "\(customerInfo.firstName!) \(customerInfo.lastName!)"
        lbl_Customer_Number.text = "\(customerInfo.ID!)"

        Orders().listOrdersByCustomerID(showMsg:true,id: customerInfo.ID!) { (success, orderRecords1, shipToRecords1, error) in
            if customerInfo.isFilledOutWithoutID().isFalse {
                waitHUD().hideNow()
                sharedFunc.ALERT().show(
                    title:"Customers_NotFilledOut_Title".localized(),
                    style:.error,
                    msg:"Customers_NotFilledOut_Msg".localized()
                )
                return
            }
            
            if success {
                if (orderRecords1.count < 1) {
                    let email = (customerInfo.email!).isEmpty ?"" :customerInfo.email!
                    let id = (customerInfo.ID! < 1) ?"" :"\( customerInfo.ID! )"
                    var msg = "\( "Orders_NotFound_Msg".localized() )"
                    if (email.isNotEmpty && id.isNotEmpty) {
                        msg.append("\n\n\( customerInfo.ID! ), \( customerInfo.email! )")
                    }
                    sharedFunc.ALERT().show(title: "Orders_NotFound_Title".localized(),style:.error,msg: msg)
                    return
                }
                
                self.orderRecords = orderRecords1

                self.lbl_Customer_Orders.text =  "\(self.orderRecords.count)"

                var total:Double = 0.00
                self.orderRecords.forEach({ (item) in
                    total += item.totalAmt.doubleValue
                })

                self.lbl_Customer_AmtSpent.text =  String(format:"$%0.2f",total)
                self.table.reloadData()
                
                waitHUD().hideNow()
            }else{
                waitHUD().hideNow()
                sharedFunc.ALERT().show(
                    title:"Orders_NotFound_Title".localized(),
                    style:.error,
                    msg:"Orders_NotFound_Msg".localized()
                )
            }
        }
    }
    
    
// MARK: - *** ACTIONS ***
    @IBAction func showMenu(_ sender:UIButton){
        slideMenuController()?.toggleLeft()
    }

    @IBAction func refresh(_ sender:UIButton){
        getData()
    }
    
    
// MARK: - *** TABLEVIEW *** -
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return orderRecords.count }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { return 1 }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { return UIView() }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 1 }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return isPad ?160 :86 }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row

        if (orderRecords.count <= row) {
            return UITableViewCell()
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID.orders,for:indexPath) as? cell_Orders,
              let orderRec = orderRecords[row] as Orders.orderStruct?
        else { return UITableViewCell() }

        /* Appearance */
        for lbl in [cell.lbl_status,cell.lbl_date,cell.lbl_number,cell.lbl_shipTo,cell.lbl_total,cell.lbl_items] {
            lbl?.textColor = gAppColor
        }

        for lbl in [cell.lbl_date_Title,cell.lbl_number_Title,cell.lbl_items_Title,cell.lbl_shipTo_Title,cell.lbl_status_Title,cell.lbl_total_Title] {
            lbl?.backgroundColor = gAppColor
            lbl?.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        }
        for lbl in [cell.lbl_date,cell.lbl_number,cell.lbl_items,cell.lbl_shipTo,cell.lbl_status,cell.lbl_total] {
            sharedFunc.DRAW().strokeBorder(view: lbl!, color: gAppColor, width: 0.5)
            lbl?.text = "n/a"
        }
        
        /* Localization */
        cell.lbl_date_Title.text = "Order_DateTitle".localized()
        cell.lbl_number_Title.text = "Order_NumberTitle".localized()
        cell.lbl_items_Title.text = "Order_ItemsTitle".localized()
        cell.lbl_total_Title.text = "Order_TotalTitle".localized()
        cell.lbl_status_Title.text = "Order_StatusTitle".localized()
        cell.lbl_shipTo_Title.text = "Order_ShippedToTitle".localized()
        
        /* Data */
        if orderRec.orderDate.isNotEmpty {
            cell.lbl_date.text = orderRec.orderDate.convertToDate(format: "yyyy-MM-dd").toString(format: "MMM d, yyyy")
        }else{
            cell.lbl_date.text = ""
        }
        
        cell.lbl_number.text = "\( orderRec.id )"
        cell.lbl_shipTo.text = "\(orderRec.shipTo_firstName) \(orderRec.shipTo_lastName) (\(orderRec.shipTo_city), \(orderRec.shipTo_stateCode))"
        cell.lbl_total.text = String(format:"$%0.02f",orderRec.totalAmt.doubleValue)
        cell.lbl_items.text = "\( orderRec.photoCount )"
        cell.lbl_status.text = orderRec.statusID 

        /* Conditional Formatting */
        if orderRec.statusID.isNotEmpty,
            let progress = orderProgressFilters(rawValue: orderProgress.arr.firstIndex(of: orderRec.statusID )!) { switch progress {
            case .shipped,.delivered,.processing,.new,.paid: cell.accessoryType = .disclosureIndicator
            default: cell.accessoryType = .none
        }}
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if sharedFunc.NETWORK().displayMsgIfNotAvailable().isFalse {
            return
        }

        let row = indexPath.row

        guard
            let orderRec = orderRecords[row] as Orders.orderStruct?
        else {
            return
        }

        if let progress = orderProgressFilters(rawValue: orderProgress.arr.firstIndex(of: orderRec.statusID )!) { switch progress {
            case .shipped,.delivered,.processing,.new,.paid:
                let orderDocs = orderRec.orderDocs.components(separatedBy: ",")
                var filename:String = ""
                orderDocs.forEach { (doc) in
                    if doc.contains("Order_") {
                        filename = doc
                    }
                }

                /* Does File on server exist? */
                let pdfPath:String = "Orders/Order_\( orderRec.orderNum )/\( filename )"
                let filenameTuple = Products().returnDocumentNameFrom(filename: filename)
                let orderFolder = filenameTuple.orderFolder
                let filePath:String = "\(appInfo.COMPANY.SERVER.ordersFolder!)/\(orderFolder)/\(filename)".replaceCharsForHTML

                Server().serverFileExists(fileNameAndPath: pdfPath) { (success, error) in
                    if success.isFalse {
                        sharedFunc.ALERT().show(
                            title:"FILE_NotFound_Title".localizedCAS(),
                            style:.error,
                            msg:"Server.OrderPDFNotFound.Msg".localized().replacingOccurrences(of: "{orderNum}", with: orderRec.orderNum)
                        )
                    }else{
                        guard
                            let fileURL = URL(string: filePath) as URL?
                        else {
                            sharedFunc.ALERT().showFileNotFound(filename: filename)
                            return
                        }

                        simPrint().info("PDF PATH: \( fileURL )")
                        simPrint().info("PDF FILE: \( filename )")
                    
                        waitHUD().showNow(msg: "Loading PDF from Server...")
                        let childVC = UIStoryboard(name:"PDFViewer",bundle:nil)
                            .instantiateViewController(withIdentifier: "PDFViewer") as! PDFViewer
                        childVC.pdfURL = fileURL

                        self.present(childVC, animated: false)
                    }
                }
            default:
                sharedFunc.ALERT().show(
                    title:"Orders_NotProcessed_Title".localized(),
                    style:.error,
                    msg:"Orders_NotProcessed_Msg".localized()
                )
        }}
    }
    

// MARK: - *** LIFECYCLE ***
    override var preferredStatusBarStyle:UIStatusBarStyle { return .default }
    override var prefersStatusBarHidden:Bool { return false }
    override var preferredInterfaceOrientationForPresentation:UIInterfaceOrientation { return .portrait }
    override var supportedInterfaceOrientations:UIInterfaceOrientationMask { return .portrait }
    override var shouldAutorotate:Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /* Appearance */
        btn_Menu.setImage(isPad ? #imageLiteral(resourceName: "Menu_LG").recolor(gAppColor) : #imageLiteral(resourceName: "Menu").recolor(gAppColor), for: .normal)
        btn_Refresh.setImage(isPad ? #imageLiteral(resourceName: "Refresh_LG").recolor(gAppColor) : #imageLiteral(resourceName: "Refresh").recolor(gAppColor), for: .normal)

        /* Defaults */
        orderRecords = []

        /* Table Init */
        table.estimatedRowHeight = isPad ?140 :73
        table.rowHeight = UITableView.automaticDimension
        table.separatorColor = gAppColor.withAlphaComponent(kAlpha.third)

        /* Localization */
        lbl_Title.text = "Orders(\(gAppID))_Title".localized()
        lbl_Customer_Number_Title.text = "\("Customer".localizedCAS()) #:"
        lbl_Customer_Orders_Title.text = "\("Orders_Total_Orders".localized()):"
        lbl_Customer_AmtSpent_Title.text = "\("Orders_Total_Amount".localized()):"
        
        /* Notifications */
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lbl_Customer_Name.text = ""
        lbl_Customer_Number.text = ""
        lbl_Customer_Orders.text = "0"
        lbl_Customer_AmtSpent.text = "$0.00"

        getData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        /* Appearance */
        lbl_Title.textColor = gAppColor
        divider.backgroundColor = gAppColor.withAlphaComponent(0.2)
        divider2.backgroundColor = gAppColor.withAlphaComponent(0.2)
        sharedFunc.DRAW().addShadow(view: divider2, offsetSize: CGSize(width:2,height:2), radius: 2, opacity: 0.66)
        sharedFunc.DRAW().addGradientToView(view: vw_Topbar)
    }
    
    
    // MARK: - *** DECLARATIONS (Outlets) ***
    @IBOutlet var vw_Topbar:UIView!
    @IBOutlet var divider:UILabel!
    @IBOutlet var btn_Menu:UIButton!
    @IBOutlet var btn_Refresh:UIButton!
    @IBOutlet var lbl_Title:UILabel!

    @IBOutlet var lbl_Customer_Name:UILabel!
    @IBOutlet var lbl_Customer_Number_Title:UILabel!
    @IBOutlet var lbl_Customer_Number:UILabel!
    @IBOutlet var lbl_Customer_Orders_Title:UILabel!
    @IBOutlet var lbl_Customer_Orders:UILabel!
    @IBOutlet var lbl_Customer_AmtSpent_Title:UILabel!
    @IBOutlet var lbl_Customer_AmtSpent:UILabel!
    @IBOutlet var divider2:UILabel!
    @IBOutlet var table:UITableView!
    
    // MARK: - *** DECLARATIONS (Variables) ***
    var orderRecords:[Orders.orderStruct] = []
    
    // MARK: - *** DECLARATIONS (Cell Reuse Identifiers) ***
    struct cellID {
        static let orders = "cell_Orders"
    }
}

