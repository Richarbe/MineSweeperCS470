//
//  ViewController.swift
//  MineSweeper
//
//  Created by AAK on 2/11/17.
//  Copyright © 2017 SSU. All rights reserved.
//
//Users/student/Desktop/MineSweeper/MineSweeper/Base.lproj/LaunchScreen.storyboard
import UIKit


class MinesweeperViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var inputErrorMessageLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var numRowsTextField: UITextField!
    @IBOutlet weak var numColumnsTextField: UITextField!

    var numberOfRows = 0
    var numberOfColumns = 0
    let maxNumberOfRows = 15
    let maxNumberOfColumns = 10
    let minNumberOfRows = 1
    let minNumberOfColumns = 1
    let gapBetweenTiles = 2.0
    var mineModel = MineSweeperModel()
    var widthOfATile = 0.0
    
    func makeButton(x: Double, y: Double, widthHeight: Double) -> UIButton {
        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: x, y: y, width: widthHeight, height: widthHeight)
        button.backgroundColor = UIColor.orange
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        //addTarget does same thing as ctrl drag from storyboard to controller.
        return button
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.alpha = 0
        numRowsTextField.delegate = self
        numColumnsTextField.delegate = self
        inputErrorMessageLabel.textColor = UIColor.orange

        
//        view.backgroundColor = UIColor.gray
        let mineView = MineView(frame: CGRect(x: 100, y: 100, width: 140, height: 140))
        mineView.backgroundColor = UIColor.white
//        view.addSubview(mineView)

//        let tiles = mineModel.startGameWith(rows: 10, columns: 10)
//        updateTiles(tiles: tiles)
 
        
/*
        
        for i in  0 ..< 10 {
            let button = makeButton(x: 15 + Double(i) * 27.0, y: 50.0)
            button.setTitle("\(i)", for: UIControlState.normal)
            button.tag = i
            view.addSubview(button)

        }
*/
        
    }

    
    func updateTiles(tiles: [[TileAttributes]]) {
        let frame = view.frame
        print(frame)
        widthOfATile = (Double(frame.size.width) - (1 + Double(numberOfColumns)) * gapBetweenTiles) / (Double(numberOfColumns) /*+ gapBetweenTiles*/)
        print("width of a tile \(widthOfATile)")
        var v = 0
        for row in tiles {
            let y = (widthOfATile + gapBetweenTiles) * Double(row[0].row) + 40.0

            for column in row {
                v += 1
                let x = (widthOfATile + gapBetweenTiles) * Double(column.column) + gapBetweenTiles
                if column.tiles[0] == TileType.MineTile {
                    let mineView = MineView(frame: CGRect(x: x, y: y, width: widthOfATile, height: widthOfATile))
                    mineView.backgroundColor = UIColor.white
                    mineView.layer.shadowColor = UIColor.black.cgColor
                    mineView.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
                    mineView.layer.shadowRadius = 5
                    mineView.layer.shadowOpacity = 1.0
                    

                    view.addSubview(mineView)
                } else {
                    let button = makeButton(x: x, y: y, widthHeight: widthOfATile)
                    button.layer.shadowColor = UIColor.black.cgColor
                    button.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
                    button.layer.shadowRadius = 5
                    button.layer.shadowOpacity = 1.0


                    button.setTitle("\(v % 10)", for: .normal)
                    view.addSubview(button)
                }
            }
        }
    }
    
    @IBAction func didTapStartButton(_ sender: UIButton) {
        print("Did tap the start button.")
        sender.isEnabled = false
        let tiles = mineModel.startGameWith(rows: numberOfRows, columns: numberOfColumns)
        updateTiles(tiles: tiles)
        
    }
    
    func didTapButton(_ button: UIButton) {
        print("didTapButton with tag: \(button.tag)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// TextField delegates
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        inputErrorMessageLabel.text = ""
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        inputErrorMessageLabel.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        if let text = numRowsTextField.text, let value = Int(text) {
            if value > maxNumberOfRows {
                inputErrorMessageLabel.text = "Rows should be less than \(maxNumberOfRows). Try again."
                return false
            }else if value < minNumberOfRows {
                inputErrorMessageLabel.text = "Rows should be at least \(minNumberOfRows). Try again."
                return false
            }
            numberOfRows = value
        }
        
        if let text = numColumnsTextField.text, let value = Int(text) {
            if value > maxNumberOfColumns {
                inputErrorMessageLabel.text = "Columns should be less than \(maxNumberOfColumns). Try again."
                return false
            }else if value < minNumberOfColumns {
                inputErrorMessageLabel.text = "Columns should be at least \(minNumberOfColumns). Try again."
                return false
            }
            numberOfColumns = value
        }

        textField.resignFirstResponder()
        print("Rows = \(numberOfRows) columns = \(numberOfColumns)")
        if numberOfRows > 0 && numberOfColumns > 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.numRowsTextField.alpha = 0.0
                self.numColumnsTextField.alpha = 0.0
            }, completion: { _ in
                UIView.animate(withDuration: 0.5, animations: {
                    self.startButton.alpha = 1.0
                }, completion: { _ in })
            })
        }
        numRowsTextField.isEnabled = false
        numColumnsTextField.isEnabled = false
        return true
    }


}

