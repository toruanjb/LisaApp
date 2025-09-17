//
//  Budget.swift
//  TestingLisaApp1
//
//  Created by Jeremy Lumban Toruan on 26/03/25.
//
import Foundation

struct Budget: Codable {
    var amount: Double
    var timeframe: Timeframe
}

enum Timeframe: String, CaseIterable, Codable {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
}
