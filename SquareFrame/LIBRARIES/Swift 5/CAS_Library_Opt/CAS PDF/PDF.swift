/*--------------------------------------------------------------------------------------------------------------------------
   File: PDF.swift
 Author: Kevin Messina
Created: Aug. 31, 2015

©2015-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
NOTES: Converted to Swift 3.0 on October 6, 2016.
--------------------------------------------------------------------------------------------------------------------------*/

import QuartzCore

// MARK: - *** GLOBAL CONSTANT STRUCTS & ENUMS ***
@objc(PDF) public final class PDF:NSObject{
// MARK: - *** DEFINITIONS ***
    var Version:String { return "2.01" }
    
// MARK: - *** FUNCTIONS: PAGE SETUP ***
    func setAuthorInfo(author:String,appName:String,appVersion:String,subject:String) {
        pdfAuthorInfo = [kCGPDFContextAuthor as String:author,
                         kCGPDFContextCreator as String:"\(appName) v\(appVersion)",
                         kCGPDFContextSubject as String:subject,
                         kCGPDFContextTitle as String:" iOS app \(appName) (v\(appVersion))"]
    }
    
    
// MARK: - *** FUNCTIONS: PAGE SETUP ***
    func setPaperSize(paperSize:PaperSize) {
        /* Initialize as new settings */
        pdfPageSize = PageSize_Settings.init()
        
        /* Set size info */
        pdfPageSize.pageSize = paperSize
        pdfPageSize.width = paperSize.width
        pdfPageSize.height = paperSize.height
        pdfPageSize.margin_Top = paperSize.margin
        pdfPageSize.margin_Bottom = paperSize.height - (paperSize.margin * 2)
        pdfPageSize.margin_Left = paperSize.margin
        pdfPageSize.margin_Right = paperSize.width - (paperSize.margin * 2)

        /* Initialize pdfCurrentVals info */
        pdfCurrentVals = current.init()
        pdfCurrentVals.margin = paperSize.margin
        pdfCurrentVals.pageHeight = paperSize.height - (paperSize.margin * 2)
        pdfCurrentVals.pageWidth = paperSize.width - (paperSize.margin * 2)
        pdfCurrentVals.pageNum = 0
        pdfCurrentVals.rowHt = 20.0
        pdfCurrentVals.textInset = 5
        pdfCurrentVals.x = pdfPageSize.margin_Left
        pdfCurrentVals.y = pdfPageSize.margin_Top
        pdfCurrentVals.h = pdfCurrentVals.pageHeight
        pdfCurrentVals.w = pdfCurrentVals.pageWidth
        pdfCurrentVals.margin_Top = pdfCurrentVals.y
        pdfCurrentVals.margin_Bottom = pdfCurrentVals.pageHeight
        pdfCurrentVals.margin_Right = (pdfPageSize.margin_Right + (paperSize.margin / 2))
    }
    
    func setPageAppearance(
        pageNum_Show:Bool,
        pageNum_Formatting:PageNum,
        pageNum_Alignment:kAlignment,
        border_Show:Bool,
        border_Color:UIColor,
        border_Width:CGFloat,
        logo_Show:Bool,
        logo_Alignment:kAlignment,
        appStore_Show:Bool,
        appStore_Alignment:kAlignment,
        website_Show:Bool,
        website_Alignment:kAlignment,
        website_showLink:Bool
    ) {
    
        /* Set PageNumber info */
        pdfPageSize.pageNum_Show = pageNum_Show
        pdfPageSize.pageNum_Format = pageNum_Formatting
        pdfPageSize.pageNum_Alignment = pageNum_Alignment

        /* Set Border info */
        pdfPageSize.border_Show = border_Show
        pdfPageSize.border_Color = border_Color
        pdfPageSize.border_Width = border_Width

        /* Set Logo info */
        pdfPageSize.logo_Show = logo_Show
        pdfPageSize.logo_Alignment = logo_Alignment
        pdfPageSize.appStore_Show = appStore_Show
        pdfPageSize.appStore_Alignment = appStore_Alignment
        pdfPageSize.website_Show = website_Show
        pdfPageSize.website_Alignment = website_Alignment
        pdfPageSize.website_showLink = website_showLink
    }
    
