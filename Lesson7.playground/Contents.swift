import UIKit
import Foundation


struct TicketShop{
    var priceTicket : Int
    var amountTicket : Int
    var countryPlanes : Airport
}

struct Airport{
    
    let name : String
}
class TicketPlanes{
    var base = [
        "Aeroflot" : TicketShop(priceTicket: 17000, amountTicket: 100, countryPlanes: Airport(name: "Russian")),
        "ATP" : TicketShop(priceTicket: 0, amountTicket: 100, countryPlanes: Airport(name: "Italy")),
        "S7" : TicketShop(priceTicket: 14000, amountTicket: 0, countryPlanes: Airport(name: "Ural")),
        "Boeing" : TicketShop(priceTicket: 23000, amountTicket: 200, countryPlanes: Airport(name: "USA"))
    ]
    var deposit = 0
    
    func ticket(itemName: String) -> Airport? {
        guard let item = base[itemName] else {return nil}
        guard item.amountTicket > 0 else {return nil}
        guard item.priceTicket <= deposit else {return nil}
        
        deposit -= item.priceTicket
        var changeItem = item
        changeItem.amountTicket -= 1
        base[itemName] = changeItem
        return changeItem.countryPlanes
 
    }
}

let klient = TicketPlanes()
klient.ticket(itemName: "Pobeda")
klient.ticket(itemName: "Aeroflot")
klient.ticket(itemName: "S7")
klient.ticket(itemName: "Boeing")
klient.ticket(itemName: "ATP")

enum TicketPlanesError: Error {
    case invalidProduct
    case soldOut
    case nomoney(coins: Int)
    
    
    var localized: String {
        switch self {
        case .invalidProduct:
            return "Данный рейс отсутсвует"
        case .soldOut:
            return "Нет в наличии"
        case .nomoney(coins: let coins):
            return "Нужно больше денег! Стоимость данного билета: \(coins)"
        }
    }
}
extension TicketPlanes {
    func ticketWithErrors(itemName: String) -> (product: Airport?, error: TicketPlanesError?) {
        
        guard let item = base[itemName] else {
            return (product: nil, error: .invalidProduct)
        }
        guard item.amountTicket > 0 else {
            return (product: nil, error: .soldOut)
        }
        guard item.priceTicket <= deposit else {
            return (product: nil, error: .nomoney(coins: item.priceTicket - deposit) )
        }
        
        deposit -= item.priceTicket
        var changeItem = item
       changeItem.amountTicket -= 1
        base[itemName] = changeItem
        print("Ваш билет до", changeItem.countryPlanes.name)
        return (product: changeItem.countryPlanes, error: nil)
    }
    
}
let klient2 = TicketPlanes()

let flight1 = klient2.ticketWithErrors(itemName: "Pobeda")
let flight2 = klient2.ticketWithErrors(itemName: "Aeroflot")
let flight3 = klient2.ticketWithErrors(itemName: "S7")
let flight4 = klient2.ticketWithErrors(itemName: "ATP")

var ticketToday = [flight1, flight2, flight3, flight4]
klient2.deposit = 14000

for sale in ticketToday {
    guard let product = sale.product else {
        guard let error = sale.error else {
            print("Error: unknown")
            continue
        }
        print("Error: ", error.localized.description)
        continue
    }
    print("Успешная операция! Билет до: ", product.name, "Куплен!")
}

enum TicketError: String,Error {
    case noTicket = "Sold out"
}

extension TicketPlanes {
    
    func TicketWithTry(itemName: String) throws -> Airport {
        
        guard let item = base[itemName] else {
            throw TicketPlanesError.invalidProduct
        }
        guard item.amountTicket > 0 else {
           
            throw TicketError.noTicket
        }
        guard item.priceTicket <= deposit else {
            throw TicketPlanesError.nomoney(coins: item.priceTicket - deposit)
        }
        
        deposit -= item.priceTicket
        var changeItem = item
        changeItem.amountTicket -= 1
        base[itemName] = changeItem
        print("Ваш билет до", changeItem.countryPlanes.name)
        return changeItem.countryPlanes
    }
}

let klient3 = TicketPlanes()

do {
    let flight5 = try klient3.TicketWithTry(itemName: "Pobeda")
    let flight6 = try klient3.TicketWithTry(itemName: "Aeroflot")
    print(flight5.name)
    print(flight6.name)
} catch let error {
    print(error.localizedDescription)
}
 

do {
    let flight5 = try klient3.TicketWithTry(itemName: "Pobeda")
    let flight6 = try klient3.TicketWithTry(itemName: "Aeroflot")
    print(flight5.name)
    print(flight6.name)
} catch _ as TicketError {
    print(TicketError.noTicket.rawValue)
} catch let error as TicketPlanesError {
    print(error.localized)
} catch {
    print(error.localizedDescription)
}

let klientTry1 = try? klient3.TicketWithTry(itemName: "Pobeda")

