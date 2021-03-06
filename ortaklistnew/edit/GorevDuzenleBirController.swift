import UIKit
import DeviceKit
import SCLAlertView
import BRYXBanner
import UIColor_Hex_Swift
import Alamofire
import SwiftyJSON
import JGProgressHUD
import BLTNBoard
import UITextView_Placeholder
import M13Checkbox

class GorevDuzenleBirController: UIViewController, UITextViewDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let device = Device()
    
    let uye_data = UserDefaults.standard
    
    let serviceurl = "http://ortaklist.com/webservices/android/service_app_22042017/"
    
    let hud = JGProgressHUD(style: .extraLight)
    
    var uyebilgisijson = JSON()
    var gorevdetayjson = JSON()
    
    var secilenlisteid = String()
    var secilenlistebaslik = String()
    var secilengorevid = String()
    
    var aktif_sira = 1
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gorevduzenlesetup()
        
    }
    
    var ustbar = UIView()
    var ustbaric = UIView()
    var ustbaricgenel = UIView()
    var ustbarcizgi = UIView()
    
    var geribtn = UIButton()
    var ustyazi = UILabel()
    var bildirimbtn = UIButton(type: .custom)
    
    var gorevduzenleview = UIView()
    var gorevaciklamatext = UITextView()
    
    var gerigitbtn = UIButton()
    var ilerigitbtn = UIButton()
    
    func gorevduzenlesetup(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        view.backgroundColor = UIColor("#222222")
        
        if(device == .iPhone6sPlus || device == .iPhone7Plus || device == .iPhone6Plus || device == .iPhone8Plus){
            
        }else if(device == .iPhoneX || device == .iPhoneXs){
            ustbar = UIView(frame: CGRect(x:0,y:0,width:screenWidth,height: 115))
            ustbaric = UIView(frame: CGRect(x:0,y:ustbar.frame.height-70,width:ustbar.frame.width,height: 70))
            ustbaricgenel = UIView(frame: CGRect(x:25,y:10,width:ustbaric.frame.width-50,height: ustbaric.frame.height-20))
            ustbarcizgi = UIView(frame: CGRect(x:0,y:ustbar.frame.height-1,width:ustbar.frame.width,height: 1))
            
            geribtn = UIButton(frame: CGRect(x:-10,y:0,width:ustbaricgenel.frame.height,height:ustbaricgenel.frame.height))
            ustyazi = UILabel(frame: CGRect(x:geribtn.frame.width,y:0,width:ustbaricgenel.frame.width - geribtn.frame.width*2,height:ustbaricgenel.frame.height))
            bildirimbtn = UIButton(frame: CGRect(x:ustbaricgenel.frame.width-30,y:10,width:30,height: 30))
            
            gorevduzenleview = UIView(frame: CGRect(x:0,y:ustbar.frame.height,width: screenWidth,height:screenHeight-ustbar.frame.height))
            gorevaciklamatext = UITextView(frame: CGRect(x:15,y:0,width: gorevduzenleview.frame.width-30,height:gorevduzenleview.frame.height))
            
            gerigitbtn = UIButton(frame: CGRect(x:25,y:screenHeight - 110,width:60,height:60))
            ilerigitbtn = UIButton(frame: CGRect(x:screenWidth - 85,y:screenHeight - 110,width:60,height:60))
        }else if(device == .iPhone7 || device == .iPhone6 || device == .iPhone6s || device == .iPhone8){
            
        }else if(device == .iPhoneSE || device == .iPhone5s || device == .iPhone5 || device == .iPhone5c){
            
        }else if(device == .iPhoneXr || device == .iPhoneXsMax){
            
        }else{
            
        }
        
        ustbar.backgroundColor = UIColor("#222222")
        ustbar.layer.zPosition = 9999
        view.addSubview(ustbar)
        
        ustbaric.backgroundColor = UIColor.clear
        ustbar.addSubview(ustbaric)
        
        ustbaricgenel.backgroundColor = UIColor.clear
        ustbaric.addSubview(ustbaricgenel)
        
        ustbarcizgi.backgroundColor = UIColor("#303030")
        //ustbarcizgi.backgroundColor = UIColor.clear
        ustbar.addSubview(ustbarcizgi)
        
        geribtn.backgroundColor = UIColor.clear
        geribtn.setImage(UIImage(named: "geribeyaz.png")?.withRenderingMode(.alwaysTemplate), for: .normal)
        geribtn.addTarget(self, action: #selector(gerigitfunc), for: .touchUpInside)
        geribtn.tintColor = UIColor("#cccccc")
        ustbaricgenel.addSubview(geribtn)
        
        ustyazi.text = "G??revi D??zenle"
        ustyazi.textColor = UIColor("#cccccc")
        ustyazi.textAlignment = .center
        ustyazi.backgroundColor = UIColor.clear
        ustyazi.font = UIFont(name: "Ubuntu-Bold", size: 20.0)
        ustbaricgenel.addSubview(ustyazi)
        
        bildirimbtn.backgroundColor = UIColor.clear
        bildirimbtn.setImage(UIImage(named: "bildirimbeyaz.png")?.withRenderingMode(.alwaysTemplate), for: .normal)
        bildirimbtn.imageView?.contentMode = .scaleAspectFit
        bildirimbtn.tintColor = UIColor("#cccccc")
        bildirimbtn.addTarget(self, action: #selector(bildirimleregitfunc), for: .touchUpInside)
        ustbaricgenel.addSubview(bildirimbtn)
        
        //
        
        gorevduzenleview.backgroundColor = UIColor.clear
        gorevduzenleview.layer.zPosition = 9999
        view.addSubview(gorevduzenleview)
        view.bringSubviewToFront(gorevduzenleview)
        
        gorevaciklamatext.textColor = UIColor("#ccc")
        gorevaciklamatext.backgroundColor = UIColor("#222222")
        gorevaciklamatext.delegate = self
        gorevaciklamatext.keyboardType = .default
        gorevaciklamatext.keyboardAppearance = .dark
        gorevaciklamatext.font = UIFont(name: "Ubuntu-Medium", size: 20)
        gorevaciklamatext.showsVerticalScrollIndicator = false
        gorevaciklamatext.showsHorizontalScrollIndicator = false
        gorevduzenleview.addSubview(gorevaciklamatext)
        
        //
        
        gerigitbtn.backgroundColor = UIColor("#0984e3")
        gerigitbtn.clipsToBounds = true
        gerigitbtn.layer.cornerRadius = gerigitbtn.frame.width / 2
        gerigitbtn.setImage(UIImage(named: "gerigit"), for: .normal)
        gerigitbtn.addTarget(self, action: #selector(gerigitbtnfunc), for: .touchUpInside)
        gerigitbtn.imageView?.contentMode = .scaleAspectFit
        gerigitbtn.layer.zPosition = 9999
        gerigitbtn.isHidden = true
        view.addSubview(gerigitbtn)
        view.bringSubviewToFront(gerigitbtn)
        
        ilerigitbtn.backgroundColor = UIColor("#0984e3")
        ilerigitbtn.clipsToBounds = true
        ilerigitbtn.layer.cornerRadius = ilerigitbtn.frame.width / 2
        ilerigitbtn.setImage(UIImage(named: "ilerigit"), for: .normal)
        ilerigitbtn.addTarget(self, action: #selector(ilerigitbtnfunc), for: .touchUpInside)
        ilerigitbtn.imageView?.contentMode = .scaleAspectFit
        ilerigitbtn.layer.zPosition = 9999
        view.addSubview(ilerigitbtn)
        view.bringSubviewToFront(ilerigitbtn)
        
        //
        
        hud.textLabel.text = "Y??kleniyor"
        hud.layer.zPosition = 9999
        
        uyebilgisicek()
        gorevdetaycek()
        
    }
    
    func gorevdetaycek(){
        let parameters: Parameters = [
            "gorevid": "\(secilengorevid)"
        ]
        Alamofire.request(serviceurl + "gorev_detay.php", method: .post, parameters: parameters).responseJSON { response in
            if let value = response.result.value {
                self.gorevdetayjson = JSON(value)
                print("gorevdetayjson  qnq: \(self.gorevdetayjson)")
                
                let detay = "\(self.gorevdetayjson["detay"].stringValue)"
                
                if(detay.count >= 1){
                    self.gorevaciklamatext.text = "\(detay)"
                }else{
                    let twplaceholder = [
                        NSAttributedString.Key.foregroundColor: UIColor("#ccc"),
                        NSAttributedString.Key.font : UIFont(name: "Ubuntu-Medium", size: 20)!
                    ]
                    
                    self.gorevaciklamatext.attributedPlaceholder = NSAttributedString(string: "Bu alan?? d??zenleyebilirsiniz,\n\nBa??lamak i??in dokunabilirsiniz.", attributes:twplaceholder)
                }
                
            }
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
                let screenHeight = screenSize.height
                
                self.gorevaciklamatext.frame = CGRect(x:15,y:0,width: self.gorevduzenleview.frame.width-30,height:255)
                
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                let screenSize = UIScreen.main.bounds
                let screenWidth = screenSize.width
                let screenHeight = screenSize.height
                
                self.gorevaciklamatext.frame = CGRect(x:15,y:0,width: self.gorevduzenleview.frame.width-30,height:self.gorevduzenleview.frame.height)
                
                self.view.layoutIfNeeded()
            })
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    var gorevdata_aciklama = String()
    var gorevdata_baslangic = String()
    var gorevdata_bitis = String()
    
    //baslangicpage
    var baslangicpage = DatePickerBLTNItem()
    
    lazy var baslangicbulletinManager: BLTNItemManager = {
        
        baslangicpage = DatePickerBLTNItem(title: "Ba??lang???? Tarihi")
        
        baslangicpage.descriptionText = ""
        baslangicpage.actionButtonTitle = "Devam Et"
        
        baslangicpage.actionHandler = { (item: BLTNActionItem) in
            self.baslangicbulletinyes()
        }
        
        baslangicpage.isDismissable = false
        
        let bastarih = "\(self.gorevdetayjson["bastarih"].stringValue)"
        
        baslangicpage.datePicker.setDate(from: "\(bastarih)", format: "dd/MM/yyyy HH:mm")
        
        let bullpage: BLTNItem = baslangicpage
        return BLTNItemManager(rootItem: bullpage)
        
    }()
    
    func baslangicbulletinac(){
        
        baslangicbulletinManager.backgroundColor = UIColor("#ccc")
        baslangicbulletinManager.backgroundViewStyle = .blurredLight
        baslangicbulletinManager.showBulletin(above: self)
        
    }
    
    func baslangicbulletinyes(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        gorevdata_baslangic = "\(dateFormatter.string(from: baslangicpage.datePicker.date))"
        print("Se??ilen G??rev Ba??lang???? Tarihi:\(gorevdata_baslangic)")
        
        baslangicbulletinManager.dismissBulletin()
        bitisbulletinac()
        
    }
    //baslangicpage
    
    //bitispage
    var bitispage = DatePickerBLTNItem()
    
    lazy var bitisbulletinManager: BLTNItemManager = {
        
        bitispage = DatePickerBLTNItem(title: "Biti?? Tarihi")
        
        bitispage.descriptionText = ""
        bitispage.actionButtonTitle = "Devam Et"
        
        bitispage.actionHandler = { (item: BLTNActionItem) in
            self.bitisbulletinyes()
        }
        
        bitispage.isDismissable = false
        
        let sontarih = "\(self.gorevdetayjson["sontarih"].stringValue)"
        
        bitispage.datePicker.setDate(from: "\(sontarih)", format: "dd/MM/yyyy HH:mm")
        
        let bullpage: BLTNItem = bitispage
        return BLTNItemManager(rootItem: bullpage)
        
    }()
    
    func bitisbulletinac(){
        
        bitisbulletinManager.backgroundColor = UIColor("#ccc")
        bitisbulletinManager.backgroundViewStyle = .blurredLight
        bitisbulletinManager.showBulletin(above: self)
        
    }
    
    func bitisbulletinyes(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        gorevdata_bitis = "\(dateFormatter.string(from: bitispage.datePicker.date))"
        print("Se??ilen G??rev Biti?? Tarihi:\(gorevdata_bitis)")
        
        bitisbulletinManager.dismissBulletin()
        
        step2ac()
    }
    //bitispage
    
    func step2ac(){
        let sayfagecis = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "gorevDuzenleIkiVC") as! GorevDuzenleIkiController
        sayfagecis.secilenlisteid = secilenlisteid
        sayfagecis.secilenlistebaslik = secilenlistebaslik
        
        sayfagecis.gorevdataaciklama = gorevdata_aciklama
        sayfagecis.gorevdatabaslangic = gorevdata_baslangic
        sayfagecis.gorevdatabitis = gorevdata_bitis
        sayfagecis.secilengorevid = secilengorevid
        self.present(sayfagecis, animated: false, completion: nil)
    }
    
    @objc func ilerigitbtnfunc(sender:UIButton!){
        
        gorevdata_aciklama = "\(gorevaciklamatext.text!)"
        
        if(gorevdata_aciklama == ""){
            let basarisizbildirim = Banner(title: "Hata!", subtitle: "L??tfen bo?? b??rakmay??n??z.", image: UIImage(named: "bildirimbeyaz.png"), backgroundColor: UIColor("#ff3838"))
            basarisizbildirim.dismissesOnTap = true
            basarisizbildirim.show(duration: 3.0)
        }else{
           baslangicbulletinac()
        }
        
    }
    
    @objc func gerigitbtnfunc(sender:UIButton!){
        //sayfaicigerigit
    }
    
    func uyebilgisicek(){
        
        let uyeid = self.uye_data.string(forKey: "uyeid")
        let parameters: Parameters = [
            "uyeid": "\(uyeid!)"
        ]
        Alamofire.request(serviceurl + "uye_bilgi_cek.php", method: .post, parameters: parameters).responseJSON { response in
            if let value = response.result.value {
                self.uyebilgisijson = JSON(value)
                print("uyebilgisijson qnq: \(self.uyebilgisijson)")
                print("uyeid qnq: \(uyeid!)")
                
                let sonuc = self.uyebilgisijson["sonuc"].stringValue
                
                if(sonuc == "100"){
                    
                    //let isim = self.uyebilgisijson["isim"].stringValue
                    
                    DispatchQueue.main.async {
                        //self.pp.setTitle("\(isim.prefix(1))", for: .normal)
                    }
                    
                }else{
                    print("uye bilgisi cekilemedi.")
                }
                
            }
        }
        
    }
    
    @objc func gerigitfunc(sender:UIButton!){
        let sayfagecis = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "gorevlerVC") as! GorevlerController
        sayfagecis.secilenlisteid = secilenlisteid
        sayfagecis.secilenlistebaslik = secilenlistebaslik
        self.present(sayfagecis, animated: false, completion: nil)
    }
    
    @objc func bildirimleregitfunc(sender:UIButton!){
        print("bildirimlere git")
    }
    
}

extension UIDatePicker {
    func setDate(from string: String, format: String, animated: Bool = true) {
        
        let formater = DateFormatter()
        
        formater.dateFormat = format
        
        let date = formater.date(from: string) ?? Date()
        
        setDate(date, animated: animated)
    }
}