    func newPage(title:String) {
        /* Reset currentVal values to page defaults */
        pdfCurrentVals.margin = pdfPageSize.margin_Left
        pdfCurrentVals.pageHeight = (pdfPageSize.height - (pdfPageSize.margin_Left * 2))
        pdfCurrentVals.pageWidth = (pdfPageSize.width - (pdfPageSize.margin_Left * 2))
        pdfCurrentVals.rowHt = 20.0
        pdfCurrentVals.textInset = 5
        pdfCurrentVals.x = pdfPageSize.margin_Left
        pdfCurrentVals.y = pdfPageSize.margin_Top
        pdfCurrentVals.h = pdfCurrentVals.pageHeight
        pdfCurrentVals.w = pdfCurrentVals.pageWidth
        pdfCurrentVals.margin_Top = pdfCurrentVals.y

        /* Increment PageNum */
        pdfCurrentVals.pageNum += 1

        /* Start new page in context */
        UIGraphicsBeginPDFPageWithInfo(CGRect(x: 0,y: 0,width: pdfPageSize.width,height: pdfPageSize.height),nil)

        /* Border */
        if pdfPageSize.border_Show! {
            drawBorder(width: pdfPageSize.border_Width,
                       inset: 5.0,
                       color: pdfPageSize.border_Color)
        }
        
        /* Page Number */
        if pdfPageSize.pageNum_Show! {
            pdfCurrentVals.margin_Bottom = (pdfPageSize.height - (pdfCurrentVals.margin * 2))
            drawPageNumber(pageNum: pdfCurrentVals.pageNum)
        }

        /* Appstore Badge */
        if pdfPageSize.appStore_Show! {
            drawAppStoreLogo(position: pdfPageSize.appStore_Alignment)
        }

        /* Website */
        if pdfPageSize.website_Show! {
            drawWebsiteLink(position: pdfPageSize.website_Alignment)
        }
        
        /* Logo */
        let logoSize:CGFloat = 50
        let inset:CGFloat = 5
        if pdfPageSize.logo_Show! {
            drawImage(img: #imageLiteral(resourceName: "iTunes Artwork"),
                     rect: CGRect(x: pdfPageSize.margin_Left + inset,
                                  y: pdfPageSize.margin_Top + inset,
                              width: logoSize,
                             height: logoSize),
                 linkShow: false,
                     link: appInfo.COMPANY.WEBSITE_URLS.company)
        }
        
        if title.isNotEmpty {
            var wide:CGFloat = (pdfCurrentVals.pageWidth - (inset * 2))
            var left:CGFloat = pdfPageSize.margin_Left + inset
            if pdfPageSize.logo_Show! {
                left = pdfPageSize.margin_Left + logoSize + (inset * 3)
                wide = ((pdfCurrentVals.pageWidth - logoSize) - pdfCurrentVals.margin) + inset
            }
            
            PDF().drawSizedText(text: title,
                            fontName: "Optima-Regular",
                            size_Max: 48,
                            size_Min: 24,
                           alignment: .left,
                              inRect: CGRect(x: left,
                                             y: pdfPageSize.margin_Top + inset,
                                         width: wide,
                                        height: logoSize))
        }
        
        /* Draw Separator Line */
        let topY = pdfPageSize.margin_Top + logoSize + (inset * 3)
        
        if pdfPageSize.logo_Show! && title.isNotEmpty {
            drawLine(width: 1.5,
                     color: gAppColor.withAlphaComponent(kAlpha.half),
                      from: CGPoint(x: pdfPageSize.margin_Left + 5,y: topY),
                        to: CGPoint(x: pdfCurrentVals.margin_Right,y: topY))
        }
    }
    
    
// MARK: - *** FUNCTIONS: PAGE COMPLETION ***
    func createAtFilePath(fileNameAndPath:String) {
        UIGraphicsBeginPDFContextToFile(fileNameAndPath, CGRect.zero, pdfAuthorInfo)
        pdfCurrentVals.pageNum = 0
    }
    
