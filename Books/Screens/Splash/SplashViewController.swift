//
//  SplashViewController.swift
//  StartProjectsMVVM + C
//
//  Created by Konstantin Chukhas on 20.11.2023.
//

import UIKit

class SplashViewController: UIViewController {
    
    @IBOutlet weak var progress: UIProgressView!
    
    var viewModel: SplashViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.startProgressBar()
        }
    }
   
    func startProgressBar() {
        var progress: Float = 0.0
        let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] timer in
            progress += 0.25
            self?.progress.setProgress(progress, animated: true)

            if progress >= 1.0 {
                timer.invalidate()
                self?.transitionToMainScreen()
            }
        }
        timer.fire()
    }
    
    func transitionToMainScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.viewModel.route(to: .main)
        })
    }
    
    deinit {
        print("SplashViewController - deinit")
    }
}
