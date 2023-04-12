//
//  ViewController.swift
//  Coin
//
//  Created by Seyma on 6.04.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var birimLabel: UILabel!
    @IBOutlet weak var birimPicker: UIPickerView!
    
    var coinYonetim = CoinYonetim()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinYonetim.delegate = self
        
        birimPicker.dataSource = self
        birimPicker.delegate = self
    }

}

//MARK: - CoinYonetimDelegate
extension ViewController: CoinYonetimDelegate {
    func didUpdateCoin (fiyat: String, birim: String){
        DispatchQueue.main.async {
            self.coinLabel.text = fiyat
            self.birimLabel.text = birim
        }
    }
    
    func didFailWithError(error: Error){
        print(error)
    }
}

//MARK: - CoinVeriCek
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1  // picker da kaç column olacağı
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinYonetim.birimArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinYonetim.birimArray[row]  // burada birim dizisini satır satır alıp picker da gösteriyoruz.
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {  // satır seçim işlemleri
        let secilenCoin = coinYonetim.birimArray[row]
        coinYonetim.coinFiyatAl(for: secilenCoin)
    }
}