    func finish() {
        UIGraphicsEndPDFContext()
    }

    /// Render current context into a .PDF page.
    func renderPage(context:CGContext,
                      range:CFRange,
                framesetter:CTFramesetter,
                       rect:CGRect,
                     rotate:Bool) -> CFRange {
        
        var Range = range
        
        // Put the text matrix into a known state. This ensures that no old scaling factors are left in place.
        context.textMatrix = CGAffineTransform.identity
        
        // Create a path object to enclose the text. Use 72 point margins all around the text.
        let frameRect:CGRect! = rect // Create a path object to enclose the text. Use 72 point margins
        let framePath:CGMutablePath! = CGMutablePath.init()
            framePath.addRect(frameRect)
        
        // Range variable specifies starting point. Framesetter lays out as much text as will fit into the Frame.
        let frameRef:CTFrame! = CTFramesetterCreateFrame(framesetter, Range, framePath, nil)
        
        // Core Text draws from the bottom-left corner up, so flip the current transform prior to drawing.
        if rotate {
            context.translateBy(x: 0, y: 792)
        }
        
        context.scaleBy(x: 1.0, y: -1.0)
        CTFrameDraw(frameRef, context) // Draw the frame.
        
        // Update the current range based on what was drawn.
        Range = CTFrameGetVisibleStringRange(frameRef)
        Range.location += Range.length
        Range.length = 0
        
        return Range
    }
    
// MARK: - *** FUNCTIONS: DRAWING ***
    /// Draw a page number at the bottom of the page.
    func drawPageNumber(pageNum:Int!, customY:CGFloat? = 0.0) -> Void {
        let defaultFont:UIFont! = UIFont(name: "HelveticaNeue-Light", size: 12) ?? UIFont.systemFont(ofSize: 12)
        
        /* Get page number print format */
        let format:String! = pdfPageSize.pageNum_Format.format 

        /* Determine the WIDTH of the drawn text size so that it's placement on page can be calculated */
        let pageString:String! = String(format: format, arguments: [pageNum])
        let style:NSMutableParagraphStyle! = NSMutableParagraphStyle()
            style.lineBreakMode = .byWordWrapping

        let attribs:[NSAttributedString.Key:Any] = [
            .font: defaultFont!,
            .paragraphStyle: style!,
        ]

        let pageStringSize:CGSize! = pageString.size(withAttributes: attribs)

        /* Determine the Left Margin of page via Alignment parameter */
        var margin_Left:CGFloat!
        switch pdfPageSize.pageNum_Alignment as kAlignment {
            case .left: margin_Left = pdfPageSize.margin_Left
            case .center: margin_Left = (pdfPageSize.margin_Left + (pdfCurrentVals.pageWidth - pageStringSize.width)) / 2.0
            case .right: margin_Left = (pdfCurrentVals.margin_Right - pageStringSize.width)
        }
        
        /* Create the rect space to draw the text into */
        var Y:CGFloat = pdfCurrentVals.margin_Bottom
        
        if customY! > 0.0 {
            Y = customY!
        }
        
        let stringRect = CGRect(x: margin_Left,
                                y: Y + 5,
                            width: pageStringSize.width,
                           height: pageStringSize.height)

        /* Draw the actual Text in its proper position */
        pageString.draw(in: stringRect, withAttributes: attribs)
    }

