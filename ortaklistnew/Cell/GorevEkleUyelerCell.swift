import UIKit
import M13Checkbox

class GorevEkleUyelerCell: UITableViewCell {
    
    var didSetupConstraints = false
    
    var kisilerbg = UIView()
    var kisilerbgic = UIView()
    var kisilercheck = M13Checkbox()
    var kisilerbaslik = UILabel()
    var kisilercizgi = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        //let screenHeight = screenSize.height
        
        kisilerbg.backgroundColor = UIColor.clear
        contentView.addSubview(kisilerbg)
        
        kisilerbgic.backgroundColor = UIColor.clear
        kisilerbg.addSubview(kisilerbgic)
        
        kisilercheck.markType = .checkmark
        kisilercheck.tintColor = UIColor("#0984e3")
        kisilerbgic.addSubview(kisilercheck)
        
        kisilerbaslik.textColor = UIColor("#cccccc")
        kisilerbaslik.backgroundColor = UIColor.clear
        kisilerbaslik.font = UIFont(name: "Ubuntu-Regular", size: 17.0)
        kisilerbaslik.numberOfLines = 0
        kisilerbgic.addSubview(kisilerbaslik)
        
        kisilercizgi.backgroundColor = UIColor("#555")
        kisilerbg.addSubview(kisilercizgi)
        
        self.contentView.setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        if(!didSetupConstraints){
            
            kisilerbg.left(0).right(0).top(0).bottom(0)
            kisilerbgic.left(25).right(25).top(0).bottom(0)
            kisilercheck.left(0).width(35).height(35).centeredOnY()
            kisilerbaslik.left(45).right(0).top(20).bottom(20)
            kisilercizgi.left(0).right(0).pinTo(view: kisilerbg, top: -1).height(1)
            
            didSetupConstraints = true
            
        }
        
        super.updateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}




