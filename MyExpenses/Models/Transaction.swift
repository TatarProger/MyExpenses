//
//  Transaction.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 07.06.2025.
//

import Foundation

struct Transaction: Decodable {
    let id: Int
    let account: AccountBrief
    let category: Category
    let amount: Decimal
    let transactionDate: Date?
    let comment: String?
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id, account, category, amount, transactionDate, comment, createdAt, updatedAt
    }
    
    init(id: Int, account: AccountBrief, category: Category, amount: Decimal, transactionDate: Date?, comment: String?, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.account = account
        self.category = category
        self.amount = amount
        self.transactionDate = transactionDate
        self.comment = comment
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        account = try container.decode(AccountBrief.self, forKey: .account)
        category = try container.decode(Category.self, forKey: .category)
        comment = try container.decodeIfPresent(String.self, forKey: .comment)
        let amountString = try container.decode(String.self, forKey: .amount)
        guard let decimalAmount = Decimal(string: amountString) else {
            throw DecodingError.dataCorruptedError(forKey: .amount, in: container, debugDescription: "amount string is not a valid Decimal")
        }
        
        amount = decimalAmount
        
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let transactionDateString = try container.decode(String.self, forKey: .transactionDate)
        guard let transactionDateDate = dateFormatter.date(from: transactionDateString) else {
            throw DecodingError.dataCorruptedError(forKey: .transactionDate, in: container, debugDescription: "transactionDate string does not match format expected by formatter")
        }
        
        transactionDate = transactionDateDate
        
        let createdAtString = try container.decode(String.self, forKey: .createdAt)
        guard let createdAtDate = dateFormatter.date(from: createdAtString) else {
            throw DecodingError.dataCorruptedError(forKey: .createdAt, in: container, debugDescription: "createdAtDate string does not match format expected by formatter")
        }
        
        createdAt = createdAtDate
        
        let updatedAtString = try container.decode(String.self, forKey: .updatedAt)
        guard let updatedAtDate = dateFormatter.date(from: updatedAtString) else {
            throw DecodingError.dataCorruptedError(
                forKey: .updatedAt,
                in: container,
                debugDescription: "Date string does not match format expected by formatter"
            )
        }
        updatedAt = updatedAtDate
    }
    
    
    
    
}


extension Transaction {
    
    var jsonObject: Any {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        return ["id" : id,
                "account": account,
                "category": category,
                "amount": amount,
                "transactionDate": formatter.string(from: transactionDate ?? Date()),
                "comment": comment ?? "",
                "createdAt": formatter.string(from: createdAt),
                "updatedAt": formatter.string(from: updatedAt)
        ]
    }
    
    static func parse(jsonObject: Any) -> Transaction? {
        guard let dict = jsonObject as? [String: Any] else { return nil }
        guard let id = dict["id"] as? Int else { return nil }
        guard let account = dict["account"] as? AccountBrief else { return nil }
        guard let category = dict["category"] as? Category else { return nil }
        guard let amount = dict["amount"] as? Decimal else { return nil }
        guard let transactionDate = dict["transactionDate"] as? Date else { return nil }
        guard let comment = dict["comment"] as? String else { return nil }
        guard let createdAt = dict["createdAt"] as? Date else { return nil }
        guard let updatedAt = dict["updatedAt"] as? Date else { return nil }
        
        let transaction: Transaction? = Transaction(id: id, account: account, category: category, amount: amount, transactionDate: transactionDate, comment: comment, createdAt: createdAt, updatedAt: updatedAt)
        
        
        
        return transaction
    }
}


//MARK: CSV convert
extension Transaction {
    init?(csvLine: String) {
        let components = csvLine.split(separator: ",", omittingEmptySubsequences: false).map { String($0) }

        guard components.count == 14 else {
            print("Неверное количество полей в строке CSV: \(components.count)")
            return nil
        }

        
        guard let id = Int(components[0]),
              let accId = Int(components[1]),
              let accBalance = Decimal(string: components[3]),
              let catId = Int(components[5]),
              let isIncome = Bool(components[8]),
              let amount = Decimal(string: components[9]) else {
            print("Ошибка приведения типов")
            return nil
        }

        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        guard let transactionDate = formatter.date(from: components[10]),
              let createdAt = formatter.date(from: components[12]),
              let updatedAt = formatter.date(from: components[13]) else {
            print("Ошибка парсинга дат")
            return nil
        }

        
        let account = AccountBrief(
            id: accId,
            name: components[2],
            balance: accBalance,
            currency: components[4]
        )

        
        let category = Category(
            id: catId,
            name: components[6],
            emoji: components[7].first ?? " ",
            income: isIncome ? .income : .outcome
        )

        let comment = components[11].isEmpty ? nil : components[11]

        self.init(
            id: id,
            account: account,
            category: category,
            amount: amount,
            transactionDate: transactionDate,
            comment: comment,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
      

    func convertCSV(from fileURL: URL) async throws -> [Transaction] {
        let (data, _) = try await URLSession.shared.data(from: fileURL)
        
        guard let content = String(data: data, encoding: .utf8) else {
            throw NSError(domain: "CSVParsing", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to decode CSV file as UTF-8 string."])
        }

        let lines = content
            .split(separator: "\n", omittingEmptySubsequences: true)
            .map(String.init)

        let transactions = lines.compactMap { Transaction(csvLine: $0) }
        return transactions
    }

}


    

class TransactionsFileCache {
    private (set) var transactions: [Transaction] = []
    
    func addTransaction(_ transaction: Transaction) {
        if transactions.contains(where: {$0.id == transaction.id}) {
            print("Такая траназакция с таким id уже существует")
            return
        }
        transactions.append(transaction)
    }
    
    func removeTransaction(_ id: Int) {
        transactions.removeAll(where:) {$0.id == id}
        }
    
    
    func saveJSON(jsonObject: Any, fileName: String) {
        guard let jsonFile = try? JSONSerialization.data(withJSONObject: jsonObject) else { return }
        
        let fileManger = FileManager.default
        
        guard let transactionsURL = fileManger.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Не удалось найти папку")
            return
        }
        
        let fileURL = transactionsURL.appendingPathComponent(fileName)
        
        do {
            try jsonFile.write(to: fileURL)
        }
        catch {
            print("Ошибка записи")
        }
        
    }
    
    func load(fileName: String) {
        let fileManager = FileManager.default
        
        guard let transactionURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Не удалось найти папку")
            return
        }
        
        let fileURL = transactionURL.appendingPathComponent(fileName)
        
        do {
            let data = try Data(contentsOf: fileURL)
            
            if let transactions = try? JSONSerialization.jsonObject(with: data) {
                self.transactions = transactions as? [Transaction] ?? []
            }
        } catch {
            print("Ошибка чтения")
            return
        }
    }
}