    /// Draw a line on page.
    func drawLine(width:CGFloat,color:UIColor,from:CGPoint,to:CGPoint) -> Void {
        let context:CGContext! = UIGraphicsGetCurrentContext()
            context.beginPath()
                context.setLineWidth(width)
                context.setStrokeColor(color.cgColor)
                context.move(to: CGPoint(x: from.x, y: from.y))
                context.addLine(to: CGPoint(x: to.x, y: to.y))
            context.closePath()
        
            context.drawPath(using: CGPathDrawingMode.fillStroke)
    }

    
    /// Draw crop marks on page.
    func drawCropMarks(innerRect:CGRect, markLength:CGFloat, color:UIColor? = .red) -> Void {
        var X:CGFloat = innerRect.origin.x
        var Y:CGFloat = innerRect.origin.y
        
        /* Top left */
        drawLine(width: 1.0, color: color!, from: CGPoint(x:X, y:Y),
                                              to: CGPoint(x:X, y:Y - markLength))
        drawLine(width: 1.0, color: color!, from: CGPoint(x:X, y:Y),
                                              to: CGPoint(x:X - markLength, y:Y))

        /* Bottom left */
        Y += innerRect.size.height
        drawLine(width: 1.0, color: color!, from: CGPoint(x:X, y:Y),
                                              to: CGPoint(x:X, y:Y + markLength))
        drawLine(width: 1.0, color: color!, from: CGPoint(x:X, y:Y),
                                              to: CGPoint(x:X - markLength, y:Y))

        /* Top right */
        X += innerRect.size.width
        Y = innerRect.origin.y
        drawLine(width: 1.0, color: color!, from: CGPoint(x:X, y:Y),
                                              to: CGPoint(x:X, y:Y - markLength))
        drawLine(width: 1.0, color: color!, from: CGPoint(x:X, y:Y),
                                              to: CGPoint(x:X + markLength, y:Y))
        
        /* Bottom right */
        Y = Y + innerRect.size.height
        drawLine(width: 1.0, color: color!, from: CGPoint(x:X, y:Y),
                                              to: CGPoint(x:X, y:Y + markLength))
        drawLine(width: 1.0, color: color!, from: CGPoint(x:X, y:Y),
                                              to: CGPoint(x:X + markLength, y:Y))
    }
    
    /// Draw a box on page.
    func drawBox(rect:CGRect,width:CGFloat,lineColor:UIColor,fill:Bool,fillColor:UIColor) -> Void {
        let context:CGContext! = UIGraphicsGetCurrentContext()
            context.setLineWidth(width)
            context.setStrokeColor(lineColor.cgColor)
            context.addRect(rect)
            context.strokePath()
        
        if fill {
            context.setFillColor(fillColor.cgColor)
            context.fill(rect)
        }
    }

    /// Draw a border around page.
    func drawBorder(width:CGFloat,inset:CGFloat,color:UIColor) -> Void {
        let rect:CGRect! = CGRect(x: pdfPageSize.margin_Left - inset,
                                  y: pdfPageSize.margin_Top - inset,
                              width: pdfCurrentVals.pageWidth,
                             height: pdfCurrentVals.pageHeight)

        let context:CGContext! = UIGraphicsGetCurrentContext()
            context.setStrokeColor(color.cgColor)
            context.setLineWidth(width)
            context.stroke(rect)
    }

    /// Draw text.
    func drawText(text:String,fontName:String,fontSize:CGFloat,inRect:CGRect,alignment:NSTextAlignment,color:UIColor? = .black) -> Void {
        let context:CGContext! = UIGraphicsGetCurrentContext()
            context.setFillColor(color!.cgColor)
        
        let style:NSMutableParagraphStyle! = NSMutableParagraphStyle()
            style.lineBreakMode = .byWordWrapping
        
        switch alignment {
            case .left: style.alignment = .left
            case .center: style.alignment = .center
            case .right: style.alignment = .right
            default: style.alignment = .left
        }

        let attribs:[NSAttributedString.Key:Any] = [
            .font:UIFont(name:fontName,size:fontSize) ?? UIFont.systemFont(ofSize:fontSize),
            .paragraphStyle:style!,
            .foregroundColor:color!
        ]

        text.draw(in: inRect, withAttributes: attribs)
    }

