/*--------------------------------------------------------------------------------------------------------------------------
     File: class_Products.swift
   Author: Kevin Messina
  Created: May 29, 2018
 Modified:

 ©2018-2020 Creative App Solutions, LLC. - All Rights Reserved.
----------------------------------------------------------------------------------------------------------------------------
 NOTES:
--------------------------------------------------------------------------------------------------------------------------*/


// MARK: - *** CLASS ***
class Products:NSObject {
    let Version:String = "1.01"
    let name:String = "Products"

// MARK: - *********************************************************
// MARK: FUNCTIONS
// MARK: *********************************************************
    func returnOldSKUforItem(sizeIndex:Int? = item.size,colorIndex:Int? = item.color) -> String {
        let sizeCode = Frame_Size_Names[sizeIndex!].replacingOccurrences(of: "\"", with: "")
        let colorCode = frameColorCodes.arr[colorIndex!]
        
        item.SKU = "\(sizeCode)\(colorCode)"
        
        return item.SKU
    }

    /// If there is no photo selected, the carousel must show all frame shapes, so item size needs to be offset
    /// to be able to cycle square then rectangular frame images.
    func returnOffsetItemSize() -> (offset:Int,newIndex:Int) {
        var indexOffset = 0
        var newIndex = 0
        
        if isPhotoSelected() {
            indexOffset = item.photo.isSquare ?0 :CMS_Frames_Square.count
        }

        newIndex = (item.size + indexOffset)
        
        simPrint().info(">>>>>>>>>> Offset: \( indexOffset ), Index+Offset: \( newIndex ) ",function:#function,line:#line)
        return (indexOffset,newIndex)
    }
    
    /// item.size is used to build SKU otherwise it searched by separated component breakdown
    func returnNewSKUforItem() -> String {
        let sizeIndex = returnOffsetItemSize().newIndex

        let photoSize:String = Frame_Size_Names[sizeIndex].replacingOccurrences(of:"\"", with: "").trimSpaces
        let frameSize:String = Frame_FramedSize_NamesDecimal[sizeIndex].trimSpaces
        let frameColor:String = (CMS_frame_colors.filter({ $0.code.uppercased() == frameColorCodes.arr[item.color].uppercased() }).first?.code ?? "").trimSpaces
        
        // Try and find SKU from components
        if let newSKU = Frames.products().returnProductSkuFrom(photoSize:photoSize,frameSize:frameSize,frameColor:frameColor) {
            item.SKU = newSKU
            simPrint().info("SKU found: \( item.SKU ?? "n/a" )",function:#function,line:#line)
        }else{ // Buid the SKU manually
            simPrint().info("SKU \( item.SKU ?? "n/a" ) ***** NOT found! Building from components...",function:#function,line:#line)
            let version:String = "A".uppercased().trimSpaces
            let format:Int = item.photo.isSquare
                ?frameFormatFilters.square.rawValue
                :frameFormatFilters.rectangular.rawValue
            let shape:String = frameFormatCodes.arr[format].uppercased().trimSpaces
            let style:String = frameStyleCodes.arr[item.style].uppercased().trimSpaces
            let matteColor:String =  "WH".uppercased().trimSpaces
            let material:String = "WD".uppercased().trimSpaces

            item.SKU = "\(version)-\(photoSize)-\(frameSize)-\(frameColor)-\(shape)-\(style)-\(matteColor)-\(material)"
        }
        
        simPrint().info("item SKU: \( item.SKU ?? "n/a" )",function:#function,line:#line)
        
        return item.SKU
    }

    func returnComponentsFromPhotoFilename(filename:String) -> (
            orderNum:String,photoNum:String,photoSize:String,frameSize:String,frameColor:String,frameShape:String,
            frameStyle:String,matteColor:String,frameMaterial:String,fileType:String,SKU:String
        ) {
            
        let fileType = filename.pathExtension

        var startIndex = filename.range(of: "Photo_")?.upperBound
        var endIndex = filename.range(of: "_SKU_")?.lowerBound

        let photoString = String(filename[startIndex!..<endIndex!])
        let photoComponents:[String] = photoString.components(separatedBy: "_")
        let orderNum = photoComponents[0]
        let photoNum = photoComponents[1]

        startIndex = filename.range(of: "_SKU_")?.upperBound
        endIndex = filename.range(of: ".\(fileType)")?.lowerBound
        let SKUString = String(filename[startIndex!..<endIndex!])
        let SKUComponents:[String] = SKUString.components(separatedBy: "-")
        let _ = SKUComponents[0] // SKU encoding format version
        let photoSize = SKUComponents[1]
        let frameSize = SKUComponents[2]
        let frameColor = SKUComponents[3]
        let frameShape = SKUComponents[4]
        let frameStyle = SKUComponents[5]
        let matteColor = SKUComponents[6]
        let frameMaterial = SKUComponents[7]

        // example: Photo_2380_1_SKU_A-4x4-5.8x5.8-GY-SQ-SL-WH-WD.png

        return (
            orderNum,
            photoNum,
            photoSize,
            frameSize,
            frameColor,
            frameShape,
            frameStyle,
            matteColor,
            frameMaterial,
            fileType,
            SKUString
        )
    }

    func returnDocumentNameFrom(filename:String) -> (orderNum:String,orderFolder:String,fileType:String,documentName:String) {
        let fileType = filename.pathExtension

        switch fileType.lowercased() {
            case "png": ()
                let startIndex = filename.range(of: "Photo_")?.upperBound
                let endIndex = filename.range(of: "_SKU_")?.lowerBound
                let photoString = String(filename[startIndex!..<endIndex!])
                let photoComponents:[String] = photoString.components(separatedBy: "_")
                let orderNum = photoComponents[0]
//                let photoNum = photoComponents[1]
                return (orderNum,"Order_\( orderNum )",fileType.lowercased(),"Photo_\( photoString )")
            case "pdf":
                let startIndex = filename.range(of: "_")?.upperBound
                let endIndex = filename.range(of: ".")?.lowerBound
                let orderNum = String(filename[startIndex!..<endIndex!])
                let filename = String(filename[filename.startIndex..<filename.range(of: "_")!.lowerBound])
                return (orderNum,"Order_\( orderNum )",fileType.lowercased(),filename)
            default:
                return ("","",fileType.lowercased(),"")
        }
    }
}
