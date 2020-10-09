//
//  Array+Difference.swift
//  tasks-client
//
//  Created by milkyway on 09.10.2020.
//

import Foundation

extension Array where Element: Hashable {
	func difference(from other: [Element]) -> [Element] {
		let thisSet = Set(self)
		let otherSet = Set(other)
		return Array(thisSet.symmetricDifference(otherSet))
	}
}
