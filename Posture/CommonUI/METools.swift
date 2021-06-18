//
//  METools.swift
//  MandarinExam
//
//  Created by pisces_seven on 2021/5/17.
//  Copyright © 2021 LOL. All rights reserved.
//

import Foundation
import UIKit

let baiduSecretKey = "taPC1VFklyKeGbGBB6N9cwLuUx1I342u"
let baiduAppID = "24398069"
let baiduAPIKey = "O1cYshURsxB6Fh3I7BgbvqGw"
// 

public let ScreenWidth: CGFloat = UIScreen.main.bounds.width
public let ScreenHeight: CGFloat = UIScreen.main.bounds.height
public let ScreenScale: CGFloat = ScreenWidth/375.0
public var IsIPhoneXSeries :Bool { ScreenHeight / ScreenWidth > 17 / 9.0 }
public let SafeAreaInsets: UIEdgeInsets = IsIPhoneXSeries ? UIEdgeInsets.init(top: 44, left: 0, bottom: 34, right: 0) : UIEdgeInsets.init(top: 20, left: 0, bottom: 0, right: 0)
public let SafeTopHeight: CGFloat = SafeAreaInsets.top
public let SafeBottomHeight: CGFloat = SafeAreaInsets.bottom

let wordKean: CGFloat = 2.0     // 字间距
let lineHeight: CGFloat = 3.0   // 行间距

// 词显示线条样式
// index: 词索引 lineNumber：一行显示个数
// 返回结果：(顶部是否显示，左侧是否显示, 是否显示blue)
func wordsShowLineInfo(index: NSInteger, lineNumber: NSInteger) -> (Bool, Bool, Bool) {
    let value = index / lineNumber
    let isBlue = (value % 2) != 0
    
    var topShow = (index)/lineNumber == 0
    let leftShow = (index)%lineNumber == 0
    if leftShow == true, topShow == false {
        topShow = false
    }
    return (topShow, leftShow, isBlue)
}

extension UIColor {
    /// 将十六进制颜色转换为UIColor
    @objc convenience init(hexColor: String, alpha: CGFloat = 1.0) {
        self.init(hexString: hexColor, alpha: alpha)
    }
    
    convenience init(hex: UInt32, alpha: CGFloat = 1) {
        self.init(red: CGFloat((hex & 0xFF0000) >> 16)/255, green: CGFloat((hex & 0x00FF00) >> 8)/255, blue: CGFloat(hex & 0x0000FF)/255, alpha: alpha)
    }
    
    /// 将十六进制颜色转换为 UIColor
    @objc convenience init(hexString: String, alpha:CGFloat = 1.0) {
        var pureHexString = hexString
        if hexString.hasPrefix("#") {
            pureHexString.remove(at: pureHexString.firstIndex(of: "#")!)
        }
        
        // 存储转换后的数值
        var red: UInt32 = 0, green: UInt32 = 0, blue: UInt32 = 0
        
        // 分别转换进行转换
        Scanner(string: pureHexString[0..<2]).scanHexInt32(&red)
        
        Scanner(string: pureHexString[2..<4]).scanHexInt32(&green)
        
        Scanner(string: pureHexString[4..<6]).scanHexInt32(&blue)
        
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
    }
    
