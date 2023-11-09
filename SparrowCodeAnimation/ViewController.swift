//
//  ViewController.swift
//  SparrowCodeAnimation
//
//  Created by Юрий Степанчук on 09.11.2023.
//

import UIKit

final class ViewController: UIViewController {

    private lazy var squareView: UIView = {
        let squareView = UIView()
        squareView.translatesAutoresizingMaskIntoConstraints = false
        squareView.backgroundColor = .systemBlue
        squareView.layer.cornerRadius = 10
        return squareView
    }()

    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderInteractionEnded), for: .touchUpInside)
        return slider
    }()

    private lazy var animator: UIViewPropertyAnimator = {
        let animator = UIViewPropertyAnimator(duration: 0, curve: .linear) { [self, squareView] in
            let screenWidth = UIScreen.main.bounds.size.width
            let squareViewWidth = squareView.frame.size.width
            let marginsWidth = view.layoutMargins.right + view.layoutMargins.left
            let newXCoordinate = screenWidth - squareViewWidth - marginsWidth

            squareView.frame.origin.x = newXCoordinate
            squareView.transform = CGAffineTransform(rotationAngle: .pi / 2).scaledBy(x: 1.5, y: 1.5)
        }
        animator.pausesOnCompletion = true
        return animator
    }()

    deinit {
        animator.pausesOnCompletion = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.addSubview(squareView)
        view.addSubview(slider)

        let guide = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            squareView.widthAnchor.constraint(equalToConstant: 75),
            squareView.heightAnchor.constraint(equalToConstant: 75),
            squareView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            squareView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 30),

            slider.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            slider.topAnchor.constraint(equalTo: squareView.bottomAnchor, constant: 30),
            slider.trailingAnchor.constraint(equalTo: guide.trailingAnchor)
        ])
    }

    @objc private func sliderValueChanged(_ sender: UISlider) {
        animator.fractionComplete = CGFloat(sender.value)
    }

    @objc private func sliderInteractionEnded() {
        animator.startAnimation()
        slider.setValue(1, animated: true)
    }
}
