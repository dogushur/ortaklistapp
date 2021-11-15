import UIKit
import DeviceKit
import SCLAlertView
import BRYXBanner
import UIColor_Hex_Swift
import Alamofire
import SwiftyJSON
import JGProgressHUD

class GirisYapController: UIViewController,UITextFieldDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let device = Device()
    
    let serviceurl = "http://ortaklist.com/webservices/android/service_app_22042017/"
    
    let hud = JGProgressHUD(style: .extraLight)
    
    let uye_data = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        girisyapsetup()
        
    }
    
    var geriview = UIView()
    var geribtn = UIButton(type: .custom)
    
    var girisyapbaslik = UILabel()
    
    var formview = UIView()
    var eposta_veya_kullaniciadi = UITextField()
    var sifre = UITextField()
    var girisyapbtn = UIButton()
    
    func girisyapsetup(){
        
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
            girisyapbaslik = UILabel(frame: CGRect(x:25,y:150,width:screenWidth-50,height:70))
            formview = UIView(frame: CGRect(x:25,y:230,width:screenWidth-50,height: 290))
            eposta_veya_kullaniciadi = UITextField(frame: CGRect(x:0,y:0,width: formview.frame.width,height: 70))
            sifre = UITextField(frame: CGRect(x:0,y:70,width: formview.frame.width,height: 70))
            girisyapbtn = UIButton(frame: CGRect(x:0,y:210,width:formview.frame.width,height: 80))
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
        
        girisyapbaslik.text = "Giriş Yap"
        girisyapbaslik.textColor = UIColor("#cccccc")
        girisyapbaslik.textAlignment = .left
        girisyapbaslik.font = UIFont(name: "Ubuntu-Medium", size: 30.0)
        girisyapbaslik.backgroundColor = UIColor.clear
        view.addSubview(girisyapbaslik)
        
        formview.layer.zPosition = 999
        formview.backgroundColor = UIColor.clear
        view.addSubview(formview)
        
        let inputplaceholder = [
            NSAttributedString.Key.foregroundColor: UIColor("#cccccc"),
            NSAttributedString.Key.font : UIFont(name: "Ubuntu-Regular", size: 17)!
        ]
        
        eposta_veya_kullaniciadi.attributedPlaceholder = NSAttributedString(string: "E-Posta veya Kullanıcı Adı", attributes:inputplaceholder)
        eposta_veya_kullaniciadi.keyboardType = .default
        eposta_veya_kullaniciadi.keyboardAppearance = .dark
        eposta_veya_kullaniciadi.textColor = UIColor("#cccccc")
        eposta_veya_kullaniciadi.font = UIFont(name: "Ubuntu-Medium", size: 17)!
        eposta_veya_kullaniciadi.delegate=self
        formview.addSubview(eposta_veya_kullaniciadi)
        
        let input1bottom = UIView(frame: CGRect(x:0,y:eposta_veya_kullaniciadi.frame.height-2,width:eposta_veya_kullaniciadi.frame.width,height: 2))
        input1bottom.backgroundColor = UIColor("#cccccc")
        eposta_veya_kullaniciadi.addSubview(input1bottom)
        
        //
        
        sifre.attributedPlaceholder = NSAttributedString(string: "Şifre", attributes:inputplaceholder)
        sifre.keyboardType = .default
        sifre.keyboardAppearance = .dark
        sifre.textColor = UIColor("#cccccc")
        sifre.font = UIFont(name: "Ubuntu-Medium", size: 17)!
        sifre.delegate=self
        sifre.isSecureTextEntry = true
        formview.addSubview(sifre)
        
        let input2bottom = UIView(frame: CGRect(x:0,y:sifre.frame.height-2,width:sifre.frame.width,height: 2))
        input2bottom.backgroundColor = UIColor("#cccccc")
        sifre.addSubview(input2bottom)
        
        //
        
        girisyapbtn.backgroundColor = UIColor("#555555")
        girisyapbtn.clipsToBounds = true
        girisyapbtn.layer.cornerRadius = 10
        girisyapbtn.setTitleColor(UIColor("#CCCCCC"), for: .normal)
        girisyapbtn.setTitle("Giriş Yap", for: .normal)
        girisyapbtn.titleLabel?.font = UIFont(name: "Ubuntu-Bold", size: 20.0)
        girisyapbtn.addTarget(self, action: #selector(girisyapfunc), for: .touchUpInside)
        formview.addSubview(girisyapbtn)
        
        hud.textLabel.text = "Yükleniyor"
        hud.layer.zPosition = 9999
        
    }
    
    @objc func girisyapfunc(sender:UIButton!){
        girisislemiyap()
    }
    
    func girisislemiyap(){
        self.hud.show(in: self.view)
        
        let veposta_veya_kullaniciadi = "\(eposta_veya_kullaniciadi.text!)"
        let vsifre = "\(sifre.text!)"
        
        if(veposta_veya_kullaniciadi != "" && vsifre != ""){
        
            let parameters: Parameters = [
                "eposta": "\(veposta_veya_kullaniciadi)",
                "sifre": "\(vsifre)"
            ]
            Alamofire.request(serviceurl + "giris_yap.php", method: .post, parameters: parameters).responseJSON { response in
                if let value = response.result.value {
                    let uyegirisyapjson = JSON(value)
                    print("uyegirisyapjson qnq: \(uyegirisyapjson)")
                 
                    let sonuc = uyegirisyapjson["sonuc"].stringValue
                    
                    if(sonuc == "100"){
                        
                        let basarilibildirim = Banner(title: "Tebrikler!", subtitle: "Başarıyla kayıt oldunuz.", image: UIImage(named: "bildirimbeyaz.png"), backgroundColor: UIColor("#27ae60"))
                        basarilibildirim.dismissesOnTap = true
                        basarilibildirim.show(duration: 3.0)
                        
                        self.uye_data.set(true, forKey: "uye_girisi")
                        
                        let uyeid = uyegirisyapjson["uyeid"].stringValue
                        self.uye_data.set("\(uyeid)", forKey: "uyeid")
                        
                        let sayfagecis = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "baslangicVC") as! BaslangicController
                        self.present(sayfagecis, animated: false, completion: nil)
                        
                    }else{
                        
                        let basarisizbildirim = Banner(title: "Başarısız!", subtitle: "Giriş yapılırken hata oluştu.", image: UIImage(named: "bildirimbeyaz.png"), backgroundColor: UIColor("#ff3838"))
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
                self.girisyapbaslik.frame = CGRect(x:25,y:70,width:screenWidth-50,height:70)
                self.formview.frame = CGRect(x:25,y:150,width:screenWidth-50,height: 290)
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
                self.girisyapbaslik.frame = CGRect(x:25,y:150,width:screenWidth-50,height:70)
                self.formview.frame = CGRect(x:25,y:230,width:screenWidth-50,height: 290)
                self.view.layoutIfNeeded()
            })
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        eposta_veya_kullaniciadi.resignFirstResponder()
        sifre.resignFirstResponder()
        return (true)
    }
    
    @objc func gerigitfunc(sender:UIButton!){
        let sayfagecis = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeVC") as! HomeController
        self.present(sayfagecis, animated: false, completion: nil)
    }
    
}
