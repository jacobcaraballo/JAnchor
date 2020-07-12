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
	
	public func anchor() -> JAnchor {
		return JAnchor(views: self)
	}
	
	public func anchor(to view: JView) -> JAnchor {
		return JAnchor(views: self, anchors: Array<JView>(repeating: view, count: self.count))
	}
	
	public func anchor(to views: [JView]) -> JAnchor {
		return JAnchor(views: self, anchors: views)
	}
	
	public func anchor(to views: [JView], usesSafeArea: Bool) -> JAnchor {
		return JAnchor(views: self, anchors: views, anchorUsesSafeLayout: usesSafeArea)
	}
	
}



// JView anchor additions
extension JView {
	
	public func anchor() -> JAnchor {
		return JAnchor(view: self)
	}
	
	public func anchor(to view: JView) -> JAnchor {
		return JAnchor(view: self, anchor: view)
	}
	
	public func anchor(to view: JView, usesSafeArea: Bool) -> JAnchor {
		return JAnchor(view: self, anchor: view, anchorUsesSafeLayout: usesSafeArea)
	}
	
}
