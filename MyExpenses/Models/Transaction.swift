//
//  Transaction.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 07.06.2025.
//

import Foundation

struct Transaction: Codable {
    let id: Int
    let accountId: Int
    let categoryId: Int
    let amount: String
    let transactionDate: String?
    let createdAt: String
    let updatedAt: String
}


extension Transaction {
    
    var jsonObject: Any {
        ["id": id,
         "accountId": accountId,
         "categoryId": categoryId,
         "amount": amount,
         "transactionDate": transactionDate as Any,
         "createdAt": createdAt,
         "updatedAt": updatedAt
        ]
    }
    
    static func parse(jsonObject: Any) -> Transaction? {
        guard let dict = jsonObject as? [String: Any] else { return nil }
        
        guard let id = dict["id"] as? Int else { return nil }
        guard let accountId = dict["accountId"] as? Int else { return nil }
        guard let categoryId = dict["categoryId"] as? Int else { return nil }
        guard let amount = dict["amount"] as? String else { return nil }
        guard let transactionDate = dict["transactionDate"] as? String else { return nil }
        guard let createdAt = dict["createdAt"] as? String else { return nil }
        guard let updatedAt = dict["updatedAt"] as? String else { return nil }
        
        let transaction: Transaction? = Transaction(id: id, accountId: accountId, categoryId: categoryId, amount: amount, transactionDate: transactionDate, createdAt: createdAt, updatedAt: updatedAt)
        
        return transaction
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
