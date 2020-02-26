//
//  File.swift
//  
//
//  Created by Jacob Caraballo on 2/25/20.
//

import Foundation
import UIKit


// UIView Array anchor additions
extension Array where Element: UIView {
	
	func anchor() -> JAnchor {
		return JAnchor(views: self)
	}
	
	func anchor(to view: UIView) -> JAnchor {
		return JAnchor(views: self, anchors: Array<UIView>(repeating: view, count: self.count))
	}
	
	func anchor(to views: [UIView]) -> JAnchor {
		return JAnchor(views: self, anchors: views)
	}
	
	func anchor(to views: [UIView], usesSafeArea: Bool) -> JAnchor {
		return JAnchor(views: self, anchors: views, anchorUsesSafeLayout: usesSafeArea)
	}
	
}



// UIView anchor additions
extension UIView {
	
	func anchor() -> JAnchor {
		return JAnchor(view: self)
	}
	
	func anchor(to view: UIView) -> JAnchor {
		return JAnchor(view: self, anchor: view)
	}
	
	func anchor(to view: UIView, usesSafeArea: Bool) -> JAnchor {
		return JAnchor(view: self, anchor: view, anchorUsesSafeLayout: usesSafeArea)
	}
	
}
