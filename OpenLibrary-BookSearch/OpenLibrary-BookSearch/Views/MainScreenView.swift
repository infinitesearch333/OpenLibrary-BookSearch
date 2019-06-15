//
//  MainScreenView.swift
//  OpenLibrary-BookSearch
//
//  Created by Sergio Rosendo on 6/15/19.
//  Copyright © 2019 Sergio Rosendo. All rights reserved.
//

import UIKit

class MainScreenView: UIViewController, MainScreenPresenterDelegate {
    // User interface elements
    @IBOutlet weak var currentTabIndicator: UIImageView!
    @IBOutlet weak var bookSearchButton: UIButton!
    @IBOutlet weak var wishlistButton: UIButton!
    @IBOutlet weak var bookSearchBar: UISearchBar!
    @IBOutlet weak var bookList: UITableView!
    @IBOutlet weak var imageMessage: UIImageView!
    @IBOutlet weak var message: UILabel!
    
    // View internal elements
    let presenter = MainScreenPresenter()
    
    
    // Inital view setup
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.delegate = self
    }
    
    // User initiated events
    @IBAction func userSelectedTab(_ sender: UIButton) {
        if let selectedTab = AppState(rawValue: sender.titleLabel!.text!) {
            presenter.changeAppState(to: selectedTab)
        }
    }
}

// Function calls from presenter
extension MainScreenView {
    func updateTopBar(moveIndicatorToThe direction: Direction) {
        switch direction {
        case .Right:
            UIView.animateKeyframes(withDuration: 1.3, delay: 0, options: .calculationModeCubic, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.3, animations: {
                    let translationY = -self.bookSearchBar.frame.height
                    
                    self.bookSearchBar.transform = CGAffineTransform(translationX: 0, y: translationY)
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 1.0, animations: {
                    let x = self.wishlistButton.frame.midX - (self.currentTabIndicator.frame.width / 2)
                    let y = self.currentTabIndicator.frame.origin.y
                    
                    self.currentTabIndicator.frame.origin = CGPoint(x: x, y: y)
                })
            }, completion: { (_) in
                self.bookSearchBar.text?.removeAll()
            })
        
        case .Left:
            UIView.animateKeyframes(withDuration: 1.3, delay: 0, options: .calculationModeCubic, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1.0, animations: {
                    let x = self.bookSearchButton.frame.midX - (self.currentTabIndicator.frame.width / 2)
                    let y = self.currentTabIndicator.frame.origin.y
                    
                    self.currentTabIndicator.frame.origin = CGPoint(x: x, y: y)
                })
                
                UIView.addKeyframe(withRelativeStartTime: 1.0, relativeDuration: 0.3, animations: {
                    self.bookSearchBar.transform = CGAffineTransform(translationX: 0, y: 0)
                })
            })
        }
    }
    
    func updateMainArea(withImage image: ImageMessage, withMessage message: Message) {
        DispatchQueue.main.async {
            self.bookList.isHidden = true
            self.imageMessage.image = UIImage(named: image.rawValue)
            self.message.text = message.rawValue
        }
    }
}
