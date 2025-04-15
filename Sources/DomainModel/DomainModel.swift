struct DomainModel {
    var text = "Hello, World!"
    // Leave this here; this value is also tested in the tests,
    // and serves to make sure that everything is working correctly
    // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    let amount: Int
    let currency: String

    private static let validCurrencies: Set<String> = ["USD", "GBP", "EUR", "CAN"]

    init(amount: Int, currency: String) {
        guard Money.validCurrencies.contains(currency) else {
            fatalError("Unsupported currency: \(currency)")
        }
        self.amount = amount
        self.currency = currency
    }

    func convert(_ toCurrency: String) -> Money {
        guard Money.validCurrencies.contains(toCurrency) else {
            fatalError("Unsupported target currency: \(toCurrency)")
        }

        let convertedAmount = Money.convertAmount(amount, from: currency, to: toCurrency)
        return Money(amount: convertedAmount, currency: toCurrency)
    }

    func add(_ other: Money) -> Money {
        let convertedOther = other.convert(self.currency)
        return Money(amount: self.amount + convertedOther.amount, currency: self.currency)
    }

    func subtract(_ other: Money) -> Money {
        let convertedOther = other.convert(self.currency)
        return Money(amount: self.amount - convertedOther.amount, currency: self.currency)
    }

    private static func convertAmount(_ value: Int, from: String, to: String) -> Int {
        
        let toUSD: [String: Double] = [
            "USD": 1.0,
            "GBP": 2.0,
            "EUR": 2.0 / 3.0,
            "CAN": 0.8
        ]
        let fromUSD: [String: Double] = [
            "USD": 1.0,
            "GBP": 0.5,
            "EUR": 1.5,
            "CAN": 1.25
        ]

        let usdValue = Double(value) * (toUSD[from] ?? 1.0)
        let finalValue = usdValue * (fromUSD[to] ?? 1.0)

        return Int((finalValue))
    }
}

////////////////////////////////////
// Job
//
public class Job {
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }

    var title: String
    var type: JobType

    public init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }

    public func calculateIncome(_ hoursWorked: Int) -> Int {
        switch type {
        case .Hourly(let hourlyRate):
            return Int(hourlyRate * Double(hoursWorked))
        case .Salary(let salaryAmount):
            return Int(salaryAmount)
        }
    }

    public func raise(byAmount amount: Double) {
        switch type {
        case .Hourly(let hourlyRate):
            self.type = .Hourly(hourlyRate + amount)
        case .Salary(let salaryAmount):
            self.type = .Salary(salaryAmount + UInt(amount))
        }
    }

    public func raise(byPercent percent: Double) {
        switch type {
        case .Hourly(let hourlyRate):
            self.type = .Hourly(hourlyRate * (1 + percent))
        case .Salary(let salaryAmount):
            self.type = .Salary(UInt(Double(salaryAmount) * (1 + percent / 100)))
        }
    }
}



////////////////////////////////////
// Person
//
public class Person {
    var firstName: String
    var lastName: String
    var age: Int
    var job: Job?
    var spouse: Person?

    public init(firstName: String, lastName: String, age: Int, job: Job? = nil, spouse: Person? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.job = job
        self.spouse = spouse
    }

    public func toString() -> String {
        let jobString = job.map { "\($0.type)" } ?? "None"
        let spouseString = spouse?.firstName ?? "None"
        return "[Person: firstName: \(firstName) lastName: \(lastName) age: \(age) job: \(jobString) spouse: \(spouseString)]"
    }
}


////////////////////////////////////
// Family
//
public class Family {
    var members: [Person]

    public init(spouse1: Person, spouse2: Person) {
        guard spouse1.spouse == nil && spouse2.spouse == nil else {
            fatalError("Both spouses must be unmarried to create a family.")
        }

        spouse1.spouse = spouse2
        spouse2.spouse = spouse1

        self.members = [spouse1, spouse2]
    }

    public func haveChild(_ child: Person) -> Bool {
        guard members[0].age > 21 || members[1].age > 21 else {
            return false
        }

        members.append(child)
        return true
    }

    public func householdIncome() -> Int {
        var totalIncome = 0

        for member in members {
            if member.age >= 18, let job = member.job {
                totalIncome += job.calculateIncome(2000)
            }
        }

        return totalIncome
    }
}
