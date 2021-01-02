//
//  CurrencyManager.swift
//  CryptoCurrency Tracker
//
//  Created by Melissa Appel on 1/1/21.
//

import Foundation

protocol CurrencyManagerDelegate {
    func updatePrice(currentRate: String)
    func failedError(error: Error)
}

struct CurrencyManager{
    var delegate : CurrencyManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/"
    let apiKey = "EE23CCF5-1191-4E3D-BC57-172BD56E7787"
    let cryptocurrencies = ["BTC" , "ETH", "USDT", "XRP", "LTC", "DOT", "BCH", "ADA", "BNB", "LINK"]
    let longNames = ["Bitcoin", "Ethereum", "Tether", "XRP", "Litecoin", "Polkadot", "Bitcoin Cash", "Cardano", "Binance Coin", "Chainlink"]
    
    func getSelectedCurrency(currency : String!){
        let urlString = baseURL+currency+"/USD?apikey="+apiKey
        
        if let url = URL(string: urlString) {
                    
                    let session = URLSession(configuration: .default)
                    let task = session.dataTask(with: url) { (data, response, error) in
                        if error != nil {
                            self.delegate?.failedError(error: error!)
                            return
                        }
                        
                        if let safeData = data {
                            
                            if let bitcoinPrice = self.getRateJSON(safeData) {
                                
                                //Optional: round the price down to 2 decimal places.
                                let priceString = String(format: "%.2f", bitcoinPrice)
                                
                                //Call the delegate method in the delegate (ViewController) and
                                //pass along the necessary data.
                                self.delegate?.updatePrice(currentRate: priceString)
                            }
                        }
                    }
                    task.resume()
                }
    }
    
    func getRateJSON(_ data: Data) -> Double?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CurrencyData.self, from: data)
            let currentPrice = decodedData.rate
            print(currentPrice)
            return currentPrice
        } catch {
            delegate?.failedError(error: error)
            return nil
        }
    }
}
