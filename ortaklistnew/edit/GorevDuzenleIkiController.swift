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

class GorevEkleIkiController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let device = Device()
    
    let uye_data = UserDefaults.standard
    
    let serviceurl = "http://ortaklist.com/webservices/android/service_app_22042017/"
    
    let hud = JGProgressHUD(style: .extraLight)
    
    var uyebilgisijson = JSON()
    var listekisilerjson = JSON()
    
    var secilenlisteid = String()
    var secilenlistebaslik = String()
    
    var gorevdataaciklama = String()
    var gorevdatabaslangic = String()
    var gorevdatabitis = String()
    
    var kisilercheckboxs = [M13Checkbox]()
    var gorevesecilenkisiler = [String]()
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goreveklesetup()
        
    }
    
    var ustbar = UIView()
    var ustbaric = UIView()
    var ustbaricgenel = UIView()
    var ustbarcizgi = UIView()
    
    var geribtn = UIButton()
    var ustyazi = UILabel()
    var bildirimbtn = UIButton(type: .custom)
    
    var gorevekleview = UIView()
    var listekisilertable = UITableView()
    
    var gerigitbtn = UIButton()
    var ilerigitbtn = UIButton()
    
    func goreveklesetup(){
        
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
            
            gorevekleview = UIView(frame: CGRect(x:0,y:ustbar.frame.height,width: screenWidth,height:screenHeight-ustbar.frame.height))
            listekisilertable = UITableView(frame: CGRect(x:0,y:0,width: gorevekleview.frame.width,height:gorevekleview.frame.height))
            
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
        
        ustyazi.text = "Kişi Seç"
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
        
        gorevekleview.backgroundColor = UIColor.clear
        gorevekleview.layer.zPosition = 9999
        view.addSubview(gorevekleview)
        view.bringSubviewToFront(gorevekleview)
        
        listekisilertable.delegate = self
        listekisilertable.dataSource = self
        listekisilertable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        listekisilertable.layer.zPosition = 1
        listekisilertable.backgroundColor = UIColor.clear
        listekisilertable.separatorStyle = UITableViewCell.SeparatorStyle.none
        listekisilertable.register(GorevEkleUyelerCell.classForCoder(), forCellReuseIdentifier: "GorevEkleUyelerCell")
        listekisilertable.showsVerticalScrollIndicator = false
        listekisilertable.showsHorizontalScrollIndicator = false
        listekisilertable.estimatedRowHeight = 60
        gorevekleview.addSubview(listekisilertable)
        
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
        
        hud.textLabel.text = "Yükleniyor"
        hud.layer.zPosition = 9999
        
        uyebilgisicek()
        listekisicek()
        
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
                
                //
                
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
                
                //
                
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func ilerigitbtnfunc(sender:UIButton!){
        
        gorevolusturfunc()
        
    }
    
    @objc func gerigitbtnfunc(sender:UIButton!){
        //sayfaicigerigit
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let listekisiler = self.listekisilerjson["list_uyeleri"].arrayValue
        return listekisiler.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GorevEkleUyelerCell", for: indexPath) as! GorevEkleUyelerCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        
        let satir = indexPath.row
        
        let isim = "\(self.listekisilerjson["list_uyeleri"][satir]["isim"].stringValue)"
        
        cell.kisilerbaslik.text = "\(isim)"
        
        kisilercheckboxs.append(cell.kisilercheck)
        
        cell.kisilercheck.tag = satir
        cell.kisilercheck.addTarget(self, action: #selector(kisilercheckfunc), for: UIControl.Event.valueChanged)
        
        return cell
        
    }
    
    @objc func kisilercheckfunc(sender:M13Checkbox!){
        
        let satir = sender.tag
        let checkdurum = "\(kisilercheckboxs[satir].checkState)"
        
        let secilenuyeeposta = "\(self.listekisilerjson["list_uyeleri"][satir]["eposta"].stringValue)"
        
        if(checkdurum == "unchecked"){
            gorevesecilenkisiler[satir] = "eposta3"
        }else if(checkdurum == "checked"){
            gorevesecilenkisiler[satir] = secilenuyeeposta
        }
        
        print("Göreve Seçilen Kişiler: \(gorevesecilenkisiler)")
        
    }
    
    func gorevolusturfunc(){
        var newsecilenkisiler = ""
        
        for i in 0..<gorevesecilenkisiler.count{
            let eposta = gorevesecilenkisiler[i]
            if(eposta == "eposta"){
                gorevesecilenkisiler.remove(at: i)
            }else if(eposta != "eposta"){
               newsecilenkisiler = "\(newsecilenkisiler + eposta),"
            }
        }
        
        let uyeid = self.uye_data.string(forKey: "uyeid")
        let parameters: Parameters = [
            "uyeid": "\(uyeid!)",
            "listeid": "\(secilenlisteid)",
            "baslik": "\(gorevdataaciklama)",
            "detay": "\(gorevdataaciklama)",
            "baslangic": "\(gorevdatabaslangic)",
            "sonbulma": "\(gorevdatabitis)",
            "secilenuyeler": "\(newsecilenkisiler)"
        ]
        Alamofire.request(serviceurl + "yeni_gorev_ekle.php", method: .post, parameters: parameters).responseJSON { response in
            if let value = response.result.value {
                let gorevolusturjson = JSON(value)
                print("gorevolusturjson qnq: \(gorevolusturjson)")
                
            }
            let basarilibildirim = Banner(title: "Tebrikler!", subtitle: "Başarıyla yeni görev oluşturdunuz.", image: UIImage(named: "bildirimbeyaz.png"), backgroundColor: UIColor("#27ae60"))
            basarilibildirim.dismissesOnTap = true
            basarilibildirim.show(duration: 3.0)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let sayfagecis = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "gorevlerVC") as! GorevlerController
                sayfagecis.secilenlisteid = self.secilenlisteid
                sayfagecis.secilenlistebaslik = self.secilenlistebaslik
                self.present(sayfagecis, animated: false, completion: nil)
            }
            
        }
    }
    
    func listekisicek(){
        let uyeid = self.uye_data.string(forKey: "uyeid")
        let parameters: Parameters = [
            "uyeid": "\(uyeid!)",
            "listeid": "\(secilenlisteid)"
        ]
        Alamofire.request(serviceurl + "liste_detay.php", method: .post, parameters: parameters).responseJSON { response in
            if let value = response.result.value {
                self.listekisilerjson = JSON(value)
                print("listekisilerjson qnq: \(self.listekisilerjson)")
                
                let listekisiler = self.listekisilerjson["list_uyeleri"].arrayValue
                
                for i in 0..<listekisiler.count{
                    self.gorevesecilenkisiler.append("eposta")
                }
                
            }
            DispatchQueue.main.async {
                self.listekisilertable.reloadData()
            }
        }
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


