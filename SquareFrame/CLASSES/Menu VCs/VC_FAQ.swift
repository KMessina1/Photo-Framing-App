/*--------------------------------------------------------------------------------------------------------------------------
    File: VC_FAQ.swift
  Author: Kevin Messina
 Created: May 23, 2017
Modified: Apr 3, 2018

©2016-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
2018-04-03 - Migrated to CMS.
--------------------------------------------------------------------------------------------------------------------------*/


// MARK: - *** GLOBAL CONSTANTS ***

class VC_FAQ:UIViewController,
             UIPopoverPresentationControllerDelegate,
             UITableViewDelegate,UITableViewDataSource {
    
// MARK: - *** FUNCTIONS ***
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle  {
        return .none
    }
    
    func getData() {
        FAQs().list(showMsg: true, completion: { (success, items, error) in
            if success {
                CMS_FAQList = items
                self.table.reloadData()
            }else{
                sharedFunc.ALERT().show(
                    title:"UnsupportedLanguage_Title".localizedCAS(),
                    style:.error,
                    msg:"UnsupportedLanguage_Msg".localizedCAS()
                )
            }
        })
    }
    

// MARK: - *** ACTIONS ***
    @IBAction func showMenu(_ sender:UIButton){
        slideMenuController()?.toggleLeft()
    }
    
    
// MARK: - *** TABLEVIEW ***
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return CMS_FAQList.count }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { return 1 }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { return UIView() }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 1 }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { return UIView() }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return UITableView.automaticDimension }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID.topic,for: indexPath) as? cell_FAQTopic,
              let item = CMS_FAQList[row] as FAQs.FAQstruct?
        else { return UITableViewCell() }

        let useEnglish:Bool = (gAppLanguageCode == "en")
        
        cell.lbl_Topic.text = useEnglish ?item.title_en :item.title_es
        cell.lbl_Body.text = useEnglish ?item.body_en :item.body_es
        
        return cell
    }


// MARK: - *** NOTIFICATIONS ***

    
// MARK: - *** LIFECYCLE ***
    override var preferredStatusBarStyle:UIStatusBarStyle { return .default }
    override var prefersStatusBarHidden:Bool { return false }
    override var preferredInterfaceOrientationForPresentation:UIInterfaceOrientation { return .portrait }
    override var supportedInterfaceOrientations:UIInterfaceOrientationMask { return .portrait }
    override var shouldAutorotate:Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Appearance */
        divider.backgroundColor = gAppColor.withAlphaComponent(0.2)
        btn_Menu.setImage(isPad ? #imageLiteral(resourceName: "Menu_LG").recolor(gAppColor) : #imageLiteral(resourceName: "Menu").recolor(gAppColor), for: .normal)

        /* Table Init */
        table.estimatedRowHeight = isPad ?140 :73
        table.rowHeight = UITableView.automaticDimension
        table.separatorColor = gAppColor.withAlphaComponent(kAlpha.third)
        
        /* Localization */
        lbl_Title.text = "FAQ".localized()
        
        /* Data */
        getData()

        /* Notifications */
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sharedFunc.DRAW().addGradientToView(view: vw_Topbar)
    }
    

// MARK: - *** DECLARATIONS (Outlets) ***
    @IBOutlet var table:UITableView!
    @IBOutlet var vw_Topbar:UIView!
    @IBOutlet var divider:UILabel!
    @IBOutlet var btn_Menu:UIButton!
    @IBOutlet var lbl_Title:UILabel!
    
// MARK: ├─➤ *** DECLARATIONS (Variables)

// MARK: ├─➤ DECLARATIONS (Cell Reuse Identifiers)
    struct cellID {
        static let topic = "cell_FAQTopic"
    }
}
