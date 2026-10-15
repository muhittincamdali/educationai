import Foundation
import Testing
@testable import EducationAI

struct StudyStreakTests {
    var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Europe/Istanbul")!
        return calendar
    }

    /// 2026-10-15 14:00 in Istanbul.
    var now: Date { calendar.date(from: DateComponents(year: 2026, month: 10, day: 15, hour: 14))! }

    func day(_ offset: Int, hour: Int = 9) -> Date {
        let start = calendar.date(byAdding: .day, value: -offset, to: calendar.startOfDay(for: now))!
        return start.addingTimeInterval(TimeInterval(hour) * 3_600)
    }

    @Test func countsConsecutiveDaysEndingToday() {
        let streak = StudyStreak(activityDates: [day(0), day(0, hour: 20), day(1), day(2), day(4)], now: now, calendar: calendar)
        #expect(streak.current == 3)
        #expect(streak.longest == 3)
        #expect(streak.studiedToday)
    }

    @Test func streakSurvivesUntilTodayEnds() {
        let streak = StudyStreak(activityDates: [day(1), day(2)], now: now, calendar: calendar)
        #expect(streak.current == 2)
        #expect(!streak.studiedToday)
    }

    @Test func aMissedDayBreaksTheStreakButNotTheRecord() {
        let dates = [day(2), day(3), day(5), day(6), day(7), day(8)]
        let streak = StudyStreak(activityDates: dates, now: now, calendar: calendar)
        #expect(streak.current == 0)
        #expect(streak.longest == 4)
    }

    @Test func daysFollowTheCalendarTimeZone() {
        // 23:50 and 00:10 Istanbul time are two days there but the same day in UTC.
        let lateYesterday = day(1, hour: 23).addingTimeInterval(50 * 60)
        let earlyToday = day(0).addingTimeInterval(-9 * 3_600 + 10 * 60)
        #expect(StudyStreak(activityDates: [lateYesterday, earlyToday], now: now, calendar: calendar).current == 2)
        var utc = Calendar(identifier: .gregorian)
        utc.timeZone = TimeZone(identifier: "UTC")!
        #expect(StudyStreak(activityDates: [lateYesterday, earlyToday], now: now, calendar: utc).current == 1)
    }

    @Test func ignoresFutureNonFiniteAndFarAwayDates() {
        let dates = [
            day(-1), Date(timeIntervalSinceReferenceDate: .nan), Date(timeIntervalSinceReferenceDate: .infinity),
            .distantPast, .distantFuture, Date(timeIntervalSinceReferenceDate: -1e300), day(0)
        ]
        let streak = StudyStreak(activityDates: dates, now: now, calendar: calendar)
        #expect(streak.current == 1)
        #expect(streak.longest == 1)
    }

    @Test func noActivityMeansNoStreak() {
        let streak = StudyStreak(activityDates: [], now: now, calendar: calendar)
        #expect(streak.current == 0)
        #expect(streak.longest == 0)
        #expect(!streak.studiedToday)
    }

    @Test func aYearOfDailyStudyAcrossDaylightSavingChanges() {
        let dates = (0..<365).map { day($0, hour: 12) }
        #expect(StudyStreak(activityDates: dates, now: now, calendar: calendar).current == 365)
        var berlin = Calendar(identifier: .gregorian)
        berlin.timeZone = TimeZone(identifier: "Europe/Berlin")!
        let berlinNow = berlin.date(from: DateComponents(year: 2026, month: 10, day: 26, hour: 12))!
        let berlinDates = (0..<60).map { berlin.date(byAdding: .day, value: -$0, to: berlinNow)! }
        #expect(StudyStreak(activityDates: berlinDates, now: berlinNow, calendar: berlin).current == 60)
    }
}
