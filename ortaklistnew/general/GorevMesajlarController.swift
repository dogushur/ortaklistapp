import UIKit
import DeviceKit
import SCLAlertView
import BRYXBanner
import UIColor_Hex_Swift
import Alamofire
import SwiftyJSON
import JGProgressHUD
import BLTNBoard

class GorevMesajlarController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let device = Device()
    
    let uye_data = UserDefaults.standard
    
    let serviceurl = "http://ortaklist.com/webservices/android/service_app_22042017/"
    
    let hud = JGProgressHUD(style: .extraLight)
    
    var uyebilgisijson = JSON()
    var gorevmesajlarjson = JSON()
    
    var secilengorevid = String()
    var secilengorevbaslik = String()
    
    var secilenlisteid = String()
    var secilenlistebaslik = String()
    
    var mesajkontrol = Timer()
    var mesajkontrol_isTimerRunning = false
    func runmesajkontrol() {
        mesajkontrol = Timer.scheduledTimer(timeInterval: 4, target: self,   selector: (#selector(GorevMesajlarController.updatemesajkontrol)), userInfo: nil, repeats: true)
    }
    @objc func updatemesajkontrol() {
        let eskigorevmesajlar = self.gorevmesajlarjson.arrayValue
        
        let parameters: Parameters = [
            "gorevid": "\(secilengorevid)"
        ]
        Alamofire.request(serviceurl + "mesaj_listele.php", method: .post, parameters: parameters).responseJSON { response in
            if let value = response.result.value {
                let kontrolmesajgorevlerjson = JSON(value)
                //print("kontrolmesajgorevlerjson qnq: \(kontrolmesajgorevlerjson)")
                
                let kontrolgorevmesajlar = kontrolmesajgorevlerjson.arrayValue
                
                if(eskigorevmesajlar.count != kontrolgorevmesajlar.count){
                    self.gorevmesajcek()
                }else{
                    //print("farkli mesaj yok")
                }
                
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

        gorevmesajsetup()
        
    }
    
    var didSetupConstraints = false
    
    var ustbar = UIView()
    var ustbaric = UIView()
    var ustbaricgenel = UIView()
    var ustbarcizgi = UIView()
    
    var geribtn = UIButton()
    var ustyazi = UILabel()
    var bildirimbtn = UIButton(type: .custom)
    
    var gorevmesajtable = UITableView()
    
    var mesajtextview = UIView()
    var mesajtextviewcizgi = UIView()
    var mesajyazmatextfield = UITextField()
    var mesajsend = UIButton(type: .custom)
    
    func gorevmesajsetup(){
        
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
            
            /*gorevmesajtable.frame = CGRect(x:0,y:ustbar.frame.height,width:screenHeight,height:screenHeight - (ustbar.frame.height+100))*/
            mesajtextview.frame = CGRect(x:0,y:screenHeight-100,width:screenWidth,height:100)
            mesajtextviewcizgi.frame = CGRect(x:0,y:0,width:screenWidth,height:1)
            mesajyazmatextfield.frame = CGRect(x:25,y:10,width:screenWidth - 50 - 50,height:40)
            mesajsend.frame = CGRect(x:mesajtextview.frame.width - 65,y:10,width:40,height:40)
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
        geribtn.tintColor = UIColor("#cccccc")
        geribtn.addTarget(self, action: #selector(gerigitfunc), for: .touchUpInside)
        ustbaricgenel.addSubview(geribtn)
        
        ustyazi.text = "\(secilengorevbaslik)"
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
        
        gorevmesajtable.delegate = self
        gorevmesajtable.dataSource = self
        gorevmesajtable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        gorevmesajtable.layer.zPosition = 1
        gorevmesajtable.backgroundColor = UIColor.clear
        gorevmesajtable.separatorStyle = UITableViewCell.SeparatorStyle.none
        gorevmesajtable.register(GorevMesajCell.classForCoder(), forCellReuseIdentifier: "GorevMesajCell")
        gorevmesajtable.showsVerticalScrollIndicator = false
        gorevmesajtable.showsHorizontalScrollIndicator = false
        gorevmesajtable.estimatedRowHeight = 60
        view.addSubview(gorevmesajtable)
        
        //
        
        //mesajtextview.backgroundColor = UIColor.red
        mesajtextview.backgroundColor = UIColor("#222222")
        mesajtextview.layer.zPosition = 2
        view.addSubview(mesajtextview)
        
        mesajtextviewcizgi.backgroundColor = UIColor("#303030")
        //mesajtextviewcizgi.backgroundColor = UIColor.clear
        mesajtextview.addSubview(mesajtextviewcizgi)
        
        let inputplaceholder = [
            NSAttributedString.Key.foregroundColor: UIColor("#ccc"),
            NSAttributedString.Key.font : UIFont(name: "Ubuntu-Medium", size: 22)!
        ]
        
        mesajyazmatextfield.backgroundColor = UIColor.clear
        mesajyazmatextfield.borderStyle = .none
        mesajyazmatextfield.attributedPlaceholder = NSAttributedString(string: "yazmak için dokun...", attributes:inputplaceholder)
        mesajyazmatextfield.keyboardType = .default
        mesajyazmatextfield.keyboardAppearance = .dark
        mesajyazmatextfield.textColor = UIColor("#ccc")
        mesajyazmatextfield.font = UIFont(name: "Ubuntu-Medium", size: 22)
        mesajyazmatextfield.delegate=self
        mesajtextview.addSubview(mesajyazmatextfield)
        
        mesajsend.clipsToBounds = true
        mesajsend.backgroundColor = UIColor("#0984e3")
        mesajsend.setImage(UIImage(named: "mesajsend")?.withRenderingMode(.alwaysTemplate), for: .normal)
        mesajsend.layer.cornerRadius = mesajsend.frame.width / 2
        mesajsend.tintColor = UIColor("#fff")
        mesajsend.addTarget(self, action: #selector(mesajsendfunc), for: .touchUpInside)
        mesajtextview.addSubview(mesajsend)
        
        //
        
        hud.textLabel.text = "Yükleniyor"
        hud.layer.zPosition = 9999
        
        uyebilgisicek()
        
        gorevmesajcek()
        
        self.view.setNeedsUpdateConstraints()
        
    }
    
    @objc func mesajsendfunc(sender:UIButton!){
        mesajkaydet()
    }
    
    func mesajkaydet(){
        let mesaj = "\(mesajyazmatextfield.text!)"
        print("mesaj: \(mesaj)")
        
        if(mesaj.count >= 1){
            let uyeid = self.uye_data.string(forKey: "uyeid")
            let parameters: Parameters = [
                "uyeid": "\(uyeid!)",
                "gorevid": "\(secilengorevid)",
                "mesajim": "\(mesaj)"
            ]
            Alamofire.request(serviceurl + "mesaj_gonder.php", method: .post, parameters: parameters).responseJSON { response in
                if let value = response.result.value {
                    let mesajkaydetjson = JSON(value)
                    print("mesajkaydetjson qnq: \(mesajkaydetjson)")
                    
                }
            }
            mesajyazmatextfield.text = ""
            view.endEditing(true)
            gorevmesajcek()
        }else{
            print("bos mesaj")
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
                
                self.mesajtextview.frame = CGRect(x:0,y:screenHeight-400,width:screenWidth,height:100)
                
                self.view.layoutIfNeeded()
            })
        }
        DispatchQueue.main.async {
            let point = CGPoint(x: 0, y: self.gorevmesajtable.contentSize.height - 300)
            if point.y >= 0{
                self.gorevmesajtable.setContentOffset(point, animated: true)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                let screenSize = UIScreen.main.bounds
                let screenWidth = screenSize.width
                let screenHeight = screenSize.height
                
                self.mesajtextview.frame = CGRect(x:0,y:screenHeight-100,width:screenWidth,height:100)
                
                self.view.layoutIfNeeded()
            })
        }
        DispatchQueue.main.async {
            let point = CGPoint(x: 0, y: self.gorevmesajtable.contentSize.height - 600)
            if point.y >= 0{
                self.gorevmesajtable.setContentOffset(point, animated: true)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        mesajyazmatextfield.resignFirstResponder()
        return (true)
    }
    
    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            
            gorevmesajtable.left(0).right(0).top(ustbar.frame.height).bottom(100)
            /*mesajtextview.left(0).right(0).bottom(0).pinTo(view: gorevmesajtable, top: 0)
            mesajtextviewcizgi.left(0).top(0).right(0).height(1)
            mesajyazmatextfield.left(25).top(10).right(25).height(40)*/
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
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
    
    func gorevmesajcek(){
        //self.hud.show(in: self.view)
        
        let parameters: Parameters = [
            "gorevid": "\(secilengorevid)"
        ]
        Alamofire.request(serviceurl + "mesaj_listele.php", method: .post, parameters: parameters).responseJSON { response in
            if let value = response.result.value {
                self.gorevmesajlarjson = JSON(value)
                print("gorevmesajlarjson qnq: \(self.gorevmesajlarjson)")
            }
            DispatchQueue.main.async {
                self.gorevmesajtable.reloadData()
                self.tableviewscrollbottom()
                self.runmesajkontrol()
                //self.hud.dismiss(afterDelay: 1)
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
        let gorevmesajlar = self.gorevmesajlarjson.arrayValue
        return gorevmesajlar.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GorevMesajCell", for: indexPath) as! GorevMesajCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        
        let satir = indexPath.row
        
        let uyeid = self.uye_data.string(forKey: "uyeid")
        
        let mesaj = self.gorevmesajlarjson[satir]["mesaj"].stringValue
        let mesajiatanuyeid = self.gorevmesajlarjson[satir]["uyeid"].stringValue
        let mesajiatanuyeisim = self.gorevmesajlarjson[satir]["mesaji_atan"].stringValue
        
        if(uyeid == mesajiatanuyeid){
            cell.gelenmesajisim.isHidden = true
            cell.gelenmesajbg.isHidden = true
            cell.gidenmesajbg.isHidden = false
            
            cell.gidenmesajtext.text = "\(mesaj)"
            cell.gelenmesajisim.text = ""
        }else if(uyeid != mesajiatanuyeid){
            cell.gelenmesajisim.isHidden = false
            cell.gelenmesajbg.isHidden = false
            cell.gidenmesajbg.isHidden = true
            
            cell.gelenmesajtext.text = "\(mesaj)"
            cell.gelenmesajisim.text = "\(mesajiatanuyeisim)"
        }
        
        return cell
    }
    
    func tableviewscrollbottom(){
        
        /*let gorevmesajlar = self.gorevmesajlarjson.arrayValue
        let indexPath = IndexPath(row: gorevmesajlar.count - 1, section: 0)
        self.gorevmesajtable.scrollToRow(at: indexPath, at: .bottom, animated: true)*/
        
        DispatchQueue.main.async {
            let point = CGPoint(x: 0, y: self.gorevmesajtable.contentSize.height - 450)
            if point.y >= 0{
                self.gorevmesajtable.setContentOffset(point, animated: true)
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