    /// Draw text.
    func drawSizedText(text:String,
                       fontName:String,
                       size_Max:CGFloat,
                       size_Min:CGFloat,
                       alignment:NSTextAlignment,
                       inRect:CGRect,
                       color:UIColor? = .black,
                       hilightLinks:Bool? = false,
                       searchFor:String? = "",
                       urlLink:String? = "") -> Void {
        
        var fontSize:CGFloat = size_Max + 1
        let style:NSMutableParagraphStyle! = NSMutableParagraphStyle()
            style.lineBreakMode = .byTruncatingTail
        
        switch alignment {
            case .left: style.alignment = .left
            case .center: style.alignment = .center
            case .right: style.alignment = .right
            default: style.alignment = .left
        }
        
        var attribs:[NSAttributedString.Key:Any] = [
            .font:UIFont(name:fontName,size:fontSize) ?? UIFont.systemFont(ofSize:fontSize),
            .paragraphStyle:style!,
            .foregroundColor:color!
        ]
        
        var stringSize:CGSize
        
        repeat{
            fontSize -= 1
            attribs = [
                .font:UIFont(name:fontName,size:fontSize) ?? UIFont.systemFont(ofSize:fontSize),
                .paragraphStyle:style!,
                .foregroundColor:color!
            ]
            stringSize = text.size(withAttributes: attribs)
        } while ((CGFloat(stringSize.height) >= inRect.size.height) || (CGFloat(stringSize.width) >= inRect.size.width)) &&
                (fontSize >= size_Min)

        if hilightLinks! {
            let allText:NSMutableAttributedString = NSMutableAttributedString.init(string: text, attributes: attribs)
                allText.setAsLink(textToFind: searchFor!,
                                     linkURL: urlLink!,
                                        font: UIFont(name:fontName,size:fontSize) ?? UIFont.systemFont(ofSize:fontSize),
                                activateLink: true)

            allText.draw(in: CGRect(x: inRect.origin.x,
                                    y: inRect.origin.y,
                                width: inRect.size.width,
                               height: inRect.size.height))
        }else{
            text.draw(in: CGRect(x: inRect.origin.x,
                                 y: inRect.origin.y,
                             width: inRect.size.width,
                            height: inRect.size.height),
          withAttributes: attribs)
        }
    }

    func drawSizedTextMultiline(text:String,fontName:String,size_Max:CGFloat,size_Min:CGFloat,alignment:NSTextAlignment,inRect:CGRect,color:UIColor? = .black) -> Void {
        var fontSize:CGFloat = size_Max + 1
        let style:NSMutableParagraphStyle! = NSMutableParagraphStyle()
            style.lineBreakMode = .byWordWrapping
        
        switch alignment {
            case .left: style.alignment = .left
            case .center: style.alignment = .center
            case .right: style.alignment = .right
            default: style.alignment = .left
        }
        
        var htNeeded:CGFloat = 0
        var Attribs:[NSAttributedString.Key:Any] = [
            .font:UIFont(name:fontName,size:fontSize) ?? UIFont.systemFont(ofSize:fontSize),
            .paragraphStyle:style!,
            .foregroundColor:color!
        ]

        repeat {
            fontSize -= 1
            Attribs = [
                .font:UIFont(name:fontName,size:fontSize) ?? UIFont.systemFont(ofSize:fontSize),
                .paragraphStyle:style!,
                .foregroundColor:color!
            ]
            
            htNeeded = NSAttributedString().PDFheightNeeded(txt: text, maxWidth: inRect.width, attribs: Attribs)
        } while ((htNeeded >= inRect.height) && (fontSize >= size_Min))
        
        text.draw(in: CGRect(x: inRect.origin.x,
                             y: inRect.origin.y,
                         width: inRect.size.width,
                        height: inRect.size.height),
                     withAttributes: Attribs)
    }

/// Draw image on page.
    func drawImage(img:UIImage,rect:CGRect,linkShow:Bool,link:String) -> Void {
        img.draw(in: rect)
        
        if linkShow {
            /* Invert Rect Y Position as UIKit and Core Graphics ordinal positions are inverted from each other */
            var linkRect = rect
                linkRect.origin.y = pdfCurrentVals.pageHeight - rect.origin.y + pdfCurrentVals.margin_Top
            
            UIGraphicsGetCurrentContext()!.setURL(URL(string: link)! as CFURL, for: linkRect)
        }
    }

