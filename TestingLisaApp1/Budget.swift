//
//  Budget.swift
//  TestingLisaApp1
//
//  Created by Jeremy Lumban Toruan on 26/03/25.
//
import Foundation

struct Budget {
    var amount: Double
    var timeframe: Timeframe
}

enum Timeframe: String, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
}