    convenience init(r: Int, g: Int, b: Int, a: Int = 255) {
        // 存储转换后的数值
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(a)/255.0)
    }
    
    //返回随机颜色
    class var uf_randomColor: UIColor {
        get {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
    
    /// view背景色, 适配暗黑模式
    class var uf_systemBackground: UIColor {
        get {
            let lightColor = UIColor.white
            let darkColor = UIColor.black
            if #available(iOS 13, *) {
                return UIColor { $0.userInterfaceStyle == .dark ? darkColor : lightColor }
            }
            return lightColor
        }
    }
    
    convenience init(red: Int, green: Int, blue: Int, alpha: Int = 1) {
        // 存储转换后的数值
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: CGFloat(alpha))
    }
    
    // 颜色转图片
    func colorToImage(size: CGSize) -> UIImage? {
        let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension String {
    
    func me_appendingPath(path: String) -> String {
        if let lastChar = self.last {
            let pathFirstChar = path.first
            return (lastChar == "/" || pathFirstChar == "/") ? self.appending(path) : self.appending("/\(path)")
        }
        return path
    }
    
    var uf_removeAllSapce: String {
        return self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }
    
    /// String使用下标截取字符串
    /// 例: "示例字符串"[0..<2] 结果是 "示例"
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
            return String(self[startIndex..<endIndex])
        }
    }
    
    /// 增加行间距、字间距
    func me_addLineAttribute(_ lineHeight: CGFloat = lineHeight,
                             kern: CGFloat = 0.5,
                             font: UIFont) -> NSMutableAttributedString {
        let paraph = NSMutableParagraphStyle.init()
        paraph.lineSpacing = lineHeight
        let  attributes = [NSAttributedString.Key.font: font,
                            NSAttributedString.Key.kern: kern,
                            NSAttributedString.Key.paragraphStyle : paraph] as [NSAttributedString.Key : Any]
        return NSMutableAttributedString.init(string: self, attributes: attributes)
    }
    
    /// 关键字富文本
    func me_protocolAttribute(_ line: Bool = true) -> NSMutableAttributedString{
        var attribute = NSMutableAttributedString.init(string: self)
        let textColor = UIColor.init(hexString: "#566173")
        if line {
            let paraph = NSMutableParagraphStyle.init()
            paraph.lineSpacing = lineHeight
            let  attributes = [ NSAttributedString.Key.font : UIFont .systemFont(ofSize: 14*ScreenScale, weight: .regular),
                                NSAttributedString.Key.paragraphStyle : paraph,
                                NSAttributedString.Key.foregroundColor: textColor]
            attribute = NSMutableAttributedString.init(string: self, attributes: attributes)
        }
        if self.count == 0 {
            return attribute
        }
        // 设置超链接富文本 《用户协议》
        let messages = [["value": "《用户协议》","link": "Agreement://"],
                        ["value": "《隐私政策》","link": "Privacy://"]]
        for model in messages {
            let ranges = self.yy_allYanges(of: model["value"] ?? "")
            for makeRange in ranges {
                attribute.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: makeRange)
                attribute.addAttribute(NSAttributedString.Key.underlineColor, value: UIColor.init(hexString: "#5B77F2"), range: makeRange)
                attribute.addAttribute(NSAttributedString.Key.link, value: model["link"] ?? "ME://", range: makeRange)
            }
        }
        
        let blodMessages = ["我们向你申请使用以下权限："]
        for model in blodMessages {
            let ranges = self.yy_allYanges(of: model)
            for makeRange in ranges {
                attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 14*ScreenScale, weight: .bold), range: makeRange)
            }
        }
        
        return attribute
    }
    
    func ranges(of string: String) -> [Range<String.Index>] {
        var rangeArray = [Range<String.Index>]()
        var searchedRange: Range<String.Index>
        guard let sr = self.range(of: self) else {
            return rangeArray
        }
        searchedRange = sr
        
        var resultRange = self.range(of: string, options: .regularExpression, range: searchedRange, locale: nil)
        while let range = resultRange {
            rangeArray.append(range)
            searchedRange = Range(uncheckedBounds: (range.upperBound, searchedRange.upperBound))
            resultRange = self.range(of: string, options: .regularExpression, range: searchedRange, locale: nil)
        }
        return rangeArray
    }
    // 获取所有NSRange
    func yy_allYanges(of string: String) -> [NSRange] {
        return ranges(of: string).map { (range) -> NSRange in
            self.yy_rangeRoNSRange(fromRange: range)
        }
    }
    // range转NSRange
    func yy_rangeRoNSRange(fromRange range : Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }
    
    // MARK: - 富文本
    // 获取文本长度
    func yy_textWidth(font: UIFont) -> CGFloat {
        
        return self.boundingRect(with:CGSize(width:CGFloat(MAXFLOAT), height: font.pointSize+5.0), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [.font: font], context:nil).size.width
    }
    // 文本高度
    func yy_estimatedSize(withFont font: UIFont, maxWidth: CGFloat) -> CGSize {
        let string = self as NSString
        return string.boundingRect(with: CGSize(width: maxWidth, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil).size
    }
    
    /* 获取富文本的高度
     *
     * @param string    文字
     * @param lineSpace 行间距
     * @param font      字体大小
     * @param maxWidth     文本宽度
     *
     * @return size
     */
    func getAttributionHeightWithString(lineSpace: CGFloat = lineHeight,
                                        font: UIFont,
                                        maxWidth: CGFloat,
                                        kern: CGFloat = 0.5) -> CGSize {
        let paraph = NSMutableParagraphStyle.init()
        paraph.lineSpacing = lineSpace
        let  attributes = [NSAttributedString.Key.font: font,
                            NSAttributedString.Key.kern: kern,
                            NSAttributedString.Key.paragraphStyle: paraph] as [NSAttributedString.Key : Any]
        let string = self as NSString
        return string.boundingRect(with: CGSize(width: maxWidth, height: CGFloat(MAXFLOAT)), options: [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading,
                                                                                                       NSStringDrawingOptions.truncatesLastVisibleLine], attributes: attributes, context: nil).size
    }
    
}

