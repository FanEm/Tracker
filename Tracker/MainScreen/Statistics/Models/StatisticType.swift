//
//  StatisticType.swift
//  Tracker
//


// MARK: - StatisticType
enum StatisticType: Int {
    case bestPeriod
    case perfectDays
    case completed
    case average

    var title: String {
        switch self {
        case .completed: return L.Statistics.completed
        case .bestPeriod: return L.Statistics.bestPeriod
        case .average: return L.Statistics.average
        case .perfectDays: return L.Statistics.perfectDays
        }
    }
}
