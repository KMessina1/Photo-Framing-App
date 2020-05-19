/*--------------------------------------------------------------------------------------------------------------------------
     File: pdf_SF_Shared.swift
   Author: Kevin Messina
  Created: Aug. 31, 2018
 Modified:

 ©2018-2019 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
 NOTES:
--------------------------------------------------------------------------------------------------------------------------*/



class pdf_SF_Shared:NSObject,Loopable {
    var Version: String { return "1.00" }
    var name: String { return "OrderConfirmation Message" }

    func printCustomHeader(title:String,printAppVersion:Bool) {
        headerTop = 110
        
        // MARK: |--> Logo
        logoSizeH = 40.0
        logoSizeW = logoSizeH * 5
        inset = 5
        PDF().drawImage(img: #imageLiteral(resourceName: "SQframe_logo_whiteTM2.1"),
                        rect: CGRect(x: pdfPageSize.margin_Left + inset,
                                     y: pdfPageSize.margin_Top + (inset * 1.5),
                                     width: logoSizeW,
                                     height: logoSizeH),
                        linkShow: true,
                        link: appInfo.COMPANY.WEBSITE_URLS.company)
        
        // MARK: |--> Title
        let wide:CGFloat = ((pdfCurrentVals.pageWidth - logoSizeW) - pdfCurrentVals.margin) + inset
        let left:CGFloat = pdfPageSize.margin_Left + logoSizeW + (inset * 3)
        var y = (pdfPageSize.margin_Top + (inset * 1.75))
        let h = (logoSizeH - inset)
        
        PDF().drawSizedText(text: title,
                            fontName: titleFontname,
                            size_Max: 48,
                            size_Min: 24,
                            alignment: .right,
                            inRect: CGRect(x: left,
                                           y: y,
                                           width: wide,
                                           height: h)
        )
        
        // MARK: |--> Version
        if printAppVersion.isTrue {
            y += h
            
            PDF().drawSizedText(
                text: "v\( Bundle.main.fullVer )",
                fontName: titleFontname,
                size_Max: 10,
                size_Min: 8,
                alignment: .right,
                inRect: CGRect(x: left,
                               y: y,
                               width: wide,
                               height: 12),
                color: #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
            )
        }
    }

    func printCustomFooter() {
        let spacer:CGFloat = 18
        let iconSize:CGFloat = 26
        
        // Format = [ {asset image name} : {link to social media account} ]
        let baseLink = appInfo.COMPANY.SOCIALMEDIA_URLS.self
        
        let socialMedia:[String:String] = [
            "PDF_Instagram_Large":baseLink.instagram!,
            "PDF_Pinterest_Large":baseLink.pinterest!,
            "PDF_Facebook_Large":baseLink.faceBook!
//            "PDF_Twitter_Large":baseLink.twitter!,
        ]
        
        var X = pdfCurrentVals.margin
        var Y = pdfCurrentVals.margin_Bottom - 4
        /* Draw separator line */
        PDF().drawLine(width: 0.5,
                       color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.2),
                       from: CGPoint(x:X,y:Y),
                       to: CGPoint(x:pdfCurrentVals.margin_Right,y:Y))
        
        
        /* Draw Social Media Images with Hyperlinks */
        Y += 4
        for (imgName, linkString) in socialMedia {
            PDF().drawImage(img: UIImage(named: imgName) ?? UIImage.init(),
                            rect: CGRect(x:X, y:Y, width:iconSize, height:iconSize),
                            linkShow: true,
                            link: linkString)
            
            X += iconSize + spacer
        }
        
        /* Draw Email Icon */
        X = pdfCurrentVals.margin_Right - iconSize
        PDF().drawImage(img: #imageLiteral(resourceName: "PDF_Mail"),
                        rect: CGRect(x:X, y:Y, width:iconSize, height:iconSize),
                        linkShow: true,
                        link: appInfo.COMPANY.ORDERS.email)
        
        /* Draw Email Text */
        let wide:CGFloat = 140
        X -= (spacer / 2) + wide
        PDF().drawSizedTextMultiline(text: "PDF_FOOTER_ORDER1".localized(),
                                     fontName: "Avenir-Light",
                                     size_Max: 10,
                                     size_Min: 8,
                                     alignment: .right,
                                     inRect: CGRect(x: X,y:Y + 2,width: wide,height: iconSize))
        
        if (order.productCount > 6) {
            PDF().drawPageNumber(pageNum: pdfCurrentVals.pageNum, customY: Y + iconSize)
        }
    }
}
