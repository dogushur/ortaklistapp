import UIKit
import DeviceKit
import SCLAlertView
import BRYXBanner
import UIColor_Hex_Swift
import Alamofire
import SwiftyJSON
import JGProgressHUD
import BLTNBoard

class BaslangicController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let device = Device()
    
    let uye_data = UserDefaults.standard
    
    let serviceurl = "http://ortaklist.com/webservices/android/service_app_22042017/"
    
    let hud = JGProgressHUD(style: .extraLight)
    
    var uyebilgisijson = JSON()
    var listelerjson = JSON()
    
    var listekontrol = Timer()
    var listekontrol_isTimerRunning = false
    func runlistekontrol() {
        listekontrol = Timer.scheduledTimer(timeInterval: 4, target: self,   selector: (#selector(BaslangicController.updatelistekontrol)), userInfo: nil, repeats: true)
    }
    @objc func updatelistekontrol() {
        listeyenile()
    }
    func listeyenile(){
        let uyeid = self.uye_data.string(forKey: "uyeid")
        let eposta = self.uyebilgisijson["eposta"].stringValue
        
        let parameters: Parameters = [
            "uyeid": "\(uyeid!)",
            "eposta": "\(eposta)"
        ]
        Alamofire.request(serviceurl + "liste_goruntule.php", method: .post, parameters: parameters).responseJSON { response in
            if let value = response.result.value {
                self.listelerjson = JSON(value)
                //print("listelerjson qnq: \(self.listelerjson)")
                
            }
            DispatchQueue.main.async {
                self.listelertable.reloadData()
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

        baslangicsetup()
        
    }
    
    var ustbar = UIView()
    var ustbaric = UIView()
    var ustbaricgenel = UIView()
    var ustbarcizgi = UIView()
    
    var pp = UIButton()
    var ustyazi = UILabel()
    var bildirimbtn = UIButton(type: .custom)
    
    var listelertable = UITableView()
    
    var plusbuton = UIButton()
    
    func baslangicsetup(){
        
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
            
            pp = UIButton(frame: CGRect(x:0,y:0,width:ustbaricgenel.frame.height,height:ustbaricgenel.frame.height))
            ustyazi = UILabel(frame: CGRect(x:pp.frame.width,y:0,width:ustbaricgenel.frame.width - pp.frame.width*2,height:ustbaricgenel.frame.height))
            bildirimbtn = UIButton(frame: CGRect(x:ustbaricgenel.frame.width-30,y:10,width:30,height: 30))
            
            listelertable = UITableView(frame: CGRect(x: 0, y: ustbar.frame.height, width: screenWidth, height: screenHeight-ustbar.frame.height))
            
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
        
        ustbarcizgi.backgroundColor = UIColor.clear
        ustbar.addSubview(ustbarcizgi)
        
        pp.clipsToBounds = true
        pp.layer.cornerRadius = pp.frame.width / 2
        pp.backgroundColor = UIColor("#555555")
        pp.setTitleColor(UIColor("#cccccc"), for: .normal)
        pp.titleLabel?.font = UIFont(name: "Ubuntu-Bold", size: 20.0)
        pp.addTarget(self, action: #selector(profilegitfunc), for: .touchUpInside)
        ustbaricgenel.addSubview(pp)
        
        ustyazi.text = "ortaklist"
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
        
        listelertable.delegate = self
        listelertable.dataSource = self
        listelertable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        listelertable.layer.zPosition = 1
        listelertable.backgroundColor = UIColor.clear
        listelertable.separatorStyle = UITableViewCell.SeparatorStyle.none
        listelertable.register(ListelerCell.classForCoder(), forCellReuseIdentifier: "ListelerCell")
        listelertable.showsVerticalScrollIndicator = false
        listelertable.showsHorizontalScrollIndicator = false
        view.addSubview(listelertable)
        
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
        
        hud.textLabel.text = "Yükleniyor"
        hud.layer.zPosition = 9999
        
        uyebilgisicek()
        
        listecek()
        
    }
    
    var page = TextFieldBulletinPage()
    var listebaslik = ""
    
    lazy var bulletinManager: BLTNItemManager = {
        
        page = TextFieldBulletinPage(title: "Liste Oluştur")
        //page.image = UIImage(named: "...")
        
        //page.descriptionText = "Devam edebilmek için lütfen listenize bir başlık girin."
        page.descriptionText = ""
        page.actionButtonTitle = "Tamamla"
        //page.alternativeButtonTitle = "Vazgeç"
        //page.descriptionLabel?.textColor = .red
        
        page.actionHandler = { (item: BLTNActionItem) in
            self.bulletinyes()
        }
        
        page.alternativeHandler = { (item: BLTNActionItem) in
            self.bulletinno()
        }
        
        page.textInputHandler = { (item, text) in
            self.listebaslik = text!
            //print("Text: \(text ?? "nil")")
        }
        
        let bullpage: BLTNItem = page
        return BLTNItemManager(rootItem: bullpage)
        
    }()
    
    func bulletinyes(){
        
        if(listebaslik == ""){
            let basarisizbildirim = Banner(title: "Uyarı!", subtitle: "Lütfen boş alan bırakmayınız.", image: UIImage(named: "bildirimbeyaz.png"), backgroundColor: UIColor("#ff3838"))
            basarisizbildirim.dismissesOnTap = true
            basarisizbildirim.show(duration: 3.0)
            
            self.page.textField.becomeFirstResponder()
            
        }else{
            listeolustur()
        }
        
    }
    
    func bulletinno(){
        listebaslik = ""
        bulletinManager.dismissBulletin()
    }
    
    @objc func plusbtnfunc(sender:UIButton!){
        bulletinac()
    }
    
    func bulletinac(){
        
        bulletinManager.backgroundColor = UIColor("#ccc")
        bulletinManager.backgroundViewStyle = .blurredLight
        //bulletinManager.statusBarAppearance = .hidden
        
        bulletinManager.showBulletin(above: self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.page.textField.becomeFirstResponder()
        }
        
    }
    
    func listeolustur(){
        let uyeid = self.uye_data.string(forKey: "uyeid")
        let uyekullaniciadi = self.uyebilgisijson["kullanici_adi"].stringValue
        let parameters: Parameters = [
            "uyeid": "\(uyeid!)",
            "baslik": "\(listebaslik)",
            "secilen_kullanici": "\(uyekullaniciadi),"
        ]
        Alamofire.request(serviceurl + "yeni_liste_olustur.php", method: .post, parameters: parameters).responseJSON { response in
            if let value = response.result.value {
                let listeolusturjson = JSON(value)
                print("listeolusturjson qnq: \(listeolusturjson)")
                
                let sonuc = listeolusturjson["sonuc"].stringValue
                
                if(sonuc == "100"){
                    
                    let basarilibildirim = Banner(title: "Tebrikler!", subtitle: "Başarıyla yeni liste oluşturdunuz.", image: UIImage(named: "bildirimbeyaz.png"), backgroundColor: UIColor("#27ae60"))
                    basarilibildirim.dismissesOnTap = true
                    basarilibildirim.show(duration: 3.0)
                    
                    self.listebaslik = ""
                    
                    self.bulletinManager.dismissBulletin()
                    
                    self.listecek()
                    
                }else{
                    let basarisizbildirim = Banner(title: "Başarısız!", subtitle: "Liste oluşturulurken hata oluştu.", image: UIImage(named: "bildirimbeyaz.png"), backgroundColor: UIColor("#ff3838"))
                    basarisizbildirim.dismissesOnTap = true
                    basarisizbildirim.show(duration: 3.0)
                }
                
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
                    
                    let isim = self.uyebilgisijson["isim"].stringValue
                    
                    DispatchQueue.main.async {
                        self.pp.setTitle("\(isim.prefix(1))", for: .normal)
                    }
                    
                }else{
                    print("uye bilgisi cekilemedi.")
                }
                
            }
        }
        
    }
    
    func listecek(){
        self.hud.show(in: self.view)
        
        let uyeid = self.uye_data.string(forKey: "uyeid")
        let eposta = self.uyebilgisijson["eposta"].stringValue
        
        let parameters: Parameters = [
            "uyeid": "\(uyeid!)",
            "eposta": "\(eposta)"
        ]
        Alamofire.request(serviceurl + "liste_goruntule.php", method: .post, parameters: parameters).responseJSON { response in
            if let value = response.result.value {
                self.listelerjson = JSON(value)
                print("listelerjson qnq: \(self.listelerjson)")
            }
            DispatchQueue.main.async {
                self.listelertable.reloadData()
                self.hud.dismiss(afterDelay: 1)
                self.runlistekontrol()
            }
        }
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let listeler = self.listelerjson.arrayValue
        return listeler.count + 2
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListelerCell", for: indexPath) as! ListelerCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        
        let satir = indexPath.row
        
        if(satir == 0){
            cell.listeicon.setImage(UIImage(named: "yapilacaklaricon")?.withRenderingMode(.alwaysTemplate), for: .normal)
            cell.listeicon.tintColor = UIColor("#cccccc")
            cell.listebaslik.text = "Yapılacaklar"
            cell.listetikla.accessibilityHint = "tamamlanmadi"
            cell.listetikla.accessibilityLabel = "Yapılacaklar"
        }else if(satir == 1){
            cell.listeicon.setImage(UIImage(named: "tamamlananlaricon")?.withRenderingMode(.alwaysTemplate), for: .normal)
            cell.listeicon.tintColor = UIColor("#cccccc")
            cell.listebaslik.text = "Tamamlananlar"
            cell.listetikla.accessibilityHint = "tamamlandi"
            cell.listetikla.accessibilityLabel = "Tamamlananlar"
        }else{
            let listebaslik = self.listelerjson[satir - 2]["baslik"].stringValue
            let listeid = self.listelerjson[satir - 2]["listeid"].stringValue
            
            cell.listeicon.setImage(UIImage(named: "klasoricon")?.withRenderingMode(.alwaysTemplate), for: .normal)
            cell.listeicon.tintColor = UIColor("#0984e3")
            cell.listebaslik.text = "\(listebaslik)"
            cell.listetikla.accessibilityLabel = "\(listebaslik)"
            cell.listetikla.accessibilityHint = "\(listeid)"
        }
        
        cell.listetikla.addTarget(self, action: #selector(listetiklafunc), for: .touchUpInside)
        
        return cell
    }
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        
        let satir = indexPath.row
        
        if(satir >= 2){
            let sahipid = self.listelerjson[satir - 2]["sahipid"].stringValue
            let uyeid = self.uye_data.string(forKey: "uyeid")
            
            if(sahipid == uyeid!){
                let modifyAction = UIContextualAction(style: .normal, title:  "Sil", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                    
                    self.listesilfunc(s: satir)
                    
                    success(true)
                })
                //modifyAction.image = UIImage(named: "plusbuton")
                modifyAction.backgroundColor = UIColor("#c0392b")
                
                let modifyActioni = UIContextualAction(style: .normal, title:  "Düzenle", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                    
                    self.listeduzenlefunc(s: satir)
                    
                    success(true)
                })
                //modifyActioni.image = UIImage(named: "plusbuton")
                modifyActioni.backgroundColor = UIColor("#0984e3")
                
                return UISwipeActionsConfiguration(actions: [modifyAction,modifyActioni])
            }else{
                let modifyActioni = UIContextualAction(style: .normal, title:  "Çık", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                    
                    self.listedencik(s: satir)
                    
                    success(true)
                })
                //modifyActioni.image = UIImage(named: "plusbuton")
                modifyActioni.backgroundColor = UIColor("#c0392b")
                
                return UISwipeActionsConfiguration(actions: [modifyActioni])
            }
        }else{
            return UISwipeActionsConfiguration.init()
        }
        
    }
    
    func listesilfunc(s: Int){
        self.hud.show(in: self.view)
        let uyeid = self.uye_data.string(forKey: "uyeid")
        let listeid = self.listelerjson[s - 2]["listeid"].stringValue
        let parameters: Parameters = [
            "uyeid": "\(uyeid!)",
            "listeid": "\(listeid)"
        ]
        Alamofire.request(serviceurl + "listeyi_sil.php", method: .post, parameters: parameters).responseJSON { response in
            if let value = response.result.value {
                let listesiljson = JSON(value)
                print("listesiljson qnq: \(listesiljson)")
            }
            DispatchQueue.main.async {
                self.listelertable.reloadData()
                self.hud.dismiss(afterDelay: 1)
            }
        }
    }
    
    func listeduzenlefunc(s: Int){
        let listeid = self.listelerjson[s - 2]["listeid"].stringValue
        
        let sayfagecis = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "listeDuzenleVC") as! ListeDuzenleController
        sayfagecis.secilenlisteid = listeid
        self.present(sayfagecis, animated: false, completion: nil)
    }
    
    func listedencik(s: Int){
        self.hud.show(in: self.view)
        let uyeid = self.uye_data.string(forKey: "uyeid")
        let listeid = self.listelerjson[s - 2]["listeid"].stringValue
        let parameters: Parameters = [
            "uyeid": "\(uyeid!)",
            "listeid": "\(listeid)"
        ]
        Alamofire.request(serviceurl + "listeden_cik.php", method: .post, parameters: parameters).responseJSON { response in
            if let value = response.result.value {
                let listedencikjson = JSON(value)
                print("listedencikjson qnq: \(listedencikjson)")
            }
            DispatchQueue.main.async {
                self.listelertable.reloadData()
                self.hud.dismiss(afterDelay: 1)
            }
        }
    }
    
    @objc func listetiklafunc(sender:UIButton!){
        let secilenliste = "\(sender.accessibilityHint!)"
        let secilenlistebaslik = "\(sender.accessibilityLabel!)"
        
        let sayfagecis = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "gorevlerVC") as! GorevlerController
        sayfagecis.secilenlisteid = secilenliste
        sayfagecis.secilenlistebaslik = secilenlistebaslik
        self.present(sayfagecis, animated: false, completion: nil)
    }
    
    @objc func profilegitfunc(sender:UIButton!){
        print("profile git")
    }
    
    @objc func bildirimleregitfunc(sender:UIButton!){
        print("bildirimlere git")
    }
    
}
