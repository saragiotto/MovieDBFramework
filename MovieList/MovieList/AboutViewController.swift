//
//  AboutViewController.swift
//  MovieList
//
//  Created by Leonardo Saragiotto on 3/5/17.
//  Copyright © 2017 Leonardo Saragiotto. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var contactEmail: UILabel!
    @IBOutlet weak var movieDBAttr: UIImageView!
    
    @IBAction func closeAboutScreen(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.movieDBAttr.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(AboutViewController.openWebsite)))
        
        self.contactEmail.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(AboutViewController.sendEmail)))
        
        self.contactEmail.textColor = UIColor.flatYellowColorDark()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func openWebsite() {
        
        let website = "https://www.themoviedb.org/"
        UIApplication.shared.open(URL.init(string: website)!, options: [:], completionHandler: nil)
        
        return
    }
    
    public func sendEmail() {
        
        if let url = URL(string: "mailto:\(contactEmail.text!)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
        return
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
