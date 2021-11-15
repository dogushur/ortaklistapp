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

class ListeDuzenleController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let device = Device()
    
    let uye_data = UserDefaults.standard
    
    let serviceurl = "http://ortaklist.com/webservices/android/service_app_22042017/"
    
    let hud = JGProgressHUD(style: .extraLight)
    
    var uyebilgisijson = JSON()
    var listedetayjson = JSON()
    var aramasonucjson = JSON()
    
    var secilenlisteid = String()
    
    var kisilercheckboxs = [M13Checkbox]()
    
    var newsecilenkisiler = String()
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    var kisiarakontrol = Timer()
    var kisiarakontrol_isTimerRunning = false
    func runkisiara() {
        kisiarakontrol = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ListeDuzenleController.updatekisiarakontrol)), userInfo: nil, repeats: true)
    }
    @objc func updatekisiarakontrol() {
        aranantext = "\(aramatextfield.text!)"
        
        if(eskiaranantext != aranantext){
            if(aranantext.count >= 3){
                kisiara()
            }else{
                print("Arama yapmak için en az üç karakter girin.\n\(aranantext)")
            }
        }else{
            //farklibirkelimegirin
        }
    }
    
    var aranantext = ""
    var aramatextfield = UITextField()
    var eskiaranantext = ""
    
    var girisyapanisim = ""
    var girisyapaneposta = ""
    var girisyapanusername = ""
    
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
    var kisiaratable = UITableView()
    
    var gerigitbtn = UIButton()
    var ilerigitbtn = UIButton()
    
    var listeuyeleri = [String]()
    
    func gorevduzenlesetup(){
    
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
            kisiaratable = UITableView(frame: CGRect(x:0,y:0,width: gorevduzenleview.frame.width,height:gorevduzenleview.frame.height))
            
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
        
        gorevduzenleview.backgroundColor = UIColor.clear
        gorevduzenleview.layer.zPosition = 9999
        view.addSubview(gorevduzenleview)
        view.bringSubviewToFront(gorevduzenleview)
        
        kisiaratable.delegate = self
        kisiaratable.dataSource = self
        kisiaratable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        kisiaratable.layer.zPosition = 1
        kisiaratable.backgroundColor = UIColor.clear
        kisiaratable.separatorStyle = UITableViewCell.SeparatorStyle.none
        kisiaratable.register(KisiAraCell.classForCoder(), forCellReuseIdentifier: "KisiAraCell")
        kisiaratable.showsVerticalScrollIndicator = false
        kisiaratable.showsHorizontalScrollIndicator = false
        kisiaratable.estimatedRowHeight = 60
        kisiaratable.isHidden = true
        gorevduzenleview.addSubview(kisiaratable)
        
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
        listedetaycek()
        
    }
    
    var page = TextFieldBulletinPage()
    var listebaslik = ""
    
    lazy var bulletinManager: BLTNItemManager = {
        
        page = TextFieldBulletinPage(title: "Liste Düzenle")
        
        page.descriptionText = ""
        page.actionButtonTitle = "Devam Et"
        
        page.actionHandler = { (item: BLTNActionItem) in
            self.bulletinyes()
        }
        
        page.alternativeHandler = { (item: BLTNActionItem) in
            self.bulletinno()
        }
        
        page.textInputHandler = { (item, text) in
            self.listebaslik = text!
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
            kisiarabaslat()
        }
        
    }
    
    func bulletinno(){
        listebaslik = ""
        bulletinManager.dismissBulletin()
    }
    
    func bulletinac(){
        
        bulletinManager.backgroundColor = UIColor("#ccc")
        bulletinManager.backgroundViewStyle = .blurredLight
        
        bulletinManager.showBulletin(above: self)
        
        listebaslik = "\(self.listedetayjson["list_basligi"].stringValue)"
        page.textField.text = "\(listebaslik)"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.page.textField.becomeFirstResponder()
        }
        
    }
    
    func kisiarabaslat(){
        bulletinManager.dismissBulletin()
        kisiaratable.isHidden = false
    }
    
    func listedetaycek(){
        
        let uyeid = self.uye_data.string(forKey: "uyeid")
        let parameters: Parameters = [
            "uyeid": "\(uyeid!)",
            "listeid": "\(secilenlisteid)"
        ]
        Alamofire.request(serviceurl + "liste_detay.php", method: .post, parameters: parameters).responseJSON { response in
            if let value = response.result.value {
                self.listedetayjson = JSON(value)
                print("listedetayjson qnq: \(self.listedetayjson)")
                
                let listeuyeleriarray = self.listedetayjson["list_uyeleri"].arrayValue
                
                for i in 0..<listeuyeleriarray.count{
                    let kullaniciadi = "\(listeuyeleriarray[i]["kullanici_adi"].stringValue)"
                    self.listeuyeleri.append(kullaniciadi)
                }
                
                self.listeuyeleri.append(self.girisyapanusername)
                
                self.bulletinac()
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
                
                let sonuc = self.uyebilgisijson["sonuc"].stringValue
                
                if(sonuc == "100"){
                    
                    self.girisyapanisim = "\(self.uyebilgisijson["isim"].stringValue)"
                    self.girisyapaneposta = "\(self.uyebilgisijson["eposta"].stringValue)"
                    self.girisyapanusername = "\(self.uyebilgisijson["kullanici_adi"].stringValue)"
                    
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
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let aramaoneri = self.aramasonucjson.arrayValue
        return aramaoneri.count + 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "KisiAraCell", for: indexPath) as! KisiAraCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        
        let satir = indexPath.row
        
        if(satir == 0){
            DispatchQueue.main.async {
                cell.kisilerbaslik.isHidden = true
                cell.kisilercheck.isHidden = true
                cell.kisiaratextbox.isHidden = false
                cell.kisiaratextbox.delegate = self
            }
            aramatextfield = cell.kisiaratextbox
            aramatextfield.becomeFirstResponder()
        }else{
            let searchusername = self.aramasonucjson[satir-1]["kullanici_adi"].stringValue
            let searchisim = self.aramasonucjson[satir-1]["isim"].stringValue
            
            DispatchQueue.main.async {
                cell.kisilerbaslik.isHidden = false
                cell.kisilercheck.isHidden = false
                cell.kisiaratextbox.isHidden = true
                
                if(self.listeuyeleri.contains(searchusername)){
                    cell.kisilercheck.checkState = .checked
                }else{
                    cell.kisilercheck.checkState = .unchecked
                }
                
                cell.kisilerbaslik.text = "\(searchisim)"
            }
            
            kisilercheckboxs.append(cell.kisilercheck)
            cell.kisilercheck.tag = satir-1
            cell.kisilercheck.accessibilityHint = self.aramasonucjson[satir-1]["kullanici_adi"].stringValue
            cell.kisilercheck.addTarget(self, action: #selector(self.kisilercheckfunc), for: UIControl.Event.valueChanged)
        }
        
        return cell
    }
    
    @objc func kisilercheckfunc(sender:M13Checkbox!){
        
        let secilensatir = sender.tag
        let checkdurum = "\(kisilercheckboxs[secilensatir].checkState)"
        
        let secilenusername = "\(sender.accessibilityHint!)"
        
        if(checkdurum == "unchecked"){
            if(secilenusername == girisyapanusername){
                let basarisizbildirim = Banner(title: "Hata!", subtitle: "Kendi oluşturduğunuz listeden çıkamazsınız.", image: UIImage(named: "bildirimbeyaz.png"), backgroundColor: UIColor("#ff3838"))
                basarisizbildirim.dismissesOnTap = true
                basarisizbildirim.show(duration: 3.0)
                
                kisilercheckboxs[secilensatir].checkState = .checked
            }else{
                for i in 0..<listeuyeleri.count{
                    let gelenusername = listeuyeleri[i]
                    if(gelenusername == secilenusername){
                        listeuyeleri[i] = "username"
                    }else{
                        //eş degil
                    }
                }
            }
        }else if(checkdurum == "checked"){
            if(girisyapanusername == secilenusername){
                print("kendinizi listeye ekleyemezsiniz")
            }else{
               listeuyeleri.append(secilenusername)
            }
        }
        
    }
    
    func kisiara(){
        self.hud.show(in: self.view)
        
        let parameters: Parameters = [
            "kelime": "\(aranantext)"
        ]
        Alamofire.request(serviceurl + "uye_onerileri.php", method: .post, parameters: parameters).responseJSON { response in
            if let value = response.result.value {
                self.aramasonucjson = JSON(value)
                print("aramasonucjson qnq: \(self.aramasonucjson)")
            }
            DispatchQueue.main.async {
                self.kisiaratable.reloadData()
                self.kisiarakontrol.invalidate()
                self.hud.dismiss(afterDelay: 1)
            }
        }
        eskiaranantext = aranantext
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        runkisiara()
        textField.resignFirstResponder()
        return true
    }
    
    @objc func ilerigitbtnfunc(sender:UIButton!){
       gorevduzenlefunc()
    }
    
    func gorevduzenlefunc(){
        listekisitemizle()
        let uyeid = self.uye_data.string(forKey: "uyeid")
        let parameters: Parameters = [
            "uyeid": "\(uyeid!)",
            "listeid": "\(secilenlisteid)",
            "baslik": "\(listebaslik)",
            "kullaniciadlari": "\(newsecilenkisiler)"
        ]
        Alamofire.request(serviceurl + "liste_duzenle.php", method: .post, parameters: parameters).responseJSON { response in
            if let value = response.result.value {
                let listeguncellejson = JSON(value)
                print("listeguncellejson qnq: \(listeguncellejson)")
            }
        }
        let basarilibildirim = Banner(title: "Tebrikler!", subtitle: "Listeyi başarıyla düzenlediniz.", image: UIImage(named: "bildirimbeyaz.png"), backgroundColor: UIColor("#27ae60"))
        basarilibildirim.dismissesOnTap = true
        basarilibildirim.show(duration: 3.0)
        
        gerisayfagit()
    }
    
    func listekisitemizle(){
        let secilenkisileruzunluk = listeuyeleri.count
        
        for i in 0..<secilenkisileruzunluk{
            let username = "\(listeuyeleri[i])"
            if(username == girisyapanusername){
                listeuyeleri[i] = "username"
            }
        }
        
        for i in 0..<secilenkisileruzunluk{
            let username = "\(listeuyeleri[i])"
            if(username != "username"){
                newsecilenkisiler = "\(newsecilenkisiler + username), "
            }
        }
    }
    
    @objc func gerigitbtnfunc(sender:UIButton!){
        //
    }
    
    @objc func gerigitfunc(sender:UIButton!){
        gerisayfagit()
    }
    
    func gerisayfagit(){
        let sayfagecis = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "baslangicVC") as! BaslangicController
        self.present(sayfagecis, animated: false, completion: nil)
    }
    
    @objc func bildirimleregitfunc(sender:UIButton!){
        print("bildirimlere git")
    }
    
}
