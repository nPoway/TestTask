import UIKit

extension UIFont {
    static func customFont(size: CGFloat) -> UIFont {
            return UIFont(name: "Nunito Sans 7pt", size: size) ?? UIFont.systemFont(ofSize: size)
        }
}
