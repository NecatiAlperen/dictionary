//
//  LoadingView.swift
//  Dictionary
//
//  Created by Necati Alperen IŞIK on 8.06.2024.
//



import UIKit

class LoadingView {
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    static let shared = LoadingView()
    var blurView: UIVisualEffectView = UIVisualEffectView()

    private init() {
        configure()
    }

    func configure() {
        blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.frame = UIWindow(frame: UIScreen.main.bounds).frame
        activityIndicator.center = blurView.center
        activityIndicator.hidesWhenStopped = true
        blurView.contentView.addSubview(activityIndicator)
    }

    func startLoading() {
        UIApplication.shared.windows.first?.addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
    }

    func hideLoading() {
        DispatchQueue.main.async {
            self.blurView.removeFromSuperview()
            self.activityIndicator.stopAnimating()
        }
    }
}
