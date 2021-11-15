import UIKit
import PureLayout

class ListelerCell: UITableViewCell {
    
    var didSetupConstraints = false
    
    var listelerbg = UIView()
    var listelerbgic = UIView()
    
    var listeicon = UIButton(type: .custom)
    var listebaslik = UILabel()
    
    var listelercizgi = UIView()
    
    var listetikla = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        //let screenHeight = screenSize.height
        
        listelerbg = UIView(frame: CGRect(x:0,y:0,width:screenWidth,height:60))
        listelerbg.backgroundColor = UIColor.clear
        contentView.addSubview(listelerbg)
        
        listelerbgic = UIView(frame: CGRect(x:25,y:0,width:listelerbg.frame.width-50,height:listelerbg.frame.height))
        listelerbgic.backgroundColor = UIColor.clear
        listelerbg.addSubview(listelerbgic)
        
        listeicon = UIButton(frame: CGRect(x:0,y:10,width: 40,height: 40))
        listeicon.backgroundColor = UIColor.clear
        listeicon.imageView?.contentMode = .scaleAspectFit
        listelerbgic.addSubview(listeicon)
        
        listebaslik = UILabel(frame: CGRect(x:listeicon.frame.width+10,y:10,width: listelerbgic.frame.width-listeicon.frame.width-10,height: 40))
        listebaslik.textColor = UIColor("#cccccc")
        listebaslik.backgroundColor = UIColor.clear
        listebaslik.font = UIFont(name: "Ubuntu-Regular", size: 17.0)
        listelerbgic.addSubview(listebaslik)
        
        listelercizgi = UIView(frame: CGRect(x:0,y:listelerbg.frame.height-1,width:listelerbg.frame.width,height:1))
        listelercizgi.backgroundColor = UIColor("#555")
        listelerbg.addSubview(listelercizgi)
        
        listetikla = UIButton(frame: CGRect(x:0,y:0,width: listelerbg.frame.width,height: listelerbg.frame.height))
        listelerbg.addSubview(listetikla)
        
        self.contentView.setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

