//
//  Array+Addition.swift
//
//  Created by Vicky Prajapati.
//

import Foundation

extension Array{
    // Credit card number text formatting
    func chunks(_ chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
    
    //Group by
    func group<U: Hashable>(by key: (Element) -> U) -> [[Element]] {
        //keeps track of what the integer index is per group item
        var indexKeys = [U : Int]()
        
        var grouped = [[Element]]()
        for element in self {
            let key = key(element)
            
            if let ind = indexKeys[key] {
                grouped[ind].append(element)
            }
            else {
                grouped.append([element])
                indexKeys[key] = grouped.count - 1
            }
        }
        return grouped
    }
    
    //Get Unique records
    func filterDuplicates(includeElement: @escaping (_ lhs: Element, _ rhs: Element) -> Bool) -> [Element] {
        
        var results = [Element]()
        
        forEach { (element) in
            
            let existingElements = results.filter {
                return includeElement(element, $0)
            }
            
            if existingElements.count == 0 {
                results.append(element)
            }
        }
        return results
    }
}
