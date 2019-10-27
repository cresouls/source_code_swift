//
//  Hud.swift
//  iQuotes
//
//  Created by Sreejith Ajithkumar on 11/10/18.
//  Copyright © 2018 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

class Hud: UIView, NibLoadable {
    
    //MARK: Instance Properties
    var contentView: UIView?
    var bgColor: UIColor?
    
    //MARK: IBOutlet
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.hidesWhenStopped = true
            activityIndicator.style = .white
        }
    }
    
    @IBOutlet weak var activityView: UIView!
    
    
    var hidesWhenStopped = true
    private var count = 0
    
    //MARK: Init
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        contentView = loadNib()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView = loadNib()
        layout()
    }
    
    convenience init(color: UIColor) {
        self.init(frame: .zero)
        contentView = loadNib()
        bgColor = color
        layout()
    }
}

//MARK: Functions
extension Hud {
    private func layout() {
        self.contentView?.backgroundColor = UIColor.clear

        if let color = bgColor {
            self.activityView.backgroundColor = color
        }
        self.activityView.layer.cornerRadius = 6.0
        self.activityView.layer.masksToBounds = true
    }
}

extension Hud {
    func start() {
        if count == 0 {
            self.frame = UIApplication.shared.keyWindow!.frame
            UIApplication.shared.keyWindow!.addSubview(self)
            
            activityIndicator.startAnimating()
        }
        count += count
    }
    
    func stop() {
        count -= count
        
        if count == 0 {
            activityIndicator.stopAnimating()
            self.removeFromSuperview()
        }
    }
}
