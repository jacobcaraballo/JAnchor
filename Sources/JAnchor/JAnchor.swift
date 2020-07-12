//
//  JAnchor.swift
//  JAnchor
//
//  Created by Jacob Caraballo on 1/20/20.
//  Copyright © 2020 Jacob Caraballo. All rights reserved.
//

import Foundation

#if os(macOS)
import Cocoa
public typealias JView = NSView
#else
import UIKit
public typealias JView = UIView
#endif



public final class JAnchor {
	
	fileprivate class JAnchorView {
		let view: JView
		var constraints = [JAnchorKey: NSLayoutConstraint]()
		
		init(_ view: JView) {
			self.view = view
		}
	}
	
	private var views = [JView: JAnchorView]()
	private let safe: Bool
	
	public init(view: JView, anchor: JView = JView(), anchorUsesSafeLayout: Bool = false) {
		view.translatesAutoresizingMaskIntoConstraints = false
		self.views = [view: JAnchorView(anchor)]
		self.safe = anchorUsesSafeLayout
	}
	
	public init(views: [JView], anchors: [JView] = [], anchorUsesSafeLayout: Bool = false) {
		
		self.safe = anchorUsesSafeLayout
		
		for (i, view) in views.enumerated() {
			view.translatesAutoresizingMaskIntoConstraints = false
			let anchor = i < anchors.count ? anchors[i] : JView()
			self.views[view] = JAnchorView(anchor)
		}
		
	}
	
	private func activate(_ constraint: NSLayoutConstraint, for key: JAnchorKey, on view: JView) {
		
		// deactivate constraint if it already exists
		if let existingConstraint = views[view]?.constraints[key] {
			existingConstraint.isActive = false
		}
		
		
		// activate new constraint
		constraint.isActive = true
		views[view]?.constraints[key] = constraint
		
	}
	
	public func get(for key: JAnchorKey, in view: JView! = nil) -> NSLayoutConstraint {
		if let view = view { return views[view]!.constraints[key]! }
		return views.first!.value.constraints[key]!
	}
	
	public func getAll(in view: JView! = nil) -> [JAnchorKey: NSLayoutConstraint] {
		if let view = view { return views[view]!.constraints }
		return views.first!.value.constraints
	}
	
	public func getAll(for key: JAnchorKey) -> [NSLayoutConstraint] {
		var constraints = [NSLayoutConstraint]()
		for (_, anchor) in views {
			if let constraint = anchor.constraints[key] {
				constraints.append(constraint)
			}
		}
		return constraints
	}
	
}



// Simplify interchanging UIView / NSView
#if os(macOS)
extension JView {
	var safeAreaLayoutGuide: JView { return self }
}
#endif


// Enums
extension JAnchor {
	
	fileprivate enum JAnchorPositionXY {
		case topLeft, topCenter, topRight
		case centerLeft, center, centerRight
		case bottomLeft, bottomCenter, bottomRight
	}
	
	public enum JAnchorKey {
		case width, height
		
		case left, leftToCenter, leftToRight
		case centerToLeft, centerX, centerToRight
		case rightToLeft, rightToCenter, right
		
		case top, topToCenter, topToBottom
		case centerToTop, centerY, centerToBottom
		case bottomToTop, bottomToCenter, bottom
		
		fileprivate static func x(from position: JAnchorPositionXY) -> JAnchorKey {
			
			switch position {
				
			case .topLeft, .centerLeft, .bottomLeft: return .left
			case .topCenter, .center, .bottomCenter: return .centerX
			case .topRight, .centerRight, .bottomRight: return .right
				
			}
			
		}
		
		fileprivate static func y(from position: JAnchorPositionXY) -> JAnchorKey {
			
			switch position {
				
			case .topLeft, .topCenter, .topRight: return .top
			case .centerLeft, .center, .centerRight: return .centerY
			case .bottomLeft, .bottomCenter, .bottomRight: return .bottom
				
			}
			
		}
		
	}
	
}


// Sizing
extension JAnchor {
	
	@discardableResult
	public func width(multiplier: CGFloat, offset: CGFloat) -> JAnchor {
		for (view, anchor) in views {
			let constraint = view.widthAnchor.constraint(equalTo: safe ? anchor.view.safeAreaLayoutGuide.widthAnchor : anchor.view.widthAnchor, multiplier: multiplier, constant: offset)
			activate(constraint, for: .width, on: view)
		}
		
		return self
	}
	
	@discardableResult
	public func width() -> JAnchor {
		return width(multiplier: 1, offset: 0)
	}
	
	@discardableResult
	public func width(multiplier: CGFloat) -> JAnchor {
		return width(multiplier: multiplier, offset: 0)
	}
	
