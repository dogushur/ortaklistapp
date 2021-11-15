import UIKit
import PureLayout

class GorevMesajCell: UITableViewCell {
    
    var didSetupConstraints = false
    
    var genelmesaj = UIView()
    
    var gelenmesajisim = UILabel()
    var gelenmesajbg = UIView()
    var gelenmesajtext = UILabel()
    
    var gidenmesajbg = UIView()
    var gidenmesajtext = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        //let screenHeight = screenSize.height
        
        gelenmesajisim.textColor = UIColor("#cccccc")
        gelenmesajisim.textAlignment = .left
        gelenmesajisim.font = UIFont(name: "Ubuntu-Medium", size: 10)
        contentView.addSubview(gelenmesajisim)
        
        gelenmesajbg.backgroundColor = UIColor("#3FC354")
        gelenmesajbg.clipsToBounds = true
        gelenmesajbg.layer.cornerRadius = 15
        contentView.addSubview(gelenmesajbg)
        
        gelenmesajtext.textColor = UIColor.white
        gelenmesajtext.numberOfLines = 0
        gelenmesajtext.textAlignment = .center
        gelenmesajtext.font = UIFont(name: "Ubuntu-Medium", size: 17)
        gelenmesajbg.addSubview(gelenmesajtext)
        
        //
        
        gidenmesajbg.backgroundColor = UIColor("#0984e3")
        gidenmesajbg.clipsToBounds = true
        gidenmesajbg.layer.cornerRadius = 15
        contentView.addSubview(gidenmesajbg)
        
        gidenmesajtext.textColor = UIColor.white
        gidenmesajtext.numberOfLines = 0
        gidenmesajtext.textAlignment = .center
        gidenmesajtext.font = UIFont(name: "Ubuntu-Medium", size: 17)
        gidenmesajbg.addSubview(gidenmesajtext)
        
        self.contentView.setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        if(!didSetupConstraints){
            
            gelenmesajisim.left(35).top(0).width(170).height(15)
            gelenmesajbg.left(25).top(15).bottom(10)
            gelenmesajtext.left(15).bottom(15).top(15).right(15).width(170)
            
            gidenmesajbg.top(10).bottom(10).right(25)
            gidenmesajtext.left(15).bottom(15).top(15).right(15).width(170)
            
            didSetupConstraints = true
            
        }
        
        super.updateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



