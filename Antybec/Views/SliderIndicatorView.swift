//
//  SliderIndicatorView.swift
//  Antybec
//
//  Created by Wiktor Biruk on 04/04/2019.
//  Copyright © 2019 Wiktor Biruk. All rights reserved.
//

import UIKit

@IBDesignable
class SliderIndicatorView: NibLoadableView {

    // MARK - Outlets
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var scaleIndicator: UIView!
    @IBOutlet private weak var currentLevelMarker: UIView!
    @IBOutlet private weak var topLevelMarker: UIView!
    @IBOutlet private weak var bottomLevelMarker: UIView!

    private var scaleLevel: CGFloat {
        return scaleIndicator.bounds.height
    }

    override func onInit() {
        super.onInit()
    }

    func configure(withViewModel viewModel: SliderIndicatorViewModel) {
        descriptionLabel.text = viewModel.indicatorDescription
        let size = topLevelMarker.frame.size
        let x = (bounds.size.width - topLevelMarker.bounds.size.width) / 2
        UIView.animate(withDuration: 0.1) {
            self.topLevelMarker.frame = CGRect(origin: CGPoint(x: x, y: self.scaleLevel * CGFloat(1 - viewModel.topLevelValue)), size: size)
            self.bottomLevelMarker.frame = CGRect(origin: CGPoint(x: x, y: self.scaleLevel * CGFloat(1 - viewModel.bottomLevelValue)), size: size)
            self.currentLevelMarker.frame = CGRect(origin: CGPoint(x: x, y: self.scaleLevel * CGFloat(1 - viewModel.initialLevelValue)), size: size)
        }
        print("")
    }

    func setCurrentLevel(_ currentLevel: Double) {
        if currentLevel > 1.0 {
            setCurrentLevel(1.0)
            return
        }

        if currentLevel < 0.0 {
            setCurrentLevel(0.0)
            return
        }

        let size = currentLevelMarker.frame.size
        let x = (bounds.size.width - currentLevelMarker.bounds.size.width) / 2
        UIView.animate(withDuration: 1.0/(3*Constants.frequency)) {
            self.currentLevelMarker.frame = CGRect(origin: CGPoint(x: x,
                                                                   y: self.scaleLevel * CGFloat(1 - currentLevel)),
                                                   size: size)
        }
    }

    func setState(_ state: WalkState) {
        switch state {
        case .normal:
            scaleIndicator.backgroundColor = Colors.defaultIndicator
        case .warning:
            scaleIndicator.backgroundColor = Colors.defaultIndicator
        case .critical:
            scaleIndicator.backgroundColor = Colors.alternativeIndicator
        }
    }    
}

