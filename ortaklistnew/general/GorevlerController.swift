import UIKit
import DeviceKit
import SCLAlertView
import BRYXBanner
import UIColor_Hex_Swift
import Alamofire
import SwiftyJSON
import JGProgressHUD
import BLTNBoard
import M13Checkbox

class GorevlerController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let device = Device()
    
    let uye_data = UserDefaults.standard
    
    let serviceurl = "http://ortaklist.com/webservices/android/service_app_22042017/"
    
    let hud = JGProgressHUD(style: .extraLight)
    
    var uyebilgisijson = JSON()
    var gorevlerjson = JSON()
    
    var secilenlisteid = String()
    var secilenlistebaslik = String()
    
    var gorevcheckboxs = [M13Checkbox]()
    
    var gorevkontrol = Timer()
    var gorevkontrol_isTimerRunning = false
    func rungorevkontrol() {
        gorevkontrol = Timer.scheduledTimer(timeInterval: 4, target: self,   selector: (#selector(GorevlerController.updategorevkontrol)), userInfo: nil, repeats: true)
    }
    @objc func updategorevkontrol() {
        gorevyenile()
    }
    func gorevyenile(){
        let uyeid = self.uye_data.string(forKey: "uyeid")
        let eposta = self.uyebilgisijson["eposta"].stringValue
        
        let parameters: Parameters = [
            "uyeid": "\(uyeid!)",
            "eposta": "\(eposta)",
            "listeid": "\(secilenlisteid)"
        ]
        Alamofire.request(serviceurl + "gorev_listele.php", method: .post, parameters: parameters).responseJSON { response in
            if let value = response.result.value {
                self.gorevlerjson = JSON(value)
                //print("gorevlerjson qnq: \(self.gorevlerjson)")
                
            }
            DispatchQueue.main.async {
                self.gorevlertable.reloadData()
            }
        }
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gorevlersetup()
        
    }
    
    var didSetupConstraints = false
    
    var ustbar = UIView()
    var ustbaric = UIView()
    var ustbaricgenel = UIView()
    var ustbarcizgi = UIView()
    
    var geribtn = UIButton()
    var ustyazi = UILabel()
    var bildirimbtn = UIButton(type: .custom)
    
    var gorevlertable = UITableView()
    
    var plusbuton = UIButton()
    
    func gorevlersetup(){
        
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
            
            plusbuton = UIButton(frame: CGRect(x:screenWidth - 85,y:screenHeight - 110,width:60,height:60))
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
        
        //ustbarcizgi.backgroundColor = UIColor("#303030")
        ustbarcizgi.backgroundColor = UIColor.clear
        ustbar.addSubview(ustbarcizgi)
        
        geribtn.backgroundColor = UIColor.clear
        geribtn.setImage(UIImage(named: "geribeyaz.png")?.withRenderingMode(.alwaysTemplate), for: .normal)
        geribtn.addTarget(self, action: #selector(gerigitfunc), for: .touchUpInside)
        geribtn.tintColor = UIColor("#cccccc")
        ustbaricgenel.addSubview(geribtn)
        
        ustyazi.text = "\(secilenlistebaslik)"
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
        
        gorevlertable.delegate = self
        gorevlertable.dataSource = self
        gorevlertable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        gorevlertable.layer.zPosition = 1
        gorevlertable.backgroundColor = UIColor.clear
        gorevlertable.separatorStyle = UITableViewCell.SeparatorStyle.none
        gorevlertable.register(GorevlerCell.classForCoder(), forCellReuseIdentifier: "GorevlerCell")
        gorevlertable.showsVerticalScrollIndicator = false
        gorevlertable.showsHorizontalScrollIndicator = false
        gorevlertable.estimatedRowHeight = 60
        view.addSubview(gorevlertable)
        
        //
        
        plusbuton.backgroundColor = UIColor("#0984e3")
        plusbuton.clipsToBounds = true
        plusbuton.layer.cornerRadius = plusbuton.frame.width / 2
        plusbuton.setImage(UIImage(named: "plusbuton"), for: .normal)
        plusbuton.addTarget(self, action: #selector(plusbtnfunc), for: .touchUpInside)
        plusbuton.imageView?.contentMode = .scaleAspectFit
        plusbuton.layer.zPosition = 9999
        view.addSubview(plusbuton)
        view.bringSubviewToFront(plusbuton)
        
        //
        
        hud.textLabel.text = "Yükleniyor"
        hud.layer.zPosition = 9999
        
        uyebilgisicek()
        
        gorevlercek()
        
        self.view.setNeedsUpdateConstraints()
        
    }
    
    override func updateViewConstraints() {
        if !didSetupConstraints {
            gorevlertable.left(0).right(0).top(ustbar.frame.height).bottom(0)
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    @objc func plusbtnfunc(sender:UIButton!){
        let sayfagecis = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "gorevEkleBirVC") as! GorevEkleBirController
        sayfagecis.secilenlisteid = secilenlisteid
        sayfagecis.secilenlistebaslik = secilenlistebaslik
        self.present(sayfagecis, animated: false, completion: nil)
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
    
    func gorevlercek(){
        self.hud.show(in: self.view)
        
        let uyeid = self.uye_data.string(forKey: "uyeid")
        let eposta = self.uyebilgisijson["eposta"].stringValue
        
        let parameters: Parameters = [
            "uyeid": "\(uyeid!)",
            "eposta": "\(eposta)",
            "listeid": "\(secilenlisteid)"
        ]
        Alamofire.request(serviceurl + "gorev_listele.php", method: .post, parameters: parameters).responseJSON { response in
            if let value = response.result.value {
                self.gorevlerjson = JSON(value)
                print("gorevlerjson qnq: \(self.gorevlerjson)")
                
            }
            DispatchQueue.main.async {
                self.gorevlertable.reloadData()
                self.hud.dismiss(afterDelay: 1)
                self.rungorevkontrol()
            }
        }
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let gorevler = self.gorevlerjson.arrayValue
        return gorevler.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GorevlerCell", for: indexPath) as! GorevlerCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        
        let satir = indexPath.row
        
        let gorevbaslik = self.gorevlerjson[satir]["baslik"].stringValue
        let gorevdetay = self.gorevlerjson[satir]["detay"].stringValue
        let gorevid = self.gorevlerjson[satir]["gorevid"].stringValue
        let gorevdurum = self.gorevlerjson[satir]["durum"].stringValue
        
        let textatt: NSMutableAttributedString =  NSMutableAttributedString(string: "\(gorevdetay)")
        textatt.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, textatt.length))
        
        let textatt2: NSMutableAttributedString =  NSMutableAttributedString(string: "\(gorevdetay)")
        textatt2.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSMakeRange(0, textatt2.length))
        
        if(gorevdurum == "tamamlandi"){
            cell.gorevbaslik.attributedText = textatt
            cell.gorevcheck.checkState = .checked
            cell.gorevbaslik.textColor = UIColor("#0984e3")
        }else if(gorevdurum == "tamamlanmadi"){
            cell.gorevbaslik.attributedText = textatt2
            cell.gorevcheck.checkState = .unchecked
            cell.gorevbaslik.textColor = UIColor("#cccccc")
        }
        
        gorevcheckboxs.append(cell.gorevcheck)
        
        cell.gorevtikla.accessibilityLabel = "\(gorevbaslik)"
        cell.gorevtikla.accessibilityHint = "\(gorevid)"
        cell.gorevtikla.addTarget(self, action: #selector(gorevtiklafunc), for: .touchUpInside)
        
        cell.gorevcheck.tag = satir
        cell.gorevcheck.addTarget(self, action: #selector(gorevcheckfunc), for: UIControl.Event.valueChanged)
        
        return cell
        
    }
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        
        let satir = indexPath.row
        
        let sahipid = self.gorevlerjson[satir]["uye_id"].stringValue
        let uyeid = self.uye_data.string(forKey: "uyeid")
        
        if(sahipid == uyeid!){
            let modifyAction = UIContextualAction(style: .normal, title:  "Sil", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                
                self.gorevisil(s: satir)
                
                success(true)
            })
            //modifyAction.image = UIImage(named: "plusbuton")
            modifyAction.backgroundColor = UIColor("#c0392b")
            
            let modifyActioni = UIContextualAction(style: .normal, title:  "Düzenle", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                
                self.goreviduzenle(s: satir)
                
                success(true)
            })
            //modifyActioni.image = UIImage(named: "plusbuton")
            modifyActioni.backgroundColor = UIColor("#0984e3")
            
            
            
            return UISwipeActionsConfiguration(actions: [modifyAction,modifyActioni])
        }else{
            let modifyActioni = UIContextualAction(style: .normal, title:  "Çık", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                
                self.gorevdencik(s: satir)
                
                success(true)
            })
            //modifyActioni.image = UIImage(named: "plusbuton")
            modifyActioni.backgroundColor = UIColor("#c0392b")
            
            return UISwipeActionsConfiguration(actions: [modifyActioni])
        }
        
    }
    
    func goreviduzenle(s: Int){
        let secilengorevid = self.gorevlerjson[s]["gorevid"].stringValue
        
        let sayfagecis = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "gorevDuzenleBirVC") as! GorevDuzenleBirController
        sayfagecis.secilenlisteid = secilenlisteid
        sayfagecis.secilenlistebaslik = secilenlistebaslik
        sayfagecis.secilengorevid = secilengorevid
        self.present(sayfagecis, animated: false, completion: nil)
    }
    
    func gorevisil(s: Int){
        self.hud.show(in: self.view)
        let uyeid = self.uye_data.string(forKey: "uyeid")
        let gorevid = self.gorevlerjson[s]["gorevid"].stringValue
        let parameters: Parameters = [
            "uyeid": "\(uyeid!)",
            "gorevid": "\(gorevid)"
        ]
        Alamofire.request(serviceurl + "gorevi_sil.php", method: .post, parameters: parameters).responseJSON { response in
            if let value = response.result.value {
                let gorevisiljson = JSON(value)
                print("gorevisiljson qnq: \(gorevisiljson)")
            }
            DispatchQueue.main.async {
                self.gorevlertable.reloadData()
                self.hud.dismiss(afterDelay: 1)
            }
        }
    }
    
    func gorevdencik(s: Int){
        self.hud.show(in: self.view)
        let uyeid = self.uye_data.string(forKey: "uyeid")
        let gorevid = self.gorevlerjson[s]["gorevid"].stringValue
        let parameters: Parameters = [
            "uyeid": "\(uyeid!)",
            "gorevid": "\(gorevid)"
        ]
        Alamofire.request(serviceurl + "gorevden_cik.php", method: .post, parameters: parameters).responseJSON { response in
            if let value = response.result.value {
                let gorevdencikjson = JSON(value)
                print("gorevdencikjson qnq: \(gorevdencikjson)")
            }
            DispatchQueue.main.async {
                self.gorevlertable.reloadData()
                self.hud.dismiss(afterDelay: 1)
            }
        }
    }
    
    @objc func gorevcheckfunc(sender:M13Checkbox!){
        
        let satir = sender.tag
        let gorevid = self.gorevlerjson[satir]["gorevid"].stringValue
        let checkdurum = "\(gorevcheckboxs[satir].checkState)"
        
        var degisendurum = String()
        
        if(checkdurum == "unchecked"){
            degisendurum = "tamamlanmadi"
        }else if(checkdurum == "checked"){
            degisendurum = "tamamlandi"
        }
        
        gorevcheckdegistir(durum: degisendurum,id: gorevid)
        
    }
    
    func gorevcheckdegistir(durum: String,id: String){
        let parameters: Parameters = [
            "gorevid": "\(id)",
            "degisen_durum": "\(durum)"
        ]
        Alamofire.request(serviceurl + "gorev_durum_degis.php", method: .post, parameters: parameters).responseJSON { response in
            if let value = response.result.value {
                let gorevcheckdegistir = JSON(value)
                print("gorevcheckdegistir qnq: \(gorevcheckdegistir)")
            }
        }
        self.gorevlercek()
    }
    
    @objc func gorevtiklafunc(sender:UIButton!){
        let secilengorevid = "\(sender.accessibilityHint!)"
        let secilengorevbaslik = "\(sender.accessibilityLabel!)"
        
        let sayfagecis = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "gorevmesajVC") as! GorevMesajlarController
        sayfagecis.secilengorevid = secilengorevid
        sayfagecis.secilengorevbaslik = secilengorevbaslik
        sayfagecis.secilenlisteid = secilenlisteid
        sayfagecis.secilenlistebaslik = secilenlistebaslik
        self.present(sayfagecis, animated: false, completion: nil)
    }
    
    @objc func gerigitfunc(sender:UIButton!){
        let sayfagecis = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "baslangicVC") as! BaslangicController
        self.present(sayfagecis, animated: false, completion: nil)
    }
    
    @objc func bildirimleregitfunc(sender:UIButton!){
        print("bildirimlere git")
    }
    
    func tableviewscrollbottom(){
        let gorevler = self.gorevlerjson.arrayValue
        let indexPath = IndexPath(row: gorevler.count - 1, section: 0)
        self.gorevlertable.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
}