	@discardableResult
	public func width(offset: CGFloat) -> JAnchor {
		return width(multiplier: 1, offset: offset)
	}
	
	@discardableResult
	public func width(constant: CGFloat) -> JAnchor {
		for (view, _) in views {
			activate(view.widthAnchor.constraint(equalToConstant: constant), for: .width, on: view)
		}
		return self
	}
	
	@discardableResult
	public func height(constant: CGFloat) -> JAnchor {
		for (view, _) in views {
			activate(view.heightAnchor.constraint(equalToConstant: constant), for: .height, on: view)
		}
		return self
	}
	
	@discardableResult
	public func height(multiplier: CGFloat, offset: CGFloat) -> JAnchor {
		for (view, anchor) in views {
			activate(view.heightAnchor.constraint(equalTo: safe ? anchor.view.safeAreaLayoutGuide.heightAnchor : anchor.view.heightAnchor, multiplier: multiplier, constant: offset), for: .height, on: view)
		}
		return self
	}
	
	@discardableResult
	public func height() -> JAnchor {
		return height(multiplier: 1, offset: 0)
	}
	
	@discardableResult
	public func height(multiplier: CGFloat) -> JAnchor {
		return height(multiplier: multiplier, offset: 0)
	}
	
	@discardableResult
	public func height(offset: CGFloat) -> JAnchor {
		return height(multiplier: 1, offset: offset)
	}
	
	@discardableResult
	public func widthToHeight(multiplier: CGFloat, offset: CGFloat) -> JAnchor {
		for (view, anchor) in views {
			let constraint = view.widthAnchor.constraint(equalTo: safe ? anchor.view.safeAreaLayoutGuide.heightAnchor : anchor.view.heightAnchor, multiplier: multiplier, constant: offset)
			activate(constraint, for: .width, on: view)
		}
		
		return self
	}
	
	@discardableResult
	public func heightToWidth(multiplier: CGFloat, offset: CGFloat) -> JAnchor {
		for (view, anchor) in views {
			let constraint = view.heightAnchor.constraint(equalTo: safe ? anchor.view.safeAreaLayoutGuide.widthAnchor : anchor.view.widthAnchor, multiplier: multiplier, constant: offset)
			activate(constraint, for: .height, on: view)
		}
		
		return self
	}
	
	@discardableResult
	public func widthToHeight(multiplier: CGFloat) -> JAnchor {
		return widthToHeight(multiplier: multiplier, offset: 0)
	}
	
	@discardableResult
	public func heightToWidth(multiplier: CGFloat) -> JAnchor {
		return heightToWidth(multiplier: multiplier, offset: 0)
	}
	
	@discardableResult
	public func widthToHeight(offset: CGFloat) -> JAnchor {
		return widthToHeight(multiplier: 1, offset: offset)
	}
	
	@discardableResult
	public func heightToWidth(offset: CGFloat) -> JAnchor {
		return heightToWidth(multiplier: 1, offset: offset)
	}
	
	@discardableResult
	public func widthToHeight() -> JAnchor {
		return widthToHeight(multiplier: 1, offset: 0)
	}
	
	@discardableResult
	public func heightToWidth() -> JAnchor {
		return heightToWidth(multiplier: 1, offset: 0)
	}
	
	@discardableResult
	public func size(multiplier: CGFloat = 1, offset: CGFloat = 0) -> JAnchor {
		return width(multiplier: multiplier, offset: offset).height(multiplier: multiplier, offset: offset)
	}
	
	@discardableResult
	public func size(constant: CGFloat) -> JAnchor {
		return width(constant: constant).height(constant: constant)
	}
	
}



// Positioning
extension JAnchor {
	
	@discardableResult
	public func frame() -> JAnchor {
		return size().center()
	}
	
	@discardableResult
	public func center(xOffset: CGFloat = 0, yOffset: CGFloat = 0) -> JAnchor {
		return centerX(xOffset).centerY(yOffset)
	}
	
	@discardableResult
	public func centerX(_ offset: CGFloat = 0) -> JAnchor {
		for (view, anchor) in views {
			activate(view.centerXAnchor.constraint(equalTo: anchor.view.centerXAnchor, constant: offset), for: .centerX, on: view)
		}
		return self
	}
	
	@discardableResult
	public func centerY(_ offset: CGFloat = 0) -> JAnchor {
		for (view, anchor) in views {
			activate(view.centerYAnchor.constraint(equalTo: anchor.view.centerYAnchor, constant: offset), for: .centerY, on: view)
		}
		return self
	}
	
	@discardableResult
	private func xy(_ position: JAnchorPositionXY, xOffset: CGFloat = 0, yOffset: CGFloat = 0) -> JAnchor {
		
		let xPos = JAnchorKey.x(from: position)
		let yPos = JAnchorKey.y(from: position)
		
		return x(xPos, offset: xOffset).y(yPos, offset: yOffset)
		
	}
	
