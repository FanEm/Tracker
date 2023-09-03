//
//  OnboardingPage.swift
//  Tracker
//


// MARK: - OnboardingPage
enum OnboardingPage {

    static let first = OnboardingViewController(
        image: .Onboarding.background1,
        text: "Track only what you want".localized()
    )

    static let second = OnboardingViewController(
        image: .Onboarding.background2,
        text: "Even if it's not liters of water and yoga".localized()
    )

}
