import XCTest
@testable import DomainModel

class JobTests: XCTestCase {
  
    func testCreateSalaryJob() {
        let job = Job(title: "Guest Lecturer", type: Job.JobType.Salary(1000))
        XCTAssert(job.calculateIncome(50) == 1000)
        XCTAssert(job.calculateIncome(100) == 1000)
        // Salary jobs pay the same no matter how many hours you work
    }

    func testCreateHourlyJob() {
        let job = Job(title: "Janitor", type: Job.JobType.Hourly(15.0))
        XCTAssert(job.calculateIncome(10) == 150)
        XCTAssert(job.calculateIncome(20) == 300)
    }

    func testSalariedRaise() {
        let job = Job(title: "Guest Lecturer", type: Job.JobType.Salary(1000))
        XCTAssert(job.calculateIncome(50) == 1000)

        job.raise(byAmount: 1000)
        XCTAssert(job.calculateIncome(50) == 2000)

        job.raise(byPercent: 0.1)
        XCTAssert(job.calculateIncome(50) == 2200)
    }

    func testHourlyRaise() {
        let job = Job(title: "Janitor", type: Job.JobType.Hourly(15.0))
        XCTAssert(job.calculateIncome(10) == 150)

        job.raise(byAmount: 1.0)
        XCTAssert(job.calculateIncome(10) == 160)

        job.raise(byPercent: 1.0) // Nice raise, bruh
        XCTAssert(job.calculateIncome(10) == 320)
    }
    
    //extra credit tests

    func testNegativeHourlyIncome() {
        let hourlyJob = Job(title: "Backwards Janitor", type: Job.JobType.Hourly(-20))
        XCTAssertEqual(hourlyJob.calculateIncome(10), -200)
    }
    
    func testNegativeHourlyIncomeLarge() {
        let hourlyJob = Job(title: "Debt", type: Job.JobType.Hourly(-1000))
        XCTAssertEqual(hourlyJob.calculateIncome(10), -10000)
    }

    func testZeroIncomeSalary() {

        let salaryJob = Job(title: "Unpaid Lecturer", type: Job.JobType.Salary(0))
        XCTAssertEqual(salaryJob.calculateIncome(40), 0)
    }

    func testZeroIncomeHourly() {
        let hourlyJob = Job(title: "Volunteer Worker", type: Job.JobType.Hourly(0))
        XCTAssertEqual(hourlyJob.calculateIncome(10), 0)
    }

  
    static var allTests = [
        ("testCreateSalaryJob", testCreateSalaryJob),
        ("testCreateHourlyJob", testCreateHourlyJob),
        ("testSalariedRaise", testSalariedRaise),
        ("testHourlyRaise", testHourlyRaise),
        ("testNegativeHourlyIncome", testNegativeHourlyIncome),
        ("testZeroIncomeSalary", testZeroIncomeSalary),
        ("testZeroIncomeHourly", testZeroIncomeHourly),
        ("testNegativeHourlyIncomeLarge", testNegativeHourlyIncomeLarge),
    ]

}