    /// Draw a table on page.
    func drawTableAt(originPoint:CGPoint,
                       rowHeight:CGFloat,
                         numRows:Int,
                       lineColor:UIColor,
                       lineWidth:CGFloat,
                    arrColWidths:[CGFloat],
                        arrLines:[Bool],
                         arrFill:[Bool],
                   arrFillColors:[UIColor]) -> Void {

        var iColWidth:CGFloat!
        let iNumCols = arrColWidths.count
        var iNewX:CGFloat! = originPoint.x
        var iNewY:CGFloat! = originPoint.y
        for _ in 0..<numRows {
            for j in 0..<iNumCols {
                iColWidth = arrColWidths[j]
                
                drawBox(rect: CGRect(x: iNewX,y: iNewY,width: iColWidth,height: rowHeight),
                       width: lineWidth,
                   lineColor: arrLines[j] ?lineColor :.clear,
                        fill: arrFill[j],
                   fillColor: arrFillColors[j])

                iNewX = iNewX + iColWidth
            }

            iNewX = originPoint.x
            iNewY = iNewY + rowHeight
        }
    }
    
    func drawWebsiteLink(position: kAlignment) {
        let wide:CGFloat = (pdfCurrentVals.pageWidth - 200)
        
        /* Determine the Left Margin of page via Alignment parameter */
        var margin_Left:CGFloat!
        switch position as kAlignment {
            case .left: margin_Left = pdfPageSize.margin_Left + 5
            case .center: margin_Left = (pdfPageSize.margin_Left + (pdfCurrentVals.pageWidth - wide)) / 2.0
            case .right: margin_Left = (pdfCurrentVals.margin_Right - wide)
        }
        
        drawText(text: "\("Website".localizedCAS()): \(appInfo.COMPANY.WEBSITE_URLS.company!)",
             fontName: "HelveticaNeue",
             fontSize: 10,
               inRect: CGRect(x: margin_Left,y: pdfCurrentVals.margin_Bottom,width: wide,height: 20),
            alignment: .center,
                color: .black)
        
        drawText(text: "\("Search for".localizedCAS()) '\(appInfo.EDITION.name!)' \("in the Appstore".localizedCAS())",
             fontName: "HelveticaNeue",
             fontSize: 10,
               inRect: CGRect(x: margin_Left,y: pdfCurrentVals.margin_Bottom + 12,width: wide,height: 20),
            alignment: .center,
                color: gAppColor)
    }
    
    func drawAppStoreLogo(position: kAlignment) {
        let badgeWidth:CGFloat = 84
        
        /* Determine the Left Margin of page via Alignment parameter */
        var margin_Left:CGFloat!
        switch position as kAlignment {
            case .left: margin_Left = pdfPageSize.margin_Left + 5
            case .center: margin_Left = (pdfPageSize.margin_Left + (pdfCurrentVals.pageWidth - badgeWidth)) / 2.0
            case .right: margin_Left = (pdfCurrentVals.margin_Right - badgeWidth)
        }
        
        var badgeImg:UIImage = #imageLiteral(resourceName: "AppStore_Badge_En")
        if gAppLanguageCode.uppercased().contains("ES") {
            badgeImg = #imageLiteral(resourceName: "AppStore_Badge_Es")
        }
        
        drawImage(img: badgeImg,
                 rect: CGRect(x: margin_Left,
                              y: pdfCurrentVals.margin_Bottom,
                          width: badgeWidth,
                         height: 25),
             linkShow: true,
                 link: appInfo.EDITION.appStore.ext_URL)
    }
    
// MARK: - *** CLASSES ***
    /// Paper Sizes (Name, Width, Height, Margin, Idx)
    class PageSize_Settings {
        var pageSize:PaperSize!
        var width:CGFloat!
        var height:CGFloat!
        var margin_Left:CGFloat!
        var margin_Right:CGFloat!
        var margin_Top:CGFloat!
        var margin_Bottom:CGFloat!
        var pageNum_Show:Bool!
        var pageNum_Format:PageNum!
        var pageNum_Alignment:kAlignment!
        var border_Show:Bool!
        var border_Color:UIColor!
        var border_Width:CGFloat!
        var logo_Show:Bool!
        var logo_Alignment:kAlignment!
        var appStore_Show:Bool!
        var appStore_Alignment:kAlignment!
        var website_Show:Bool!
        var website_Alignment:kAlignment!
        var website_showLink:Bool!
        
