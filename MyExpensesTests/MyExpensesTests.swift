//
//  MyExpensesTests.swift
//  MyExpensesTests
//
//  Created by Rishat Zakirov on 08.06.2025.
//

import XCTest
@testable import MyExpenses

final class MyExpensesTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    

}

final class TransactionTests: XCTestCase {
    func testJsonObject() {
        let transaction = Transaction(id: 1, account: AccountBrief(id: 1, name: "Основной счет", balance: Decimal(1000.00), currency: "RUB"), category: Category(id: 1, name: "Питомцы", emoji: "🦁", income: .income), amount: Decimal(1000.00), transactionDate: ISO8601DateFormatter().date(from: "2004-06-11T00:00:00.000Z"), comment: "", createdAt: ISO8601DateFormatter().date(from: "2025-06-10T15:39:13.576Z") ?? Date(), updatedAt: ISO8601DateFormatter().date(from: "2025-06-10T15:39:13.576Z") ?? Date())
        
        guard let dict = transaction.jsonObject as? [String: Any] else {
            XCTFail("jsonObject не является словарём")
            return
        }
        
        XCTAssertEqual(dict["id"] as? Int, transaction.id)
        XCTAssertEqual(dict["account"] as? AccountBrief, transaction.account)
        XCTAssertEqual(dict["category"] as? MyExpenses.Category, transaction.category)
        XCTAssertEqual(dict["amount"] as? Decimal, transaction.amount)
        XCTAssertEqual(dict["transactionDate"] as? Date, transaction.transactionDate)
        XCTAssertEqual(dict["createdAt"] as? Date, transaction.createdAt)
        XCTAssertEqual(dict["updatedAt"] as? Date, transaction.updatedAt)
        
    }
    
    func testTransactionParse() {
        let json: [String: Any] = [
            "id": 1,
            "account": [
                "id": 1,
                "name": "Основной счёт",
                "balance": "1000.00",
                "currency": "RUB"
            ],
            "category": [
                "id": 1,
                "name": "Зарплата",
                "emoji": "💰",
                "isIncome": true
            ],
            "amount": "500.00",
            "transactionDate": "11.06.2004",
            "comment": "Зарплата за месяц",
            "createdAt": "11.06.2004",
            "updatedAt": "11.06.2004"
        ]

        
        let transaction = Transaction.parse(jsonObject: json)
        
        XCTAssertNotNil(transaction)
        XCTAssertEqual(transaction?.id, 1)
        XCTAssertEqual(transaction?.account, AccountBrief(id: 1, name: "Основной счёт", balance: Decimal(1000.00), currency: "RUB"))
        XCTAssertEqual(transaction?.category, Category(id: 1, name: "Зарплата", emoji: "💰", income: Direction.income))
        XCTAssertEqual(transaction?.amount, Decimal(1000.00))
        XCTAssertEqual(transaction?.transactionDate, ISO8601DateFormatter().date(from: "2004-06-11T00:00:00.000Z"))
        XCTAssertEqual(transaction?.createdAt, ISO8601DateFormatter().date(from: "2004-06-11T00:00:00.000Z"))
        XCTAssertEqual(transaction?.updatedAt, ISO8601DateFormatter().date(from: "2004-06-11T00:00:00.000Z"))
    }
}
