import UIKit
import paper_onboarding
import UIColor_Hex_Swift

class BoardController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate let items = [
        OnboardingItemInfo(informationImage: UIImage(named: "Hotels")!,
                           title: "Planlama",
                           description: "Tüm işlerinizi kolayca planlayın",
                           pageIcon: UIImage(named: "Key")!,
                           color: UIColor("#222222"),
                           titleColor: UIColor("#555555"), descriptionColor: UIColor("#cccccc"), titleFont: titleFont, descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage: UIImage(named: "Banks")!,
                           title: "Görevler",
                           description: "Çalışanlar arasında görev paylaşımı",
                           pageIcon: UIImage(named: "Wallet")!,
                           color: UIColor("#222222"),
                           titleColor: UIColor("#555555"), descriptionColor: UIColor("#cccccc"), titleFont: titleFont, descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage: UIImage(named: "Stores")!,
                           title: "Zamanlama",
                           description: "Herşey tam yolunda",
                           pageIcon: UIImage(named: "Shopping-cart")!,
                           color: UIColor("#222222"),
                           titleColor: UIColor("#555555"), descriptionColor: UIColor("#cccccc"), titleFont: titleFont, descriptionFont: descriptionFont),
    ]
    
    let uye_data = UserDefaults.standard
    
    var onboarding = PaperOnboarding()
    var skipButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPaperOnboardingView()
        
    }
    
    private func setupPaperOnboardingView() {
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        //let screenHeight = screenSize.height
        
        onboarding.delegate = self
        onboarding.dataSource = self
        onboarding.backgroundColor = UIColor("#222222")
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)
        
        for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
        }
        
        skipButton = UIButton(frame: CGRect(x:screenWidth-150,y:70,width:150,height:50))
        skipButton.setTitle("Devam et", for: .normal)
        skipButton.setTitleColor(UIColor("#cccccc"), for: .normal)
        skipButton.isHidden = true
        skipButton.titleLabel?.font = UIFont(name: "Ubuntu-Bold", size: 20.0)
        skipButton.layer.zPosition = 999
        skipButton.isUserInteractionEnabled = true
        skipButton.addTarget(self, action: #selector(skipfunc), for: .touchUpInside)
        view.addSubview(skipButton)
        view.bringSubviewToFront(skipButton)
        
    }
    
    @objc func skipfunc(sender:UIButton!){
        uye_data.set(true, forKey: "boarding_status")
        
        let sayfagecis = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeVC") as! HomeController
        self.present(sayfagecis, animated: false, completion: nil)
    }
    
}

extension BoardController: PaperOnboardingDelegate {
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        skipButton.isHidden = index == 2 ? false : true
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        
        // configure item
        
        //item.titleLabel?.backgroundColor = .redColor()
        //item.descriptionLabel?.backgroundColor = .redColor()
        //item.imageView = ...
        
    }
    
}

extension BoardController: PaperOnboardingDataSource {
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return items[index]
    }
    
    func onboardingItemsCount() -> Int {
        return items.count
    }
    
}

private extension BoardController {
    static let titleFont = UIFont(name: "Nunito-Bold", size: 36.0) ?? UIFont.boldSystemFont(ofSize: 36.0)
    static let descriptionFont = UIFont(name: "Ubuntu-Medium", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
}
