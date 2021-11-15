import UIKit
import RevealingSplashView
import UIColor_Hex_Swift

class ViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let uye_data = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        splashscreen()
        
    }
    
    func splashscreen(){
        
        view.backgroundColor = UIColor("#222222")
        
        let splashview = RevealingSplashView(iconImage: UIImage(named: "splashikon")!,iconInitialSize: CGSize(width: 70, height: 70), backgroundColor: UIColor(red:53, green:59, blue:72, alpha:1.0))
        splashview.duration = 1.5
        splashview.backgroundColor = UIColor("#222222")
        splashview.animationType = SplashAnimationType.woobleAndZoomOut
        self.view.addSubview(splashview)
        
        splashview.startAnimation(){
            
            let boarding_status = self.uye_data.bool(forKey: "boarding_status")
            
            if( boarding_status == true ){
                
                let uye_girisi = self.uye_data.bool(forKey: "uye_girisi")
                
                if( uye_girisi == true ){
                    let sayfagecis = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "baslangicVC") as! BaslangicController
                    self.present(sayfagecis, animated: false, completion: nil)
                }else if( uye_girisi == false){
                    let sayfagecis = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeVC") as! HomeController
                    self.present(sayfagecis, animated: false, completion: nil)
                }
                
            }else if( boarding_status == false ){
                let sayfagecis = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "boardVC") as! BoardController
                self.present(sayfagecis, animated: false, completion: nil)
            }
            
        }
        
    }

}

