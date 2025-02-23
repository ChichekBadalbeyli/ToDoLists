//
//  BaseFuction.swift
//  ToDoList
//
//  Created by Chichek on 18.02.25.
//

import UIKit

extension UIView {
    
    func anchor(
        top: NSLayoutYAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        leading: NSLayoutXAxisAnchor? = nil,
        trailing: NSLayoutXAxisAnchor? = nil,
        constraint: (top: CGFloat, bottom: CGFloat, leading: CGFloat, trailing: CGFloat)? = nil,
        width: CGFloat? = nil,
        height: CGFloat? = nil
    ) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints: [NSLayoutConstraint] = []
        
        if let top = top, let topConstant = constraint?.top {
            constraints.append(self.topAnchor.constraint(equalTo: top, constant: topConstant))
        }
        if let bottom = bottom, let bottomConstant = constraint?.bottom {
            constraints.append(self.bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }
        if let leading = leading, let leadingConstant = constraint?.leading {
            constraints.append(self.leadingAnchor.constraint(equalTo: leading, constant: leadingConstant))
        }
        if let trailing = trailing, let trailingConstant = constraint?.trailing {
            constraints.append(self.trailingAnchor.constraint(equalTo: trailing, constant: -trailingConstant))
        }
        if let width = width {
            constraints.append(self.widthAnchor.constraint(equalToConstant: width))
        }
        if let height = height {
            constraints.append(self.heightAnchor.constraint(equalToConstant: height))
        }
        
        NSLayoutConstraint.activate(constraints)
    }
}



