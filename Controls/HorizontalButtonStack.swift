//
//  HorizontalButtonStack.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 08/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit

fileprivate let underlineHeight: CGFloat = 2.0
fileprivate let totalButtonPadding: CGFloat = 20.0

protocol HorizontalButtonStackDataSource: class {
    func numberOfButtons() -> Int
    func buttonForIndex(_ index: Int) -> UIButton
}

protocol HorizontalButtonStackDelegate: class {
    func didTapButton(_ index: Int)
}

@IBDesignable
class HorizontalButtonStack: UIScrollView {
    
    //MARK: - Properties
    private lazy var buttonArray = [UIButton]()
    
    weak var _dataSource: HorizontalButtonStackDataSource? {
        didSet {
            reload()
        }
    }
    
    weak var _delegate: HorizontalButtonStackDelegate?
    
    private var underlineView: UIView?
    
    //MARK: - IBInspectables
    @IBInspectable var defaultIndex = 0 {
        didSet {
            didSelectDefaultIndex()
        }
    }
    
    @IBInspectable var _defaultIndex = 0
    
    @IBInspectable var baseColor: UIColor?
    @IBInspectable var buttonTextColor: UIColor?
    @IBInspectable var font: UIFont?
    
    //MARK: - init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        super.layoutSubviews()
    }
    
    func reload() {
        guard let _ds = _dataSource else { return }
        
        let _ = subviews.map { $0.removeFromSuperview() }
        
        var x: CGFloat = 0.0
        let y: CGFloat = 0.0
        let height: CGFloat = frame.height
        
        for i in 0 ..< _ds.numberOfButtons() {
            let button = _ds.buttonForIndex(i)
            button.setTitleColor(buttonTextColor, for: .normal)
            button.titleLabel?.font = font
            button.sizeToFit()
            button.frame = CGRect(x: x, y: y, width: button.frame.width + totalButtonPadding, height: height)
            button.tag = i
            button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            addSubview(button)
            buttonArray.append(button)
            
            x = x + button.frame.width
        }
        
        let width: CGFloat = x
        contentSize = CGSize(width: width, height: height)
        
        if buttonArray.count == 0 {
            return
        }
        
        if _defaultIndex >= buttonArray.count {
            _defaultIndex = 0
        }
        
        let button = buttonArray[_defaultIndex]
        button.setTitleColor(baseColor, for: .normal)
        underlineView = UIView(frame: CGRect(x: button.frame.origin.x, y: height - underlineHeight, width: button.frame.size.width, height: underlineHeight))
        underlineView!.backgroundColor = baseColor
        addSubview(underlineView!)
        
        scrollToView(view: button, animated: false)
    }
}

extension HorizontalButtonStack {
    private func didSelectDefaultIndex() {
        guard let _ = _dataSource else {
            fatalError("You should confirm to datasaource first")
        }
        
        guard defaultIndex < buttonArray.count else {
            fatalError("Default index out of range")
        }
        
        let _ = buttonArray.map { $0.setTitleColor(buttonTextColor, for: .normal) }
        let button = buttonArray[defaultIndex]
        button.setTitleColor(baseColor, for: .normal)
        underlineView?.frame = CGRect(x: button.frame.origin.x, y: frame.height - underlineHeight, width: button.frame.size.width, height: underlineHeight)
        scrollToView(view: button, animated: true)
        
        _delegate?.didTapButton(button.tag)
    }
    
    @objc func buttonAction(_ sender: UIButton) {
        let _ = buttonArray.map { $0.setTitleColor(buttonTextColor, for: .normal) }
        sender.setTitleColor(baseColor, for: .normal)
        underlineView?.frame = CGRect(x: sender.frame.origin.x, y: frame.height - underlineHeight, width: sender.frame.size.width, height: underlineHeight)
        scrollToView(view: sender, animated: true)
        
        _delegate?.didTapButton(sender.tag)
    }
}
