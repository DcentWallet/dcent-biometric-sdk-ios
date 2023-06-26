//
//  PopupBaseViewController.swift
//
//  Created by iotrustMac01 on 24/05/2019.
//

import UIKit
import DcentBiometric

typealias PopupViewControllerResult = (_ controller: PopupBaseViewController,_  buttonIndex:Int ) -> Void
typealias PopupViewControllerDismissHandler = () -> Void

class PopupBaseViewController: ViewController {
    let cancelButtonIndex: Int = -1
    let firstOtherButtonIndex: Int = 0
    var selectedButtonIndex: Int = -1
    var callerVC:UIViewController? = nil
    var popupResultHandler: PopupViewControllerResult? = nil
    var popupDismissHandler: PopupViewControllerDismissHandler? = nil
    
    override func viewDidLoad() {
        DcentMgr.searchDeviceStart()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
       super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func show(from fromViewController:UIViewController, animated:Bool, resultHandler:PopupViewControllerResult?, dismissHandler:PopupViewControllerDismissHandler? ){
        callerVC = fromViewController
        self.popupResultHandler = resultHandler
        self.popupDismissHandler = dismissHandler
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
        fromViewController.present(self, animated: animated, completion: nil)
    }
    
    func dismissAnimationStart() {

    }
    
    @IBAction func closeAction() {
        self.dismissAnimationStart()
        self.dismiss(animated: true) {
            if self.popupDismissHandler != nil {
                self.popupDismissHandler?()
            }
            
        }
    }
}
