import UIKit

class MenuButton: UIButton {

    //MARK: - Drawing 
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(arcCenter: rect.center, radius: rect.width/2, startAngle: 0, endAngle: .pi*2, clockwise: false)
        UIColor.white.setFill()
        path.fill()
        drawLineIn(CGRect(x: 10, y: 15, width: 21, height: 3))
        drawLineIn(CGRect(x: 10, y: 22, width: 21, height: 3))
    }
    
    private func drawLineIn(_ rect:CGRect) {
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 3.0)
        UIColor.black.setFill()
        path.fill()
    }

}