        init(
                width:CGFloat? = 0.0,
                height:CGFloat? = 0.0,
           margin_Left:CGFloat? = 0.0,
          margin_Right:CGFloat? = 0.0,
            margin_Top:CGFloat? = 0.0,
         margin_Bottom:CGFloat? = 0.0,
              pageSize:PaperSize? = PaperSizeFormat.Letter,
          pageNum_Show:Bool? = false,
                pageNum_Format:PageNum? = PageNumFormat.pageDashNumDash,
     pageNum_Alignment:kAlignment? = .center,
           border_Show:Bool? = false,
          border_Color:UIColor? = .black,
          border_Width:CGFloat? = 0,
             logo_Show:Bool? = false,
        logo_Alignment:kAlignment? = .center,
         appStore_Show:Bool? = false,
    appStore_Alignment:kAlignment? = .center,
          website_Show:Bool? = false,
     website_Alignment:kAlignment? = .center,
      website_showLink:Bool? = false){
                
            self.width = width
            self.height = height
            self.margin_Left = margin_Left
            self.margin_Right = margin_Right
            self.margin_Top = margin_Top
            self.margin_Bottom = margin_Bottom
            self.pageNum_Show = pageNum_Show
            self.pageNum_Format = pageNum_Format
            self.pageNum_Alignment = pageNum_Alignment
            self.border_Show = border_Show
            self.border_Color = border_Color
            self.border_Width = border_Width
            self.logo_Show = logo_Show
            self.logo_Alignment = logo_Alignment
            self.appStore_Show = appStore_Show
            self.appStore_Alignment = appStore_Alignment
            self.website_Show = website_Show
            self.website_Alignment = website_Alignment
            self.website_showLink = website_showLink
        }
    }
    
    
// MARK: - *** STRUCTS ***
    /// Page Number Formats (name,format)
    struct PageNum {
        let name:String
        let format:String
    }
    
    struct PageNumFormat {
        static let pageDashNumDash = PageNum.init(name: "page -#-", format: "Page -%d-")
        static let pageNum = PageNum.init(name:"page #",format:"Page %d")
        static let dashNumDash = PageNum.init(name:"-#-",format:"-%d-")
        static let parenNumParen = PageNum.init(name:"(#)",format:"(%d)")

        // To search arr, use pagenumarray = PageNumFormat().arr.filter("name=Letter")
        static let arr:[PageNum] = [pageDashNumDash,pageNum,dashNumDash,parenNumParen]
    }
    
    /// Paper Sizes (Name, Width, Height, Margin)
    struct PaperSize {
        let name:String
        let width:CGFloat
        let height:CGFloat
        let margin:CGFloat
    }
    