	@discardableResult
	private func x(_ position: JAnchorKey, offset: CGFloat = 0) -> JAnchor {
		for (view, anchor) in views {
			activate(getXAnchor(of: view, for: position).constraint(equalTo: getXAnchor(of: anchor.view, for: position, safe: safe, isAnchor: true), constant: offset), for: position, on: view)
		}
		return self
	}
	
	@discardableResult
	private func y(_ position: JAnchorKey, offset: CGFloat = 0) -> JAnchor {
		for (view, anchor) in views {
			activate(getYAnchor(of: view, for: position).constraint(equalTo: getYAnchor(of: anchor.view, for: position, safe: safe, isAnchor: true), constant: offset), for: position, on: view)
		}
		return self
	}
	
	@discardableResult
	public func stackLeftToRight(spacing: CGFloat = 0) -> JAnchor {
		var previousView: JView?
		for (view, anchor) in views {
			if let previousView = previousView {
				view.anchor(to: previousView).leftToRight(offset: spacing)
			} else {
				view.anchor(to: anchor.view).left(offset: 0)
			}
			previousView = view
		}
		return self
	}
	
	@discardableResult
	public func stackRightToLeft(spacing: CGFloat = 0) -> JAnchor {
		var previousView: JView?
		for (view, anchor) in views {
			if let previousView = previousView {
				view.anchor(to: previousView).rightToLeft(offset: spacing)
			} else {
				view.anchor(to: anchor.view).right(offset: 0)
			}
			previousView = view
		}
		return self
	}
	
	@discardableResult
	public func stackTopToBottom(spacing: CGFloat = 0) -> JAnchor {
		var previousView: JView?
		for (view, anchor) in views {
			if let previousView = previousView {
				view.anchor(to: previousView).topToBottom(offset: spacing)
			} else {
				view.anchor(to: anchor.view).top(offset: 0)
			}
			previousView = view
		}
		return self
	}
	
	@discardableResult
	public func stackBottomToTop(spacing: CGFloat = 0) -> JAnchor {
		var previousView: JView?
		for (view, anchor) in views {
			if let previousView = previousView {
				view.anchor(to: previousView).bottomToTop(offset: spacing)
			} else {
				view.anchor(to: anchor.view).bottom(offset: 0)
			}
			previousView = view
		}
		return self
	}
	
	@discardableResult
	public func topLeft(xOffset: CGFloat = 0, yOffset: CGFloat = 0) -> JAnchor {
		return xy(.topLeft, xOffset: xOffset, yOffset: yOffset)
	}
	
	@discardableResult
	public func topCenter(xOffset: CGFloat = 0, yOffset: CGFloat = 0) -> JAnchor {
		return xy(.topCenter, xOffset: xOffset, yOffset: yOffset)
	}
	
	@discardableResult
	public func topRight(xOffset: CGFloat = 0, yOffset: CGFloat = 0) -> JAnchor {
		return xy(.topRight, xOffset: xOffset, yOffset: yOffset)
	}
	
	@discardableResult
	public func centerLeft(xOffset: CGFloat = 0, yOffset: CGFloat = 0) -> JAnchor {
		return xy(.centerLeft, xOffset: xOffset, yOffset: yOffset)
	}
	
	@discardableResult
	public func centerRight(xOffset: CGFloat = 0, yOffset: CGFloat = 0) -> JAnchor {
		return xy(.centerRight, xOffset: xOffset, yOffset: yOffset)
	}
	
	@discardableResult
	public func bottomLeft(xOffset: CGFloat = 0, yOffset: CGFloat = 0) -> JAnchor {
		return xy(.bottomLeft, xOffset: xOffset, yOffset: yOffset)
	}
	
	@discardableResult
	public func bottomCenter(xOffset: CGFloat = 0, yOffset: CGFloat = 0) -> JAnchor {
		return xy(.bottomCenter, xOffset: xOffset, yOffset: yOffset)
	}
	
	@discardableResult
	public func bottomRight(xOffset: CGFloat = 0, yOffset: CGFloat = 0) -> JAnchor {
		return xy(.bottomRight, xOffset: xOffset, yOffset: yOffset)
	}
	
	@discardableResult
	public func left(offset: CGFloat = 0) -> JAnchor {
		return x(.left, offset: offset)
	}
	
	@discardableResult
	public func right(offset: CGFloat = 0) -> JAnchor {
		return x(.right, offset: offset)
	}
	
	@discardableResult
	public func top(offset: CGFloat = 0) -> JAnchor {
		return y(.top, offset: offset)
	}
	
