import UIKit
import DeviceKit
import SCLAlertView
import BRYXBanner
import UIColor_Hex_Swift
import Alamofire
import SwiftyJSON

class HomeController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let device = Device()
    
    let serviceurl = "http://ortaklist.com/webservices/android/service_app_22042017/"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        homesetup()
        
    }
    
    var homeust = UIView()
    var homelogo = UILabel()
    var homelogoalt = UILabel()
    
    var homealt = UIView()
    var kayitolbtn = UIButton()
    var homealtyazi = UILabel()
    var girisyapbtn = UIButton()
    
    func homesetup(){
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        //let screenHeight = screenSize.height
        
        view.backgroundColor = UIColor("#222222")
        
        if(device == .iPhone6sPlus || device == .iPhone7Plus || device == .iPhone6Plus || device == .iPhone8Plus){
            
        }else if(device == .iPhoneX || device == .iPhoneXs){
            homeust = UIView(frame: CGRect(x:0,y:150,width:screenWidth,height: 100))
            homelogo = UILabel(frame: CGRect(x:0,y:0,width:homeust.frame.width,height: 50))
            homelogoalt = UILabel(frame: CGRect(x:0,y:50,width:homeust.frame.width,height: 50))
            homealt = UIView(frame: CGRect(x:25,y:400,width:screenWidth-50,height: 260))
            kayitolbtn = UIButton(frame: CGRect(x:0,y:0,width:homealt.frame.width,height: 80))
            homealtyazi = UILabel(frame: CGRect(x:0,y:100,width:homealt.frame.width,height: 80))
            girisyapbtn = UIButton(frame: CGRect(x:0,y:180,width:homealt.frame.width,height: 80))
        }else if(device == .iPhone7 || device == .iPhone6 || device == .iPhone6s || device == .iPhone8){
            
        }else if(device == .iPhoneSE || device == .iPhone5s || device == .iPhone5 || device == .iPhone5c){
            
        }else if(device == .iPhoneXr || device == .iPhoneXsMax){
            
        }else{
            
        }
        
        homeust.layer.zPosition = 999
        view.addSubview(homeust)
        
        homelogo.text = "ortaklist"
        homelogo.textColor = UIColor("#cccccc")
        homelogo.textAlignment = .center
        homelogo.font = UIFont(name: "Nunito-Bold", size: 38.0)
        homeust.addSubview(homelogo)
        
        homelogoalt.text = "İş Planlaması"
        homelogoalt.textColor = UIColor("#cccccc")
        homelogoalt.textAlignment = .center
        homelogoalt.font = UIFont(name: "Ubuntu-Medium", size: 16.0)
        homeust.addSubview(homelogoalt)
        
        homealt.layer.zPosition = 999
        homealt.backgroundColor = UIColor.clear
        view.addSubview(homealt)
        
        kayitolbtn.backgroundColor = UIColor("#555555")
        kayitolbtn.clipsToBounds = true
        kayitolbtn.layer.cornerRadius = 10
        kayitolbtn.setTitleColor(UIColor("#CCCCCC"), for: .normal)
        kayitolbtn.setTitle("Kayıt Ol", for: .normal)
        kayitolbtn.titleLabel?.font = UIFont(name: "Ubuntu-Bold", size: 20.0)
        kayitolbtn.addTarget(self, action: #selector(kayitolyonlendir), for: .touchUpInside)
        homealt.addSubview(kayitolbtn)
        
        homealtyazi.text = "Daha önce kayıt oldun mu?"
        homealtyazi.textColor = UIColor("#cccccc")
        homealtyazi.textAlignment = .center
        homealtyazi.font = UIFont(name: "Ubuntu-Regular", size: 16.0)
        homealt.addSubview(homealtyazi)
        
        girisyapbtn.backgroundColor = UIColor.clear
        girisyapbtn.setTitleColor(UIColor("#CCCCCC"), for: .normal)
        girisyapbtn.setTitle("Giriş Yap", for: .normal)
        girisyapbtn.titleLabel?.font = UIFont(name: "Ubuntu-Bold", size: 20.0)
        girisyapbtn.addTarget(self, action: #selector(girisyapyonlendir), for: .touchUpInside)
        homealt.addSubview(girisyapbtn)
        
    }
    
    @objc func kayitolyonlendir(sender:UIButton!){
        let sayfagecis = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "kayitolVC") as! KayitOlController
        self.present(sayfagecis, animated: false, completion: nil)
    }
    
    @objc func girisyapyonlendir(sender:UIButton!){
        let sayfagecis = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "girisyapVC") as! GirisYapController
        self.present(sayfagecis, animated: false, completion: nil)
    }
    
}
