//
//  StatBottomBarViewController.swift
//  Covid19App
//
//  Created by Hishara on 9/15/20.
//  Copyright © 2020 Hishara. All rights reserved.
//

import UIKit

class StatBottomBarViewController: UIViewController {
    
    var partialViewYPosition: CGFloat = 0
    @IBOutlet weak var viewStatRoot: UIView!
    @IBOutlet weak var viewTotalConfirmed: UIView!
    @IBOutlet weak var viewTotalPeople: UIView!
    @IBOutlet weak var viewNonInfected: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture))
        view.addGestureRecognizer(gesture)
        roundViews()
        
        let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 0
        
        partialViewYPosition = UIScreen.main.bounds.height - tabBarHeight - 160
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.6, animations: {
            self.moveView(state: .partial)
        })
    }
    
    private func moveView(state: State) {
        let yPosition = state == .partial ? partialViewYPosition : Constant.fullViewYPosition
        view.frame = CGRect(x: 0, y: yPosition, width: view.frame.width, height: view.frame.height)
    }
    

    private func moveView(panGestureRecognizer recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        let minY = view.frame.minY
        
        if (minY + translation.y >= Constant.fullViewYPosition) && (minY + translation.y <= partialViewYPosition) {
            view.frame = CGRect(x: 0, y: minY + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: view)
        }
    }
    
    @objc private func panGesture(_ recognizer: UIPanGestureRecognizer) {
        moveView(panGestureRecognizer: recognizer)
        
        if recognizer.state == .ended {
            UIView.animate(withDuration: 1, delay: 0.0, options: [.allowUserInteraction], animations: {
                let state: State = recognizer.velocity(in: self.view).y >= 0 ? .partial : .full
                self.moveView(state: state)
            }, completion: nil)
        }
    }
    
    func roundViews() {
        view.layer.cornerRadius = 40
        view.clipsToBounds = true
        viewStatRoot.clipsToBounds = true
        viewStatRoot.layer.cornerRadius = 10
        
        viewTotalConfirmed.clipsToBounds = true
        viewTotalConfirmed.layer.cornerRadius = 10
        
        viewTotalPeople.clipsToBounds = true
        viewTotalPeople.layer.cornerRadius = 10
        
        viewNonInfected.clipsToBounds = true
        viewNonInfected.layer.cornerRadius = 10
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension StatBottomBarViewController{
    
    private enum State {
        case partial
        case full
    }
    
    private enum Constant {
        static let fullViewYPosition: CGFloat = (UIScreen.main.bounds.height / 2) - 150
    }
}