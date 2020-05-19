/*--------------------------------------------------------------------------------------------------------------------------
     File: pdf_GiftMessage.swift
   Author: Kevin Messina
  Created: Aug. 31, 2018
 Modified:

 ©2018-2019 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
 NOTES:
--------------------------------------------------------------------------------------------------------------------------*/



class pdf_GiftMessage:NSObject,Loopable {
    var Version: String { return "1.00" }
    var name: String { return "Gift Message" }

    func create(drawBorder:Bool,drawCropMarks:Bool,drawBackground:Bool,drawLogo:Bool) {
        PDF().setPageAppearance(
            pageNum_Show: false,
            pageNum_Formatting: PDF.PageNumFormat.pageDashNumDash,
            pageNum_Alignment: .center,
            border_Show: false,
            border_Color: gAppColor,
            border_Width: 1.0,
            logo_Show: false,
            logo_Alignment: .left,
            appStore_Show: false,
            appStore_Alignment: .center,
            website_Show: false,
            website_Alignment: .center,
            website_showLink: false
        )
        
        PDF().newPage(title:"")
        
        pdfCurrentVals.x = 100
        pdfCurrentVals.y = 100
        let boxWidth:CGFloat = (pdfCurrentVals.pageWidth - pdfCurrentVals.x) - pdfCurrentVals.margin
        var boxHt:CGFloat = 300
        
        /* Draw Crop Marks */
        if drawCropMarks {
            PDF().drawCropMarks(innerRect: CGRect(x: pdfCurrentVals.x,
                                                  y: pdfCurrentVals.y,
                                                  width: boxWidth,
                                                  height: boxHt),
                                markLength: pdfCurrentVals.margin)
        }
        
        /* Draw Border */
        if drawBorder {
            PDF().drawBox(rect: CGRect(x: pdfCurrentVals.x,
                                       y: pdfCurrentVals.y,
                                       width: boxWidth,
                                       height: boxHt),
                          width: 1,
                          lineColor: #colorLiteral(red: 0.8075229526, green: 0.8046451211, blue: 0.8198773861, alpha: 1).withAlphaComponent(0.5),
                          fill: false,
                          fillColor: .clear)
        }
        
        /* Draw Title */
        pdfCurrentVals.x += 10
        pdfCurrentVals.y += 10
        let titleHt:CGFloat = 60
        PDF().drawText(text: "PDF_GIFT_TITLE".localized(),
                       fontName: "SavoyeLetPlain",
                       fontSize: 56,
                       inRect: CGRect(x: pdfCurrentVals.x,
                                      y: pdfCurrentVals.y,
                                      width: boxWidth,
                                      height: titleHt),
                       alignment: .center,
                       color: .black)
        
        boxHt -= titleHt
        
        
        /* Draw GiftBox Image */
        if drawBackground {
            let giftImg:UIImage = #imageLiteral(resourceName: "GiftBox.png").alpha(value: 0.1)
            let imgSize:CGFloat = 200.0
            pdfCurrentVals.x = 100 + ((boxWidth - imgSize) / 2)
            pdfCurrentVals.y += 60
            PDF().drawImage(img: giftImg,
                            rect: CGRect(x: pdfCurrentVals.x,
                                         y: pdfCurrentVals.y,
                                         width: imgSize,
                                         height: imgSize),
                            linkShow: false,
                            link: "")
        }
        
        /* Draw Company Logo Image */
        if drawLogo {
            let logoImg:UIImage = #imageLiteral(resourceName: "SQframe_logo_whiteTM2.1").alpha(value: 0.25)
            let imgSize:CGSize = CGSize(width: 100, height: 20)
            pdfCurrentVals.x = (100 + (boxWidth - imgSize.width)) - 3
            pdfCurrentVals.y = ((100 + (boxHt - imgSize.height)) - 5) + titleHt
            
            PDF().drawImage(img: logoImg,
                            rect: CGRect(x: pdfCurrentVals.x,
                                         y: pdfCurrentVals.y,
                                         width: imgSize.width,
                                         height: imgSize.height),
                            linkShow: false,
                            link: "")
        }
        
        /* Draw Gift Message */
        pdfCurrentVals.x = 110
        pdfCurrentVals.y = 180
        
        PDF().drawSizedTextMultiline(text: order.giftMessage,
                                     fontName: "Optima-Regular",
                                     size_Max: 18,
                                     size_Min: 11,
                                     alignment: .left,
                                     inRect: CGRect(x: pdfCurrentVals.x,
                                                    y: pdfCurrentVals.y,
                                                    width: boxWidth - 20, // Give some margin left & right
                                        height: boxHt - 10)) // Give some margin bottom
    }
}

