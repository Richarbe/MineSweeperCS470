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

    @IBOutlet weak var flagButton: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var numMinesMessageLabel: UILabel!
    
    var numberOfRows = 0
    var numberOfColumns = 0
    let maxNumberOfRows = 15
    let maxNumberOfColumns = 10
    let minNumberOfRows = 1
    let minNumberOfColumns = 1
    let gapBetweenTiles = 2.0
    var mineModel = MineSweeperModel()
    var widthOfATile = 0.0
    let shadowColor = UIColor.lightGray.cgColor
    let flagImage = UIImage(named: "flag.png")
    let unflagImage = UIImage(named: "unflag.png")
    var FlagPlaceMode = false
    
    class gridUIButton : UIButton {
        var gridcolumn = 0
        var gridrow = 0
    }
    
    func makeButton(x: Double, y: Double, widthHeight: Double, gridrow: Int, gridcolumn: Int) -> gridUIButton {
        let button = gridUIButton(type: .roundedRect)
        button.frame = CGRect(x: x, y: y, width: widthHeight, height: widthHeight)
        button.backgroundColor = UIColor.green
        //button.layer.cornerRadius = 0
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        button.gridrow = gridrow
        button.gridcolumn = gridcolumn
        //addTarget does same thing as ctrl drag from storyboard to controller.
        return button
    }
    
    func makeCoverTile(x: Double, y: Double, widthHeight: Double, gridrow: Int, gridcolumn: Int) -> gridUIButton {
        let button = gridUIButton(type: .roundedRect)
        button.frame = CGRect(x: x, y: y, width: widthHeight, height: widthHeight)
        button.backgroundColor = UIColor.red
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 1.0
        //button.layer.cornerRadius = 0
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        button.gridrow = gridrow
        button.gridcolumn = gridcolumn
        //addTarget does same thing as ctrl drag from storyboard to controller.
        return button
    }
    
    func makeFlag(x: Double, y: Double, widthHeight: Double, gridrow: Int, gridcolumn: Int) ->gridUIButton {
        let button = gridUIButton(type: .custom)
        button.frame = CGRect(x: x, y: y, width: widthHeight, height: widthHeight)
        //button.layer.cornerRadius = 0
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        button.gridrow = gridrow
        button.gridcolumn = gridcolumn
        button.setImage(flagImage, for: UIControlState.normal)
        //addTarget does same thing as ctrl drag from storyboard to controller.
        return button
    }
    
    func makeUnFlag(x: Double, y: Double, widthHeight: Double, gridrow: Int, gridcolumn: Int) ->gridUIButton {
        let button = gridUIButton(type: .custom)
        button.frame = CGRect(x: x, y: y, width: widthHeight, height: widthHeight)
        //button.layer.cornerRadius = 0
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        button.gridrow = gridrow
        button.gridcolumn = gridcolumn
        button.setImage(unflagImage, for: UIControlState.normal)
        //addTarget does same thing as ctrl drag from storyboard to controller.
        return button
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.alpha = 0
        restartButton.alpha = 0
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
        for view in self.view.subviews {//clears all subviews
            if view.tag == 0 {
            view.removeFromSuperview()
            }
        }
        numMinesMessageLabel.text = "Mines: \(mineModel.numMinesUnflagged())"


        let frame = view.frame
        print(frame)
        widthOfATile = (Double(frame.size.width) - (1 + Double(numberOfColumns)) * gapBetweenTiles) / (Double(numberOfColumns) /*+ gapBetweenTiles*/)
        print("width of a tile \(widthOfATile)")

        var v = 0
        for i in 0..<tiles.count {
            let y = (widthOfATile + gapBetweenTiles) * Double(tiles[i][0].row) + 40.0

            for j in 0..<tiles[i].count {
                v += 1
                let x = (widthOfATile + gapBetweenTiles) * Double(tiles[i][j].column) + gapBetweenTiles
                if tiles[i][j].tiles[1] == TileType.CoverTile {
                    let button = makeCoverTile(x: x-gapBetweenTiles/2, y: y-gapBetweenTiles/2, widthHeight: widthOfATile + gapBetweenTiles, gridrow: i, gridcolumn: j)
                    button.layer.shadowColor = shadowColor
                    button.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
                    button.layer.shadowRadius = 5
                    button.layer.shadowOpacity = 1.0
                    view.addSubview(button)
                    
                }else if tiles[i][j].tiles[1] == TileType.FlagTile {
                    let button = makeFlag(x: x-gapBetweenTiles/2, y: y-gapBetweenTiles/2, widthHeight: widthOfATile + gapBetweenTiles, gridrow: i, gridcolumn: j)
                    button.layer.shadowColor = shadowColor
                    button.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
                    button.layer.shadowRadius = 5
                    button.layer.shadowOpacity = 1.0
                    view.addSubview(button)
                    
                }else if tiles[i][j].tiles[0] == TileType.MineTile {
                    let mineView = MineView(frame: CGRect(x: x, y: y, width: widthOfATile, height: widthOfATile))
                    mineView.backgroundColor = UIColor.white
                    mineView.layer.shadowColor = shadowColor
                    mineView.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
                    mineView.layer.shadowRadius = 5
                    mineView.layer.shadowOpacity = 1.0
                    view.addSubview(mineView)
                    
                } else if tiles[i][j].tiles[0] == TileType.NumberTile{
                    let button = makeButton(x: x, y: y, widthHeight: widthOfATile, gridrow: i, gridcolumn: j)
                    button.layer.shadowColor = shadowColor
                    button.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
                    button.layer.shadowRadius = 5
                    button.layer.shadowOpacity = 1.0
                    var count = 0
                    for iofset in -1...1 {
                        for jofset in -1...1 {
                            if 0..<tiles.count ~= i + iofset,
                               0..<tiles[i].count ~= j + jofset,
                               tiles[i+iofset][j+jofset].tiles[0] == TileType.MineTile{
                                count += 1
                            }
                        }
                    }
                    if count > 0 {
                    button.setTitle("\(count)", for: .normal)
                    }
                    view.addSubview(button)
                }
            }
        }
        /*
        let x = (widthOfATile + gapBetweenTiles) * Double(2) + gapBetweenTiles
        let y = (widthOfATile + gapBetweenTiles) * Double(tiles.count + 2) + gapBetweenTiles
        
        if FlagPlaceMode{
            let button = makeFlag(x: x, y: y, widthHeight: widthOfATile * 2, gridrow: -1, gridcolumn: -1)
            button.layer.shadowColor = shadowColor
            button.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
            button.layer.shadowRadius = 5
            button.layer.shadowOpacity = 1.0
            view.addSubview(button)
        }else{
            let button = makeUnFlag(x: x, y: y, widthHeight: widthOfATile * 2, gridrow: -1, gridcolumn: -1)
            button.layer.shadowColor = shadowColor
            button.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
            button.layer.shadowRadius = 5
            button.layer.shadowOpacity = 1.0
            view.addSubview(button)
        }*/
    }
    
    @IBAction func didTapStartButton(_ sender: UIButton) {
        print("Did tap the start button.")
        sender.isEnabled = false
        let tiles = mineModel.startGameWith(rows: numberOfRows, columns: numberOfColumns)
        
        updateTiles(tiles: tiles)
        
        flagButton.setImage(unflagImage, for: UIControlState.normal)
        restartButton.alpha = 1.0
        
    }
    
    @IBAction func didTapRestartButton(_ sender: Any) {
        numMinesMessageLabel.text = ""
        
    }

    @IBAction func didTapFlagButton(_ sender: Any) {
        if FlagPlaceMode{
            flagButton.setImage(unflagImage, for: UIControlState.normal)
        }else{
            flagButton.setImage(flagImage, for: UIControlState.normal)
        }
        FlagPlaceMode = !FlagPlaceMode
    }
    
    func didTapButton(_ button: gridUIButton) {
        print("didTapButton with grid position: \(button.gridrow) \(button.gridcolumn)")
        var lost = false
        if !FlagPlaceMode{
            if mineModel.prodForMines(row: button.gridrow, column: button.gridcolumn){
                lost = true
            }
        }else{
            if mineModel.placeFlag(row: button.gridrow, column: button.gridcolumn){
                lost = true
            }
        }
        updateTiles(tiles: mineModel.actionTiles())
        if lost {
        didLose()
        }else if mineModel.didWin(){
            didWin()
        }
    }
    
    func didWin(){
        mineModel.revealMines()
        updateTiles(tiles: mineModel.actionTiles())
        for view in self.view.subviews {//clears all subviews
            if view.tag == 0 {
                view.isUserInteractionEnabled = false
            }
        }
        numMinesMessageLabel.text = "You Won!"
        print("You Won!")
    }
    
    func didLose(){
        
        mineModel.revealMines()
        updateTiles(tiles: mineModel.actionTiles())
        for view in self.view.subviews {//clears all subviews
            if view.tag == 0 {
                view.isUserInteractionEnabled = false
            }
        }
        numMinesMessageLabel.text = "Game Over"
        print("Game Over")
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
    /*
    func countNeighborMines(row: Int, column: Int) -> Int {
        var count = 0
        var rowrange = -1...1
        var colrange = -1...1
        for i in -1...1 {
            for j in -1...1 {
                var newrow = row + i
                var newcol = column + j
                    
                }
            }
        return count
        }*/
    }

