//
//  QRViewController.swift
//  TLCAdmin
//
//  Created by Stephen Bechtold on 8/5/16.
//  Copyright © 2016 The Laundry Chute. All rights reserved.
//

import UIKit
import InMotionUI


public protocol QRViewControllerDelegate {
    
    func qrViewController(_ controller:QRViewController, didScan result:String);
    func qrViewController(didCancel controller:QRViewController);
}

open class QRViewController: UIViewController, UIQRReaderDelegate {

    @IBOutlet var qrView:UIView!;
    fileprivate var _qrReader:UIQRReader?;
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        if (_qrReader == nil) {
            _qrReader = UIQRReader();
            
            _qrReader?.bounds = CGRect(x: 0, y: 0, width: self.qrView.frame.width, height: self.qrView.frame.height);
            _qrReader?.delegate = self;
            
            self.qrView.addSubview(_qrReader!);
            _qrReader?.bindFrameToSuperviewBounds();
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    open var delegate:QRViewControllerDelegate?;

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    open override func viewDidAppear(_ animated: Bool) {
        _qrReader?.capture();
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        _qrReader?.end();
    }

    @IBAction func cancelButtonWasPressed(_ sender: AnyObject) {
        
        self.navigationController?.popViewController(animated: true);
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - UIQRReaderDelegate Members
    open func qrReader(_ reader: UIQRReader, didScan scan: String) -> Bool {
        self.delegate?.qrViewController(self, didScan: scan);
        self.dismiss(animated: true, completion: nil);
        self.navigationController?.popViewController(animated: true);
        return true;
    }

}

extension UIView {
    
    /// Adds constraints to this `UIView` instances `superview` object to make sure this always has the same size as the superview.
    /// Please note that this has no effect if its `superview` is `nil` – add this `UIView` instance as a subview before calling this.
    func bindFrameToSuperviewBounds() {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["subview": self]))
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["subview": self]))
    }
    
}
