//
//  UIView+Constraints.swift
//  ImageWalkTracker
//
//  Created by Valentina Iancu on 12.02.2023.
//

import UIKit

extension UIView {
    
    func constrainToParent(margin: CGFloat = 0, priority: UILayoutPriority = .required) {
        constrainToParentVertically(margin: margin, priority: priority)
        constrainToParentHorizontally(margin: margin, priority: priority)
    }

    func constrainToParentVertically(margin: CGFloat = 0, priority: UILayoutPriority = .required) {
        pinTopToParent(margin: margin, priority: priority)
        pinBottomToParent(margin: margin, priority: priority)
    }

    func constrainToParentHorizontally(margin: CGFloat = 0, priority: UILayoutPriority = .required) {
        pinLeadingToParent(margin: margin, priority: priority)
        pinTrailingToParent(margin: margin, priority: priority)
    }
    
    func pinTopToParent(margin: CGFloat = 0, priority: UILayoutPriority = .required) {
        translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = topAnchor.constraint(equalTo: superview!.topAnchor, constant: margin)
        topConstraint.priority = priority
        topConstraint.isActive = true
    }

    func pinBottomToParent(margin: CGFloat = 0, priority: UILayoutPriority = .required) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = bottomAnchor.constraint(equalTo: superview!.bottomAnchor, constant: -margin)
        constraint.priority = priority
        constraint.isActive = true
    }
    
    func pinLeadingToParent(margin: CGFloat = 0, priority: UILayoutPriority = .required) {
        translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = leadingAnchor.constraint(equalTo: superview!.leadingAnchor, constant: margin)
        leadingConstraint.priority = priority
        leadingConstraint.isActive = true
    }
    
    func pinTrailingToParent(margin: CGFloat = 0, priority: UILayoutPriority = .required) {
        translatesAutoresizingMaskIntoConstraints = false
        let trailingConstraint = trailingAnchor.constraint(equalTo: superview!.trailingAnchor, constant: -margin)
        trailingConstraint.priority = priority
        trailingConstraint.isActive = true
    }

    func pinTopToBottom(of view: UIView,
                        margin: CGFloat = 0,
                        priority: UILayoutPriority = .required) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = topAnchor.constraint(equalTo: view.bottomAnchor, constant: margin)
        constraint.priority = priority
        constraint.isActive = true
    }
    
    func setupHeightConstraint(_ value: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: value).isActive = true
    }
}
