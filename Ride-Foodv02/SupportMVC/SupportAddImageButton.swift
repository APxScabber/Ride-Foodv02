import UIKit

class SupportAddImageButton: UIButton {

    //MARK: - API
    
    var buttonState: ButtonState = .active { didSet { setNeedsDisplay() }}
    
    //MARK: - Drawing
    
    override func draw(_ rect: CGRect) {
        switch buttonState {
            case .active: setImage(UIImage(named: SupportConstant.plusButton), for: .normal)
            case .inActive: drawInactiveButton()
            case .done:
                setImage(UIImage(named: SupportConstant.doneButton), for: .normal)
                isUserInteractionEnabled = false
        }
    }
    
    private func drawInactiveButton() {
        setImage(nil, for: .normal)
        let circlePath = UIBezierPath(arcCenter: bounds.center, radius: bounds.width/2, startAngle: 0, endAngle: .pi*2, clockwise: false)
        #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8156862745, alpha: 1).setFill()
        circlePath.fill()
        
        let linePath = UIBezierPath()
        
        linePath.move(to: CGPoint(x: bounds.width/3, y: bounds.height/3))
        linePath.addLine(to: CGPoint(x: bounds.width*2/3, y: bounds.height*2/3))

        linePath.move(to: CGPoint(x: bounds.width*2/3, y: bounds.height/3))
        linePath.addLine(to: CGPoint(x: bounds.width/3, y: bounds.height*2/3))
        
        linePath.lineWidth = 2.0
        UIColor.white.setStroke()
        linePath.stroke()
        
    }
    
    //MARK: - Button state
    
    enum ButtonState {
        case active
        case inActive
        case done
    }

}
