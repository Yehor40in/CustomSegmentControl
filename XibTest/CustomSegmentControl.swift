//
//  MyView.swift
//  XibTest
//
//  Created by Yehor Sorokin on 1/15/20.
//  Copyright © 2020 Yehor Sorokin. All rights reserved.
//

import UIKit

enum GradienDirection {
    case vertical
    case horizontal
}

protocol CustomSegmentControlDelegate: class {
    func customSegmentControl(_ segmentControl: CustomSegmentControl, didChangeValue value: Int) -> Void
}

@IBDesignable
class CustomSegmentControl: UIView {
    // MARK: - Outlets
    @IBOutlet var contentView: UIView!
    
    // MARK: - Private properties
    @objc private var highlightLayer: CAGradientLayer = CAGradientLayer()
    private var cornerRadius: CGFloat = 30
    private var animationDuration: TimeInterval = 0.5
    private var highlightSize: CGSize {
        CGSize(width: bounds.width / CGFloat(optionsCount), height: bounds.height)
    }
    private var defaultFrame: CGRect {
        getDestinationFrame(for: 0)
    }
    private var currentFrame: CGRect {
        getDestinationFrame(for: currentIndex)
    }
    private var currentGradient: [CGColor] {
        getGradients()[currentIndex]
    }
    private var gradientDirection: GradienDirection = .horizontal
    private var labels: [UILabel] = []
    // MARK: - Public properties
    var value: Int = 0
    weak var delegate: CustomSegmentControlDelegate?
    
    // MARK: - Inspectable properties
    @IBInspectable var currentIndex: Int = 0
    @IBInspectable var optionsCount: Int = 3
    @IBInspectable var titles: [String] = ["first", "second", "third"]
    @IBInspectable var fontSize: CGFloat = 20
    
    // MARK: - Initialization
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        Bundle(for: CustomSegmentControl.self).loadNibNamed("MyView", owner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        setupHighlightLayer()
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
    }
    
    // MARK: - Private methods
    private func getHighlightPath() -> UIBezierPath {
        return UIBezierPath(roundedRect: highlightLayer.bounds, cornerRadius: cornerRadius)
    }
    
    private func setUpTitles() {
        for (index, title) in titles.enumerated() {
            let label = UILabel()
            label.text = title
            label.textAlignment = .center
            
            let stringRect = getDestinationFrame(for: index)
            label.frame = stringRect
            
            if index == currentIndex { label.textColor = UIColor.white }
            else { label.textColor = UIColor.black }
            labels.append(label)
            addSubview(label)
        }
    }
    
    private func setupHighlightLayer() {
        highlightLayer.frame = defaultFrame
        highlightLayer.cornerRadius = cornerRadius
        highlightLayer.colors = getGradients().first
        setGradientDirection()
        contentView.layer.addSublayer(highlightLayer)
    }
    
    private func getGradients() -> [[CGColor]] {
        return [
            [UIColor.red.cgColor, UIColor.yellow.cgColor],
            [UIColor.green.cgColor, UIColor.blue.cgColor],
            [UIColor.purple.cgColor, UIColor.magenta.cgColor]
        ]
    }
    
    private func gradientFor(index: Int) -> [CGColor] {
        guard index < optionsCount else {
            return currentGradient
        }
        return getGradients()[index]
    }
    
    private func setGradientDirection() {
        highlightLayer.startPoint = CGPoint(x: 0, y: 0)
        highlightLayer.endPoint = CGPoint(x: 1, y: 1)
    }
    
    private func animatedHighlight(to index: Int) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(animationDuration)
        
        unHighlight(at: currentIndex)
        currentIndex = index
        highlightLayer.frame = getDestinationFrame(for: index)
        highlightLayer.colors = gradientFor(index: index)
        highlightTitle(at: index)
        
        CATransaction.commit()
        
        value = index
        delegate?.customSegmentControl(self, didChangeValue: value)
    }
    
    private func getDestinationFrame(for index: Int) -> CGRect {
        guard index < optionsCount else {
            return currentFrame
        }
        let X = CGFloat(index) * highlightSize.width
        return CGRect(origin: CGPoint(x: X, y: 0), size: highlightSize)
    }
    
    private func highlightTitle(at index: Int) {
        labels[index].textColor = UIColor.white
    }
    
    private func unHighlight(at index: Int) {
        labels[index].textColor = UIColor.black
    }
    
    // MARK: - Public methods
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        UIColor.lightGray.setFill()
        path.fill()
        setUpTitles()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        highlightLayer.removeAllAnimations()
    }
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: self)
        let index = Int(location.x / highlightSize.width)
        animatedHighlight(to: index)
    }

}
