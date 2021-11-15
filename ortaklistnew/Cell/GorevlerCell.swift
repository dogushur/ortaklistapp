import UIKit
import M13Checkbox

class GorevlerCell: UITableViewCell {
    
    var didSetupConstraints = false
    
    var gorevlerbg = UIView()
    var gorevlerbgic = UIView()
    
    var gorevcheck = M13Checkbox()
    
    var gorevbaslik = UILabel()
    
    var gorevlercizgi = UIView()
    
    var gorevtikla = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        //let screenHeight = screenSize.height
        
        gorevlerbg.backgroundColor = UIColor.clear
        contentView.addSubview(gorevlerbg)
        
        gorevlerbgic.backgroundColor = UIColor.clear
        gorevlerbg.addSubview(gorevlerbgic)
        
        gorevcheck.markType = .checkmark
        gorevcheck.tintColor = UIColor("#0984e3")
        gorevlerbgic.addSubview(gorevcheck)
        
        gorevbaslik.textColor = UIColor("#cccccc")
        gorevbaslik.backgroundColor = UIColor.clear
        gorevbaslik.font = UIFont(name: "Ubuntu-Regular", size: 17.0)
        gorevbaslik.numberOfLines = 0
        gorevlerbgic.addSubview(gorevbaslik)
        
        gorevlercizgi.backgroundColor = UIColor("#555")
        gorevlerbg.addSubview(gorevlercizgi)
        
        gorevtikla.backgroundColor = UIColor.clear
        gorevlerbgic.addSubview(gorevtikla)
        
        self.contentView.setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        if(!didSetupConstraints){
            
            gorevlerbg.left(0).right(0).top(0).bottom(0)
            gorevlerbgic.left(25).right(25).top(0).bottom(0)
            gorevcheck.left(0).width(35).height(35).centeredOnY()
            gorevbaslik.left(45).right(0).top(20).bottom(20)
            gorevlercizgi.left(0).right(0).pinTo(view: gorevlerbg, top: -1).height(1)
            gorevtikla.left(45).right(0).top(0).bottom(0)
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


