//
//  ViewController.swift
//  Prac 2.2
//
//  Created by Rosalma Wehbe López on 29/9/16.
//  Copyright © 2016 upm. All rights reserved.
//

import UIKit

class ViewController: UIViewController , BoardDelegate, BoardViewDataSource {

    var board: Board!
    
    @IBOutlet weak var puntuacion: UILabel!
    @IBOutlet weak var partidas: UILabel!
    
    var newRecord : Int = 0
    var numPartidas : Int = 0
    
    @IBOutlet weak var record: UILabel!
    
    @IBOutlet weak var nextBlockview: BoardView!
    @IBOutlet weak var boardView: BoardView!
    var timer : Timer?
    
    var gameInProgress = false
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        board = Board()
        boardView.dataSource = self
        nextBlockview.dataSource = self
        board.delegate = self
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(sender:)))
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(sender:)))
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(sender:)))
        
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(sender:)))
        
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTap(sender:)))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        downSwipe.direction = .down
        upSwipe.direction = .up
        
        longTap.minimumPressDuration = 0.3
        longTap.numberOfTapsRequired = 1
        
        
        
        boardView.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(leftSwipe)
        boardView.addGestureRecognizer(rightSwipe)
        view.addGestureRecognizer(rightSwipe)
        boardView.addGestureRecognizer(downSwipe)
        view.addGestureRecognizer(downSwipe)
        boardView.addGestureRecognizer(upSwipe)
        view.addGestureRecognizer(upSwipe)
        boardView.addGestureRecognizer(longTap)
        view.addGestureRecognizer(longTap)
        
        
        
        startNewGame()
    }
    
    func handleSwipes(sender: UISwipeGestureRecognizer){
        
        switch sender.direction{
            
        case UISwipeGestureRecognizerDirection.left :
            board.moveLeft()
            print("izquierda")
        case UISwipeGestureRecognizerDirection.right :
            board.moveRight()
            print("derecha")
        case UISwipeGestureRecognizerDirection.up :
            board.rotate(toRight: true)
            print("arriba")
        case UISwipeGestureRecognizerDirection.down:
            board.moveDown()
            print("abajo")
        default : break
        }
        nextBlockview.setNeedsDisplay()
        boardView.setNeedsDisplay()
    }
    
    func handleLongTap (sender: UILongPressGestureRecognizer){
        if sender.state != .began {
            return
        }
        board.dropDown()
        boardView.setNeedsDisplay()
        print("dale mucho")
        
        
    }
    
    func startNewGame(){
        
        board.puntos = 0
        
        numPartidas = numPartidas + 1
        
        partidas.text = "Partidas: \(numPartidas)"
        puntuacion.text = String(board.puntos)
        
        board.newGame()
        gameInProgress = true
        autoMoveDown()
        
        
        
    }
    
   
    
    func autoMoveDown() {
        
        guard gameInProgress else { return }
        
        board.moveDown(insertNewBlockIfNeeded: true)
        boardView.setNeedsDisplay()
        nextBlockview.setNeedsDisplay()
        
        let intervalo = 1.0
        
        timer = Timer.scheduledTimer(timeInterval: intervalo ,
            target: self,
            selector: #selector(autoMoveDown),
            userInfo: nil,
            repeats: false)
        
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //MARK: - Controles



    @IBAction func moveLeft(_ sender: UIButton) {
        
        board.moveLeft()
        boardView.setNeedsDisplay()
        nextBlockview.setNeedsDisplay()
        
    }

    @IBAction func rotate(_ sender: UIButton) {
        board.rotate(toRight: true)
        boardView.setNeedsDisplay()
        nextBlockview.setNeedsDisplay()
    }

    @IBAction func moveDown(_ sender: UIButton) {
        board.moveDown()
        boardView.setNeedsDisplay()
        nextBlockview.setNeedsDisplay()
    }

    @IBAction func moveRight(_ sender: UIButton) {
        board.moveRight()
        boardView.setNeedsDisplay()
        nextBlockview.setNeedsDisplay()
    }
    
   /* @IBAction func swipe(_ sender: UISwipeGestureRecognizer) {
        
        switch sender.direction {
        case UISwipeGestureRecognizerDirection.right:
            print("Swiped right")
        case UISwipeGestureRecognizerDirection.down:
            print("Swiped down")
        case UISwipeGestureRecognizerDirection.left:
            print("Swiped left")
        case UISwipeGestureRecognizerDirection.up:
            print("Swiped up")
        default:
            break
        }
        
    
    }
    @IBAction func pan(_ sender: UIPanGestureRecognizer) {
        
        print("nada")
        
    }
    
    @IBAction func longTapping(_ sender: UILongPressGestureRecognizer) {
        
        sender.minimumPressDuration = 0.5
       board.moveDown()
        boardView.setNeedsDisplay()
        print("pulsa mucho")
        
    }
    */
    // MARK: - Cosas del delegado
    func gameOver(){
        
        
        gameInProgress = false
        
        let alert = UIAlertController(title: "Has perdido", message: "pulsa OK para intentarlo de nuevo",
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style:.default){aa in self.startNewGame()})
        
            present(alert, animated:true, completion: nil)
    }
    
    func numberOfRows(in boardView: BoardView)->Int{
        
        switch boardView {
            case self.boardView: return board.rowsCount
            case self.nextBlockview: return board.nextBlock?.height ?? 0
            default: return 0
        
        }
        //return board.rowsCount
    }
    
    func numberOfColumns(in boardView: BoardView)->Int{
        
        switch boardView {
        case self.boardView: return board.columnsCount
        case self.nextBlockview: return board.nextBlock?.width ?? 0
        default: return 0
            
        }
        //return board.columnsCount
    }
    
    //Diccionario para guardar UIImage asociadas a nombres
    var imagesCache = [String:UIImage]()
    
    //Dado un nombre saca la UIImage y la guarda en la caché
    private func cachedImage(name imageName: String) -> UIImage? {
        
        //Si ya existe en el diccionario (cache) devuelvela
        if let image = imagesCache[imageName] {
            return image
        }
            //Si no esta en la cache añadela y devuelvela
        else if let image = UIImage(named: imageName) {
            
            imagesCache[imageName] = image
            
            return image
            
        }
        
        return nil
        
    }
    
    func backgroundImageName(in boardView: BoardView, atRow row: Int, atColumn column: Int) -> UIImage? {
      
        switch self.boardView{
            case self.boardView :
                if let texture = board.currentTexture(atRow: row, atColumn: column) {
                   
                    let imageName = texture.backgroundImageName()
                    return cachedImage(name: imageName)
            
                }else{ return nil}
            
            case self.nextBlockview:
                guard let block = board.nextBlock, 
                block.isSolid(row: row, column: column) else {return nil}
                let imageName = block.texture.backgroundImageName()
                return cachedImage(name: imageName)
        
        default: return nil
        //return nil
        }
        
    }
    
    func foregroundImageName(in boardView: BoardView, atRow row: Int, atColumn column: Int) -> UIImage? {
        
        switch boardView {
            
            case self.boardView:
                    if let texture = board.currentTexture(atRow: row, atColumn: column) {
            
                            let imageName = texture.pokemonImageName()
                            return cachedImage(name: imageName)
            
                    }else {return nil}
            
            case self.nextBlockview:
                guard let block = board.nextBlock,
                    block.isSolid(row: row, column: column) else { return nil }
                let imageName = block.texture.pokemonImageName()
                return cachedImage(name: imageName)
            
            default: return nil
        
        
        }
        
    }
    
    
    
    
    
    
    func rowCompleted() {
        
        print("Felicidades")
        
    }
    
    func actualizaLabels(puntos: Int) {
        
        puntuacion.text = String(puntos)
        
        if (puntos > newRecord){
            newRecord = puntos
            record.text = "Record: \(newRecord)"
        }
        boardView.setNeedsDisplay()
        
    }
}







