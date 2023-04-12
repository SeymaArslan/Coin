//
//  CoinYonetim.swift
//  Coin
//
//  Created by Seyma on 6.04.2023.
//

import Foundation

protocol CoinYonetimDelegate {
    func didUpdateCoin (fiyat: String, birim: String)
    func didFailWithError(error: Error) // varsa hata dışarı aktarabilmek için bir metot daha oluşturuyoruz.
}

struct CoinYonetim{
    var delegate: CoinYonetimDelegate?
    
    let gitURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "8872F66A-0C5A-4E4D-924A-1C02E8A24D14"
    
    let birimArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
 
    func coinFiyatAl(for birim: String){
        let urlString = "\(gitURL)/\(birim)?apikey=\(apiKey)"
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
//                    print(error!)
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
//                let donusumString = String(data: data!, encoding: .utf8)
//                print(donusumString!)
                if let safeData = data {
//                    let coinFiyat = self.parseJSON(safeData)
                    if let coinFiyat = self.parseJSON(safeData) {
                        let fiyatString = String(format: "%.2f", coinFiyat)
                        self.delegate?.didUpdateCoin(fiyat: fiyatString, birim: birim)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let sonFiyat = decodedData.rate
//            print(sonFiyat)
            return sonFiyat
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
