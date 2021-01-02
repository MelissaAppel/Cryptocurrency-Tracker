//
//  ViewController.swift
//  CryptoCurrency Tracker
//
//  Created by Melissa Appel on 1/1/21.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CurrencyManagerDelegate {
   
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var selectedCurrencyLabel: UILabel!
    @IBOutlet weak var cryptoCurrencyPicker: UIPickerView!
    
    var currencyManager = CurrencyManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //This controller is the datasource for currencySelector
        cryptoCurrencyPicker.dataSource = self
        //Set this controller as the delegate of currencySelector
        cryptoCurrencyPicker.delegate = self
        currencyManager.delegate = self
    }
    
    //number of columns for cryptoCurrencyPicker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //number of rows for cryptoCurrencyPicker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyManager.cryptocurrencies.count
    }
    
    //populate each row of cryptoCurrencyPicker with element from currencyManager.cryptocurrencies
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyManager.cryptocurrencies[row]
    }
    
    //Return selected currency to CurrencyManager and update selectedCurrencyLabel
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let pickedCurrency = currencyManager.cryptocurrencies[row]
        currencyManager.getSelectedCurrency(currency : pickedCurrency)
        selectedCurrencyLabel.text = currencyManager.longNames[row]
        return NSAttributedString(string: pickedCurrency, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func updatePrice(currentRate: String){
        DispatchQueue.main.async {
                    self.rateLabel.text = currentRate
                }
    }
    
    func failedError(error: Error){
        print(error)
    }
    
}

