//
//  LoadableFromXib.swift
//  Antybec
//
//  Created by Wiktor Biruk on 04/04/2019.
//  Copyright © 2019 Wiktor Biruk. All rights reserved.
//

import UIKit

@IBDesignable public class NibLoadableView: UIView {

    @IBOutlet weak var contentView : UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.xibSetup()
        self.onInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.xibSetup()
        self.onInit()
    }

    convenience init() {
        self.init(frame: CGRect.zero)
    }

    func xibSetup() {
        self.contentView = self.loadViewFromNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(self.contentView)
    }

    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: type(of: self).nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }

    static var nibName: String {
        return String(describing: self)
    }

    func onInit() {
        // NOTE: to override
    }

}




