import UIKit
import InMotion
import InMotionUI
import WebKit

class ViewController: InMotionViewController, ContextDelegate, WKNavigationDelegate, QRViewControllerDelegate {
    
    var authorization:Authorization?;
    
    @IBOutlet weak var containerView: UIView!
    var webView:WKWebView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Context.current.addResponder(self, error: nil);
        
        self.navigationController?.isNavigationBarHidden = true;
        
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.containerView.frame.size.width, height: self.containerView.frame.size.height));
        webView.navigationDelegate = self;
        self.containerView.addSubview(webView);
    }
    
    @IBAction func logOutButtonWasPressed(_ sender: AnyObject) {
        Context.current.logOut();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Context.current.removeResponder(self, error: nil);
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        
        webView?.frame = self.containerView.bounds;
        
    }
    
    func initWebView() {
        if (authorization?.token == nil) {
            return;
        }
        
        let encodedToken = self.encodeString(authorization!.token!);
        let url = AppConfig.current.net.makePublicPath("?isWebView&token=" + encodedToken);
        
        let request = URLRequest(url: url);
        webView.load(request);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "capture-qr-code") {
            let qrReader = segue.destination as! QRViewController;
            qrReader.delegate = self;
        }
    }
    
    func encodeString(_ raw:String) -> String {
        let chars = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~/?");
        return raw.addingPercentEncoding(withAllowedCharacters: chars)!;
    }
    
    
    // MARK: -WKNavigationDelegate
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url:URL! = navigationAction.request.url;
        //Inspect URL scheme
        let scheme = url.scheme;
        if (scheme?.contains("inmo") ?? false) {
            //Handle here
            if (url.host == "qr-code") {
                self.performSegue(withIdentifier: "capture-qr-code", sender: self);
            } else if (url.host == "log-out") {
                Context.current.logOut();
            }
            decisionHandler(.cancel);
            return;
        }
        decisionHandler(.allow);
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        let javascript = "var meta = document.createElement('meta');meta.setAttribute('name', 'viewport');meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no');document.getElementsByTagName('head')[0].appendChild(meta)";
        webView.evaluateJavaScript(javascript, completionHandler: nil);
    }
    
    
    //MARK: - QRViewControllerDelegate Members
    func qrViewController(_ controller: QRViewController, didScan result: String) {
        webView.evaluateJavaScript("qrRespond('" + result + "')", completionHandler: nil);
    }
    
    func qrViewController(didCancel controller: QRViewController) {
        
    }
    
    //MARK: - Context Delegate Members
    
    func context(_ session: Context, loginDidFail error: Error) {
        
    }
    
    func context(_ session: Context, didUpdateAuthorization authorization: Authorization) {
        self.authorization = authorization;
    }
    
    func context(_ session: Context, loginDidSucceed user: User) {
        self.initWebView();
    }
    
    func context(_ session: Context, refreshDidSucceed user: User) {
        self.initWebView();
    }
    
    func context(_ session: Context, userDidLogout user: User) {
        
    }
}
