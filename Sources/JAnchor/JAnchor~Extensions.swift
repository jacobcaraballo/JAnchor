//
//  File.swift
//  
//
//  Created by Jacob Caraballo on 2/25/20.
//

import Foundation

#if os(macOS)
import Cocoa
#else
import UIKit
#endif


// JView Array anchor additions
extension Array where Element: JView {
	
	func anchor() -> JAnchor {
		return JAnchor(views: self)
	}
	
	func anchor(to view: JView) -> JAnchor {
		return JAnchor(views: self, anchors: Array<JView>(repeating: view, count: self.count))
	}
	
	func anchor(to views: [JView]) -> JAnchor {
		return JAnchor(views: self, anchors: views)
	}
	
	func anchor(to views: [JView], usesSafeArea: Bool) -> JAnchor {
		return JAnchor(views: self, anchors: views, anchorUsesSafeLayout: usesSafeArea)
	}
	
}



// JView anchor additions
extension JView {
	
	func anchor() -> JAnchor {
		return JAnchor(view: self)
	}
	
	func anchor(to view: JView) -> JAnchor {
		return JAnchor(view: self, anchor: view)
	}
	
	func anchor(to view: JView, usesSafeArea: Bool) -> JAnchor {
		return JAnchor(view: self, anchor: view, anchorUsesSafeLayout: usesSafeArea)
	}
	
}
