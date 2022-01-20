//
//  MflStatus.swift
//  PlayoffLeaderboard
//
//  Created by David Shilling on 1/19/22.
//

import Foundation

// MFL API object
struct MflStatusResponse: Codable {
    var mflStatus: MflStatus
}

struct MflStatus: Codable {
    var year: String
    var weeks: MflStatusWeeks
    init () {
        year = ""
        weeks = MflStatusWeeks()
    }
}

struct MflStatusWeeks: Codable {
    var UpcomingWeek: String
    var LineupWeek: String
    var LiveScoringWeek: String // If equal to completed week, don't add in live scoring to total scoring
    var CompletedWeek: String
    var CurrentWeek: String
    init () {
        UpcomingWeek = ""
        LineupWeek = ""
        LiveScoringWeek = ""
        CompletedWeek = ""
        CurrentWeek = ""
    }
}
