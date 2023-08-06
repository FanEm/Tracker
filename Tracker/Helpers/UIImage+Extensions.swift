//
//  UIImage+Extensions.swift
//  Tracker
//

import UIKit

extension UIImage {
    enum Trackers {
        static var addTracker: UIImage { UIImage(named: "add_tracker_icon") ?? UIImage() }
        static var nothingToShow: UIImage { UIImage(named: "nothing_to_show_icon") ?? UIImage() }
        static var plusButton: UIImage { UIImage(named: "tracker_plus_button") ?? UIImage() }
        static var minusButton: UIImage { UIImage(named: "tracker_minus_button") ?? UIImage() }
        // TODO: кривая иконка - нужно перезалить новую, когда поправят
        static var doneButton: UIImage { UIImage(named: "tracker_done_button") ?? UIImage() }
    }
    
    enum Tabbar {
        static var statistics: UIImage { UIImage(named: "statistics_tabbar_icon") ?? UIImage() }
        static var trackers: UIImage { UIImage(named: "trackers_tabbar_icon") ?? UIImage() }
    }
    
    enum Statistics {
        static var nothingToShow: UIImage { UIImage(named: "statistics_nothing_to_show_icon") ?? UIImage() }
    }

    enum CreateTracker {
        enum Category {
            enum NewCategory {
                static var nothingToShow: UIImage { UIImage(named: "nothing_to_show_icon") ?? UIImage() }
            }
        }
    }
}
