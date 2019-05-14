//
//  BaseView.swift
//
//  Created by Vicky Prajapati.
//

import UIKit

class BaseView: UIViewController {
    
    //MARK: IBOutlet
    var btnRight:UIBarButtonItem!
    var btnLeft:UIBarButtonItem!
    
    //MARK:- View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Setup Image on NavigationBar Titleview
    func setNavigationTitleViewImage(imageName: String, navItem:UINavigationItem){
        let imageView = UIImageView(image: UIImage(named: imageName))
        navItem.titleView = imageView
    }
    
    //MARK:-  Setup Navigationbar Left Button (it's for back or menu)
    func setLeftBarButton(isBack:Bool, navItem:UINavigationItem)  {
        if isBack {
            btnLeft = UIBarButtonItem(image: UIImage(named: "Back"), style: .plain, target: self, action: #selector(self.popViewController))
        }
        else{
            btnLeft = UIBarButtonItem(image: UIImage(named: "Menu"), style: .plain, target: self, action: #selector(self.openMenuController))
            
            // make custom bar button for show notification count
//            let iconButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: UIImage(named: "Menu")!.size))
//            iconButton.setBackgroundImage(UIImage(named: "Menu"), for: .normal)
//            iconButton.addTarget(self, action: #selector(self.openMenuController), for: .touchUpInside)
//            btnLeft = UIBarButtonItem(customView: iconButton)
//
//            if SocketIOManager.sharedInstance.unreadConversationCount == 0 {
//                btnLeft.removeBadge()
//            }else{
//                btnLeft.addBadge(number: SocketIOManager.sharedInstance.unreadConversationCount)
//            }
        }
        navItem.leftBarButtonItem = nil
        navItem.leftBarButtonItem = btnLeft
    }
    
    //MARK:- Setup Navigationbar Left Button With Image
    func setLeftBarButton(imageName:String, navItem:UINavigationItem)  {
        btnLeft = UIBarButtonItem(image: UIImage(named: imageName), style: .plain, target: self, action: #selector(self.leftBarButtonClick))
        navItem.leftBarButtonItem = nil
        navItem.leftBarButtonItem = btnLeft
    }
    
    //MARK:- Remove Navigationbar Left Button With Image
    func removeLeftBarButtonForViewController(navItem:UINavigationItem){
        btnLeft = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navItem.leftBarButtonItem = nil
        navigationItem.leftBarButtonItem = btnLeft
    }
    
    //MARK:- Setup Navigationbar Left Button With Text
    func setLeftBarButtonText(title:String, navItem:UINavigationItem)  {
        btnLeft = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(self.leftBarButtonClick))
        //btnLeft.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFontSemiBold(with: 11)], for: UIControlState.normal)
        navItem.leftBarButtonItem = nil
        navItem.leftBarButtonItem = btnLeft
    }
    
    //MARK:- Setup Navigationbar Right Button
    func setRightBarButton(imageName:String, navItem:UINavigationItem)  {
        btnRight = UIBarButtonItem(image: UIImage(named: imageName), style: .plain, target: self, action: #selector(self.rightBarButtonClick))
        navItem.rightBarButtonItem = nil
        navItem.rightBarButtonItem = btnRight
    }
    
    //MARK:- Setup Navigationbar Right Button with Text
    func setRightBarButtonText(title:String, navItem:UINavigationItem)  {
        btnRight = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(self.rightBarButtonClick))
        btnRight.setTitleTextAttributes([NSAttributedString.Key.font:UIFont.customFontMedium(with: 14)], for: UIControl.State.normal)
        navItem.rightBarButtonItem = nil
        navItem.rightBarButtonItem = btnRight
    }
    
    //MARK:- Setup Navigationbar Multiple Right Button
    func setMultipleRightBarButtons(imageNames:[String], navItem:UINavigationItem) {
        var arrButtons = [UIBarButtonItem]()
        for i in 0..<imageNames.count {
            let barButton = UIBarButtonItem(image: UIImage(named: imageNames[i]), style: .plain, target: self, action: #selector(self.multipleBarButtonClick(sender:)))
            barButton.tag = i
            arrButtons.append(barButton)
        }
        navItem.rightBarButtonItems = nil
        navItem.rightBarButtonItems = arrButtons
    }
    
    func setMultipleRightBarButtonsCustomView(imageNames:[String], navItem:UINavigationItem) {
        var arrButtons = [UIBarButtonItem]()
        for i in 0..<imageNames.count {
            var size = UIImage(named: imageNames[i])!.size
            size.width = size.width < 30 ? 30:size.width
            let iconButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: size))
//            let iconButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: UIImage(named: imageNames[i])!.size))
            iconButton.setImage(UIImage(named: imageNames[i]), for: .normal)//setBackgroundImage(UIImage(named: imageNames[i]), for: .normal)
            iconButton.tag = i
            iconButton.addTarget(self, action: #selector(self.multipleBarButtonClick(sender:)), for: .touchUpInside)
            
            let barButton = UIBarButtonItem(customView: iconButton)
            barButton.tag = i
            arrButtons.append(barButton)
        }
        navItem.rightBarButtonItems = nil
        navItem.rightBarButtonItems = arrButtons
    }
    
    func setMultipleRightBarButtonsForDefaultAndSelectedState(imageNames: [(DefaultState: String, SelectedState: String, isSelected: Bool)], navItem:UINavigationItem) {
        var arrButtons = [UIBarButtonItem]()
        for i in 0..<imageNames.count {
            var size = UIImage(named: imageNames[i].DefaultState)!.size
            size.width = size.width < 30 ? 30:size.width
            let iconButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: size))
            iconButton.setImage(UIImage(named: imageNames[i].DefaultState), for: .normal)
            iconButton.setImage(UIImage(named: imageNames[i].SelectedState), for: .selected)
            iconButton.isSelected = imageNames[i].isSelected
            iconButton.tag = i
            iconButton.addTarget(self, action: #selector(self.multipleBarButtonClick(sender:)), for: .touchUpInside)
            
            let barButton = UIBarButtonItem(customView: iconButton)
            barButton.tag = i
            arrButtons.append(barButton)
        }
        navItem.rightBarButtonItems = nil
        navItem.rightBarButtonItems = arrButtons
    }
    
    //MARK:- IBAction Methods
    @objc func popViewController()  {
        self.navigationController?.popViewController(animated: true)
    }
    
    //Menu button click
    @objc func openMenuController()  {
    }
    
    //Left bar button click (Back button)
    @objc func leftBarButtonClick(){
    }
    
    //Right Bar Button click
    @objc func rightBarButtonClick(){
    }
    
    //Multiple bar buttons click
    @objc func multipleBarButtonClick(sender:UIBarButtonItem){
    }
}