	@discardableResult
	public func bottom(offset: CGFloat = 0) -> JAnchor {
		return y(.bottom, offset: offset)
	}
	
	@discardableResult
	public func bottomToTop(offset: CGFloat = 0) -> JAnchor {
		return y(.bottomToTop, offset: offset)
	}
	
	@discardableResult
	public func bottomToCenter(offset: CGFloat = 0) -> JAnchor {
		return y(.bottomToCenter, offset: offset)
	}
	
	@discardableResult
	public func centerToTop(offset: CGFloat = 0) -> JAnchor {
		return y(.centerToTop, offset: offset)
	}
	
	@discardableResult
	public func centerToBottom(offset: CGFloat = 0) -> JAnchor {
		return y(.centerToBottom, offset: offset)
	}
	
	@discardableResult
	public func topToCenter(offset: CGFloat = 0) -> JAnchor {
		return y(.topToCenter, offset: offset)
	}
	
	@discardableResult
	public func topToBottom(offset: CGFloat = 0) -> JAnchor {
		return y(.topToBottom, offset: offset)
	}
	
	@discardableResult
	public func leftToCenter(offset: CGFloat = 0) -> JAnchor {
		return x(.leftToCenter, offset: offset)
	}
	
	@discardableResult
	public func leftToRight(offset: CGFloat = 0) -> JAnchor {
		return x(.leftToRight, offset: offset)
	}
	
	@discardableResult
	public func centerToLeft(offset: CGFloat = 0) -> JAnchor {
		return x(.centerToLeft, offset: offset)
	}
	
	@discardableResult
	public func centerToRight(offset: CGFloat = 0) -> JAnchor {
		return x(.centerToRight, offset: offset)
	}
	
	@discardableResult
	public func rightToLeft(offset: CGFloat = 0) -> JAnchor {
		return x(.rightToLeft, offset: offset)
	}
	
	@discardableResult
	public func rightToCenter(offset: CGFloat = 0) -> JAnchor {
		return x(.rightToCenter, offset: offset)
	}
	
}



// Getters
extension JAnchor {
	
	
	private func getXAnchor(of view: JView, for position: JAnchorKey, safe: Bool = false, isAnchor: Bool = false) -> NSLayoutXAxisAnchor {
		
		if isAnchor {
			switch position {
			case .left, .centerToLeft, .rightToLeft:
				return safe ? view.safeAreaLayoutGuide.leadingAnchor : view.leadingAnchor
				
			case .centerX, .leftToCenter, .rightToCenter:
				return safe ? view.safeAreaLayoutGuide.centerXAnchor : view.centerXAnchor
				
			case .right, .leftToRight, .centerToRight:
				return safe ? view.safeAreaLayoutGuide.trailingAnchor : view.trailingAnchor
			default:
				break
			}
		} else {
			switch position {
				
			case .left, .leftToCenter, .leftToRight:
				return safe ? view.safeAreaLayoutGuide.leadingAnchor : view.leadingAnchor
				
			case .centerX, .centerToLeft, .centerToRight:
				return safe ? view.safeAreaLayoutGuide.centerXAnchor : view.centerXAnchor
				
			case .right, .rightToLeft, .rightToCenter:
				return safe ? view.safeAreaLayoutGuide.trailingAnchor : view.trailingAnchor
			default:
				break
				
			}
		}
		
		return NSLayoutXAxisAnchor()
		
	}
	
	private func getYAnchor(of view: JView, for position: JAnchorKey, safe: Bool = false, isAnchor: Bool = false) -> NSLayoutYAxisAnchor {
		
		if isAnchor {
			
			switch position {
				
			case .top, .centerToTop, .bottomToTop:
				return safe ? view.safeAreaLayoutGuide.topAnchor : view.topAnchor
				
			case .centerY, .topToCenter, .bottomToCenter:
				return safe ? view.safeAreaLayoutGuide.centerYAnchor : view.centerYAnchor
				
			case .bottom, .topToBottom, .centerToBottom:
				return safe ? view.safeAreaLayoutGuide.bottomAnchor : view.bottomAnchor
				
			default:
				break
				
			}
			
		} else {
			
			switch position {
				
			case .top, .topToCenter, .topToBottom:
				return safe ? view.safeAreaLayoutGuide.topAnchor : view.topAnchor
				
			case .centerY, .centerToTop, .centerToBottom:
				return safe ? view.safeAreaLayoutGuide.centerYAnchor : view.centerYAnchor
				
			case .bottom, .bottomToTop, .bottomToCenter:
				return safe ? view.safeAreaLayoutGuide.bottomAnchor : view.bottomAnchor
				
			default:
				break
				
			}
			
		}
		
		return NSLayoutYAxisAnchor()
		
	}
	
	
}
