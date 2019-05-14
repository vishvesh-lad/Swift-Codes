//
//  AddServicePopupView.swift
//
//  Created by Vicky Prajapati.
//

import UIKit

class CustomPopupView: UIView,UITextFieldDelegate {
    
    // MARK:- IBOutlets
    @IBOutlet weak var lblAddService: UILabel!
    @IBOutlet weak var txtServiceTitle: SkyFloatingLabelTextField!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnAddServices: UIButton!
    @IBOutlet weak var viewAddService: UIView!
    
    //MARK: Closure
    var btnCloseTapped: (() -> ())?
    var btnOkTapped: ((_ name:String) -> ())?
//    var hideTapped: (() -> ())?
//    var isEditMode = false
    
    override func draw(_ rect: CGRect) {
        // make corner radius
//        Utilities.decorateView(self.btnAddServices.layer, cornerRadius: DeviceConstant.isDeviceTypeIpad() ? 4 : 2, borderWidth: 0, borderColor: UIColor.clear)
//        Utilities.decorateView(self.viewAddService.layer, cornerRadius: DeviceConstant.isDeviceTypeIpad() ? 4 : 2, borderWidth: 0, borderColor: UIColor.clear)
//        // make shadow
//        self.btnAddServices.dropShadow(color: UIColor.CustomColor.ShadowColor, opacity: 1 , offSet: CGSize(width: 0, height: DeviceConstant.isDeviceTypeIpad() ? 6 : 3), radius: DeviceConstant.isDeviceTypeIpad() ? 4 : 2, scale: true)
//        self.viewAddService.dropShadow(color: UIColor.CustomColor.ShadowColor, opacity: 1 , offSet: CGSize(width: 0, height: DeviceConstant.isDeviceTypeIpad() ? 10 : 5), radius: DeviceConstant.isDeviceTypeIpad() ? 4 : 2, scale: true)
    }
    
    override func didMoveToSuperview() {
        // set placeholder of textfeild
        self.txtServiceTitle.titleFont = UIFont.customFontLight(with: DeviceConstant.isDeviceTypeIpad() ? 24 : 12)
        self.txtServiceTitle.placeholder = LanguageManager.localizedString("lblServiceTitle")
        
        self.setupView()
    }

    // MARK:- Private Methods
    func setupView(){
        // check edit mode
//        if isEditMode{
//            self.lblAddService.text = LanguageManager.localizedString("lblEditService")
//            self.btnAddServices.setTitle(LanguageManager.localizedString("btnEditService"),for: .normal)
//        }else{
//            self.lblAddService.text = LanguageManager.localizedString("lblAddService")
//            self.btnAddServices.setTitle(LanguageManager.localizedString("btnAddServices"),for: .normal)
//        }
    }
    
    // MARK:- IBActions
    
    @IBAction func btnClose_Clicked(_ sender: UIButton) {
        if btnCloseTapped != nil{
            btnCloseTapped!()
        }
        self.removeFromSuperview()
    }
    @IBAction func btnAddServices_Clicked(_ sender: UIButton) {
        if btnOkTapped != nil{
            btnOkTapped!(self.txtServiceTitle.text ?? "")
        }
        self.removeFromSuperview()
    }
}
