import UIKit
import DeviceKit
import SCLAlertView
import BRYXBanner
import UIColor_Hex_Swift
import Alamofire
import SwiftyJSON
import JGProgressHUD

class KayitOlController: UIViewController,UITextFieldDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let device = Device()
    
    let uye_data = UserDefaults.standard
    
    let serviceurl = "http://ortaklist.com/webservices/android/service_app_22042017/"
    
    let hud = JGProgressHUD(style: .extraLight)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        kayitolsetup()
        
    }
    
    var geriview = UIView()
    var geribtn = UIButton(type: .custom)
    
    var kayitbaslik = UILabel()
    
    var formview = UIView()
    var isimsoyisim = UITextField()
    var eposta = UITextField()
    var kullaniciadi = UITextField()
    var sifre = UITextField()
    var kayitolbtn = UIButton()
    
    func kayitolsetup(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        //let screenHeight = screenSize.height
        
        view.backgroundColor = UIColor("#222222")
        
        if(device == .iPhone6sPlus || device == .iPhone7Plus || device == .iPhone6Plus || device == .iPhone8Plus){
            
        }else if(device == .iPhoneX || device == .iPhoneXs){
            geriview = UIView(frame: CGRect(x:10,y:100,width:screenWidth-20,height: 50))
            geribtn = UIButton(frame: CGRect(x:0,y:0,width: 70,height:50))
            kayitbaslik = UILabel(frame: CGRect(x:25,y:150,width:screenWidth-50,height:70))
            formview = UIView(frame: CGRect(x:25,y:230,width:screenWidth-50,height: 430))
            isimsoyisim = UITextField(frame: CGRect(x:0,y:0,width: formview.frame.width,height: 70))
            eposta = UITextField(frame: CGRect(x:0,y:70,width: formview.frame.width,height: 70))
            kullaniciadi = UITextField(frame: CGRect(x:0,y:140,width: formview.frame.width,height: 70))
            sifre = UITextField(frame: CGRect(x:0,y:210,width: formview.frame.width,height: 70))
            kayitolbtn = UIButton(frame: CGRect(x:0,y:350,width:formview.frame.width,height: 80))
        }else if(device == .iPhone7 || device == .iPhone6 || device == .iPhone6s || device == .iPhone8){
            
        }else if(device == .iPhoneSE || device == .iPhone5s || device == .iPhone5 || device == .iPhone5c){
            
        }else if(device == .iPhoneXr || device == .iPhoneXsMax){
            
        }else{
            
        }
        
        geriview.backgroundColor = UIColor.clear
        view.addSubview(geriview)
        
        geribtn.setImage(UIImage(named: "geribeyaz.png")?.withRenderingMode(.alwaysTemplate), for: .normal)
        geribtn.imageView?.contentMode = .scaleAspectFit
        geribtn.tintColor = UIColor("#cccccc")
        geribtn.addTarget(self, action: #selector(gerigitfunc), for: .touchUpInside)
        geriview.addSubview(geribtn)
        
        kayitbaslik.text = "Kayıt Ol"
        kayitbaslik.textColor = UIColor("#cccccc")
        kayitbaslik.textAlignment = .left
        kayitbaslik.font = UIFont(name: "Ubuntu-Medium", size: 30.0)
        kayitbaslik.backgroundColor = UIColor.clear
        view.addSubview(kayitbaslik)
        
        formview.layer.zPosition = 999
        formview.backgroundColor = UIColor.clear
        view.addSubview(formview)
        
        let inputplaceholder = [
            NSAttributedString.Key.foregroundColor: UIColor("#cccccc"),
            NSAttributedString.Key.font : UIFont(name: "Ubuntu-Regular", size: 17)!
        ]
        
        isimsoyisim.attributedPlaceholder = NSAttributedString(string: "İsim Soyisim", attributes:inputplaceholder)
        isimsoyisim.keyboardType = .default
        isimsoyisim.keyboardAppearance = .dark
        isimsoyisim.textColor = UIColor("#cccccc")
        isimsoyisim.font = UIFont(name: "Ubuntu-Medium", size: 17)!
        isimsoyisim.delegate=self
        formview.addSubview(isimsoyisim)
        
        let input1bottom = UIView(frame: CGRect(x:0,y:isimsoyisim.frame.height-2,width:isimsoyisim.frame.width,height: 2))
        input1bottom.backgroundColor = UIColor("#cccccc")
        isimsoyisim.addSubview(input1bottom)
        
        //
        
        eposta.attributedPlaceholder = NSAttributedString(string: "E-Posta Adresi", attributes:inputplaceholder)
        eposta.keyboardType = .default
        eposta.keyboardAppearance = .dark
        eposta.textColor = UIColor("#cccccc")
        eposta.font = UIFont(name: "Ubuntu-Medium", size: 17)!
        eposta.delegate=self
        formview.addSubview(eposta)
        
        let input2bottom = UIView(frame: CGRect(x:0,y:eposta.frame.height-2,width:eposta.frame.width,height: 2))
        input2bottom.backgroundColor = UIColor("#cccccc")
        eposta.addSubview(input2bottom)
        
        //
        
        kullaniciadi.attributedPlaceholder = NSAttributedString(string: "Kullanıcı Adı", attributes:inputplaceholder)
        kullaniciadi.keyboardType = .default
        kullaniciadi.keyboardAppearance = .dark
        kullaniciadi.textColor = UIColor("#cccccc")
        kullaniciadi.font = UIFont(name: "Ubuntu-Medium", size: 17)!
        kullaniciadi.delegate=self
        formview.addSubview(kullaniciadi)
        
        let input3bottom = UIView(frame: CGRect(x:0,y:kullaniciadi.frame.height-2,width:kullaniciadi.frame.width,height: 2))
        input3bottom.backgroundColor = UIColor("#cccccc")
        kullaniciadi.addSubview(input3bottom)
        
        //
        
        sifre.attributedPlaceholder = NSAttributedString(string: "Şifre", attributes:inputplaceholder)
        sifre.keyboardType = .default
        sifre.keyboardAppearance = .dark
        sifre.textColor = UIColor("#cccccc")
        sifre.font = UIFont(name: "Ubuntu-Medium", size: 17)!
        sifre.delegate=self
        sifre.isSecureTextEntry = true
        formview.addSubview(sifre)
        
        let input4bottom = UIView(frame: CGRect(x:0,y:sifre.frame.height-2,width:sifre.frame.width,height: 2))
        input4bottom.backgroundColor = UIColor("#cccccc")
        sifre.addSubview(input4bottom)
        
        //
        
        kayitolbtn.backgroundColor = UIColor("#555555")
        kayitolbtn.clipsToBounds = true
        kayitolbtn.layer.cornerRadius = 10
        kayitolbtn.setTitleColor(UIColor("#CCCCCC"), for: .normal)
        kayitolbtn.setTitle("Kayıt Ol", for: .normal)
        kayitolbtn.titleLabel?.font = UIFont(name: "Ubuntu-Bold", size: 20.0)
        kayitolbtn.addTarget(self, action: #selector(kayitolfunc), for: .touchUpInside)
        formview.addSubview(kayitolbtn)
        
        hud.textLabel.text = "Yükleniyor"
        hud.layer.zPosition = 9999
        
    }
    
    @objc func kayitolfunc(sender:UIButton!){
        uyelikolustur()
    }
    
    func uyelikolustur(){
        self.hud.show(in: self.view)
        
        let visimsoyisim = "\(isimsoyisim.text!)"
        let veposta = "\(eposta.text!)"
        let vkullaniciadi = "\(kullaniciadi.text!)"
        let vsifre = "\(sifre.text!)"
        
        if(visimsoyisim != "" && veposta != "" && vkullaniciadi != "" && vsifre != ""){
            
            let parameters: Parameters = [
                "isim": "\(visimsoyisim)",
                "eposta": "\(veposta)",
                "kullanici_adi": "\(vkullaniciadi)",
                "sifre": "\(vsifre)"
            ]
            Alamofire.request(serviceurl + "kayit_ol.php", method: .post, parameters: parameters).responseJSON { response in
                if let value = response.result.value {
                    let uyelikolusturjson = JSON(value)
                    print("uyelikolusturjson qnq: \(uyelikolusturjson)")
                    
                    let sonuc = uyelikolusturjson["sonuc"].stringValue
                    
                    if(sonuc == "s100"){
                        
                        let basarilibildirim = Banner(title: "Tebrikler!", subtitle: "Başarıyla kayıt oldunuz.", image: UIImage(named: "bildirimbeyaz.png"), backgroundColor: UIColor("#27ae60"))
                        basarilibildirim.dismissesOnTap = true
                        basarilibildirim.show(duration: 3.0)
                        
                        self.uye_data.set(true, forKey: "uye_girisi")
                        
                        let uyeid = uyelikolusturjson["uyeid"].stringValue
                        self.uye_data.set("\(uyeid)", forKey: "uyeid")
                        
                        let sayfagecis = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "baslangicVC") as! BaslangicController
                        self.present(sayfagecis, animated: false, completion: nil)
                        
                    }else{
                        let basarisizbildirim = Banner(title: "Başarısız!", subtitle: "Üye olurken hata oluştu.", image: UIImage(named: "bildirimbeyaz.png"), backgroundColor: UIColor("#ff3838"))
                        basarisizbildirim.dismissesOnTap = true
                        basarisizbildirim.show(duration: 3.0)
                        
                        self.uye_data.set(false, forKey: "uye_girisi")
                    }
                    
                }
            }
            
        }else{
            let basarisizbildirim = Banner(title: "Başarısız!", subtitle: "Lütfen boş alan bırakmayın.", image: UIImage(named: "bildirimbeyaz.png"), backgroundColor: UIColor("#ff3838"))
            basarisizbildirim.dismissesOnTap = true
            basarisizbildirim.show(duration: 3.0)
        }
        
        DispatchQueue.main.async {
            self.hud.dismiss(afterDelay: 1)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                let screenSize = UIScreen.main.bounds
                let screenWidth = screenSize.width
                
                //self.view.frame.origin.y -= keyboardSize.height
                self.geriview.isHidden = true
                self.kayitbaslik.frame = CGRect(x:25,y:70,width:screenWidth-50,height:70)
                self.formview.frame = CGRect(x:25,y:150,width:screenWidth-50,height: 430)
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                let screenSize = UIScreen.main.bounds
                let screenWidth = screenSize.width
                
                //self.view.frame.origin.y += keyboardSize.height
                self.geriview.isHidden = false
                self.kayitbaslik.frame = CGRect(x:25,y:150,width:screenWidth-50,height:70)
                self.formview.frame = CGRect(x:25,y:230,width:screenWidth-50,height: 430)
                self.view.layoutIfNeeded()
            })
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        isimsoyisim.resignFirstResponder()
        eposta.resignFirstResponder()
        kullaniciadi.resignFirstResponder()
        sifre.resignFirstResponder()
        return (true)
    }
    
    @objc func gerigitfunc(sender:UIButton!){
        let sayfagecis = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeVC") as! HomeController
        self.present(sayfagecis, animated: false, completion: nil)
    }
    
}