extension NSMutableAttributedString {
    // 获取富文本bounds
    func me_attributeSize(width: CGFloat) -> CGSize {
        let rect = self.boundingRect(with: CGSize.init(width: width, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return rect.size
    }
}

extension Int {
    //数字转中文
    func intIntoString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "zh_CN")
        numberFormatter.numberStyle = NumberFormatter.Style.spellOut
        let numberStr = numberFormatter.string(from: NSNumber(value: self)) ?? ""
        return numberStr
    }
}

extension Date {
    func isBetweenFromHour(from: Int, to: Int) -> Bool {
        let dateFrom = self.getCustomDate(hour: from)
        let dateTo = self.getCustomDate(hour: to)
        let currentDate = Date()
        if currentDate.compare(dateFrom) == .orderedDescending && currentDate.compare(dateTo) == .orderedAscending {
            return true
        }
        return false
    }
    
    func getCustomDate(hour: Int) -> Date {
        let currentDate = Date()
        let currentCalendar = Calendar(identifier: .gregorian)
        var currentComps = DateComponents()
        
        let unitFlags = Set<Calendar.Component>([.year, .month, .day, .weekday, .hour, .minute, .second])
        currentComps = currentCalendar.dateComponents(unitFlags, from: currentDate)
        
        //设置当天的某个点
        var resultComps = DateComponents()
        resultComps.year = currentComps.year
        resultComps.month = currentComps.month
        resultComps.day = currentComps.day
        resultComps.hour = hour
        
        let resultCalendar = Calendar(identifier: .gregorian)
        return resultCalendar.date(from: resultComps) ?? Date()
    }
}

extension Int {
    var cn: String {
        get {
            if self == 0 {
                return "零"
            }
            let zhNumbers = ["零", "一", "二", "三", "四", "五", "六", "七", "八", "九"]
            let units = ["", "十", "百", "千", "万", "十", "百", "千", "亿", "十","百","千"]
            var cn = ""
            var currentNum = 0
            var beforeNum = 0
            let intLength = Int(floor(log10(Double(self))))
            for index in 0...intLength {
                currentNum = self/Int(pow(10.0,Double(index)))%10
                if index == 0{
                    if currentNum != 0 {
                        cn = zhNumbers[currentNum]
                        continue
                    }
                } else {
                    beforeNum = self/Int(pow(10.0,Double(index-1)))%10
                }
                if [1,2,3,5,6,7,9,10,11].contains(index) {
                    if currentNum == 1 && [1,5,9].contains(index) && index == intLength { // 处理一开头的含十单位
                        cn = units[index] + cn
                    } else if currentNum != 0 {
                        cn = zhNumbers[currentNum] + units[index] + cn
                    } else if beforeNum != 0 {
                        cn = zhNumbers[currentNum] + cn
                    }
                    continue
                }
                if [4,8,12].contains(index) {
                    cn = units[index] + cn
                    if (beforeNum != 0 && currentNum == 0) || currentNum != 0 {
                        cn = zhNumbers[currentNum] + cn
                    }
                }
            }
            return cn
        }
    }
}