    struct PaperSizeFormat {
        /* U.S. Formats */
        static let Letter = PaperSize.init(name:"Letter",width:612.0,height:792.0,margin:35.0)
        static let LetterSmall = PaperSize.init(name:"LetterSmall",width:612.0,height:792.0,margin:35.0)
        static let Legal = PaperSize.init(name:"Legal",width:612.0,height:1008.0,margin:35.0)
        /* European Formats */
        static let A0 = PaperSize.init(name:"A0",width:2384.0,height:3371.0,margin:35.0)
        static let A1 = PaperSize.init(name:"A1",width:1685.0,height:2384.0,margin:35.0)
        static let A2 = PaperSize.init(name:"A2",width:1190.0,height:1684.0,margin:35.0)
        static let A3 = PaperSize.init(name:"A3",width:842.0,height:1190.0,margin:35.0)
        static let A4 = PaperSize.init(name:"A4",width:595.0,height:842.0,margin:35.0)
        static let A4Small = PaperSize.init(name:"A4Small",width:595.0,height:842.0,margin:35.0)
        static let A5 = PaperSize.init(name:"A5",width:420.0,height:595.0,margin:35.0)
        static let B4 = PaperSize.init(name:"B4",width:729.0,height:1032.0,margin:35.0)
        static let B5 = PaperSize.init(name:"B5",width:516.0,height:729.0,margin:35.0)
        /* Other Formats */
        static let Statement = PaperSize.init(name:"Statement",width:396.0,height:612.0,margin:35.0)
        static let Executive = PaperSize.init(name:"Executive",width:540.0,height:720.0,margin:35.0)
        static let Tabloid = PaperSize.init(name:"Tabloid",width:792.0,height:1224.0,margin:35.0)
        static let Ledger = PaperSize.init(name:"Ledger",width:1224.0,height:792.0,margin:35.0)
        static let Folio = PaperSize.init(name:"Folio",width:612.0,height:780.0,margin:35.0)
        static let Quarto = PaperSize.init(name:"Quarto",width:610.0,height:780.0,margin:35.0)
        static let WideLegal = PaperSize.init(name:"WideLegal",width:720.0,height:1008.0,margin:35.0)
        static let Magazine = PaperSize.init(name:"Magazine",width:720.0,height:1008.0,margin:35.0)

        // To search arr, use pagesizearray = PaperSize().arr.filter("name=Letter")
        static let arrUS:[PaperSize] = [Letter,LetterSmall,Legal]
        static let arrEU:[PaperSize] = [A0,A1,A2,A3,A4,A4Small,A5,B4,B5]
        static let arrOther:[PaperSize] = [Statement,Executive,Tabloid,Ledger,Folio,Quarto,WideLegal,Magazine]
        static let arrAll:[PaperSize] = arrUS + arrEU + arrOther
    }

    /// Current drawing positions
    struct current {
        var x:CGFloat
        var y:CGFloat
        var h:CGFloat
        var w:CGFloat
        var margin:CGFloat
        var textInset:CGFloat
        var rowHt:CGFloat
        var pageNum:Int
        var pageWidth:CGFloat
        var pageHeight:CGFloat
        var margin_Top:CGFloat
        var margin_Bottom:CGFloat
        var margin_Right:CGFloat
        
        init (x:CGFloat?=0.0,y:CGFloat?=0.0,h:CGFloat?=0.0,w:CGFloat?=0.0,margin:CGFloat?=0.0,textInset:CGFloat?=5.0,
              rowHt:CGFloat?=20.0,pageNum:Int?=0,pageWidth:CGFloat?=0.0,margin_Top:CGFloat?=0.0,margin_Bottom:CGFloat?=0.0,
              pageHeight:CGFloat?=0.0,margin_Right:CGFloat?=0.0) {
            
            self.x = x!
            self.y = y!
            self.h = h!
            self.w = w!
            self.margin = margin!
            self.textInset = textInset!
            self.rowHt = rowHt!
            self.pageNum = pageNum!
            self.pageWidth = pageWidth!
            self.pageHeight = pageHeight!
            self.margin_Top = margin_Top!
            self.margin_Bottom = margin_Bottom!
            self.margin_Right = margin_Right!
        }
    }
}

extension NSAttributedString {
    func PDFheightNeeded(txt:String, maxWidth:CGFloat, attribs:[NSAttributedString.Key : Any]) -> CGFloat {
        let text = NSString(string: txt)
        
        let rect:CGRect = text.boundingRect(with: CGSize(width:maxWidth, height: CGFloat.greatestFiniteMagnitude),
                                            options: .usesLineFragmentOrigin,
                                            attributes: attribs,
                                            context: nil)
        
        let estHeight = rect.size.height
        
        let maxHt = (pdfCurrentVals.pageHeight - 50)
        
        return (estHeight > maxHt) ?maxHt :estHeight
    }
}

