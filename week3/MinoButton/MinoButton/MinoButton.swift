//
//  MinoButton.swift
//  MinoButton
//
//  Created by 오민호 on 2017. 7. 17..
//  Copyright © 2017년 BoostCamp. All rights reserved.
//

import UIKit

/* 좋아요! Dictionary의 key로 사용하려면 Hashable 프로토콜을 준수해야하죠. 왜 그럴까요? */
extension UIControlState: Hashable {
    public var hashValue: Int {
        return Int(self.rawValue)
    }
}

@IBDesignable
class MinoButton : UIView {
    //MARK:- backgroundImageView Set up
    private lazy var backgroundImageView: UIImageView? = {
        var backgroundImageView = UIImageView()
        self.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        return backgroundImageView
    }()
    
    open var titleLabel: UILabel?
    
    open var backgroundImage: UIImage? {
        didSet {
            updateBackgroundImageView(backgroundImage!)
        }
    }
    
    private var currentState = UIControlState.normal {
        didSet {
            updateButtonByCurrentState()
        }
    }
    
    open var isEnabled : Bool = true {
        didSet {
            updateUserInteractionAndAlpha()
        }
    }
    
    open func title(for state: UIControlState) -> String? {
        return self.titleLabel?.text
    }
    
    private var stateStringDictionary = [UIControlState : String]()
    private var stateColorDictionary = [UIControlState : UIColor]()
    private var actionsOfTarget = [NSObject : Set<Selector>]()
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpLabel()
    }
    
    //MARK:- titlLabel Set up
    private func setUpLabel() {
        /* backgroundImageView와 다르게 여기서 생성해주는 이유가 따로 있을까요? */
        self.titleLabel = UILabel()
        self.addSubview(titleLabel!)
        titleLabel?.textAlignment = .center
        titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleLabel?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleLabel?.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1).isActive = true
        titleLabel?.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1).isActive = true
    }

    open func updateUserInteractionAndAlpha() {
        self.isUserInteractionEnabled = self.isEnabled
        if !(self.isEnabled) {
            self.alpha = 0.5
        }
        else {self.alpha = 1}
    }
    
    open func backgroundImage(for state : UIControlState)-> UIImage? {
        return backgroundImageView?.image
    }
    
    open func setBackgroundImage(image : UIImage?, for: UIControlState) {
        self.backgroundImageView?.image = image
    }
    
    open func setTitle(title: String, for state: UIControlState) {
        stateStringDictionary[state] = title
        updateButtonByCurrentState()
    }
    
    func setTitleColor(_ color: UIColor?, for state: UIControlState) {
        stateColorDictionary[state] = color
        updateButtonByCurrentState()
    }
    
    private func updateButtonByCurrentState() {
        updateTitleString()
        updateTitleColor()
    }
    
    private func updateTitleString() {
        for (state, title) in stateStringDictionary {
            if currentState == state {
                titleLabel?.text = title
                break
            }
        }
    }
    
    private func updateTitleColor() {
        for (state, color) in stateColorDictionary {
            if currentState == state {
                titleLabel?.textColor = color
                break
            }
        }
    }
    
    open func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents) {
        if target == nil {
            let target = self.next?.target(forAction: action, withSender: self)
            UIApplication.shared.sendAction(action, to: target, from: self, for: nil)
            return
        }
        guard let target = target as? NSObject else { return }
        
        /* 권장하는 바는 아니지만 if var 도 사용할 수 있습니다 */
        if var targetAction = actionsOfTarget[target] {
            targetAction.insert(action)
            return
        }
        actionsOfTarget[target] = [action]
    }
    
    private func updateBackgroundImageView(_ image: UIImage) {
        backgroundImageView?.image = image
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentState == .selected {
            currentState = currentState.union(.highlighted)
            return
        }
        currentState = .highlighted
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        performActions()
        if currentState == UIControlState.selected.union(.highlighted) {
            currentState = .normal
            return
        }
        currentState = .selected
    }

    private func performActions() {
        for (target, selectors) in actionsOfTarget {
            for selector in selectors {
                target.perform(selector, with: self)
            }
        }
    }
}
