//
//  BoardView.swift
//  Prac 2.2
//
//  Created by Rosalma Wehbe López on 29/9/16.
//  Copyright © 2016 upm. All rights reserved.
//

import UIKit

    protocol  BoardViewDataSource:class {
        
        //Preguntar al DataSource cuantas filas tiene el tablero a pintar.
        func numberOfRows(in: BoardView)->Int
        
        // Preguntar al Data Source cuantas columnas tiene el tablero a pintar.
        func numberOfColumns(in: BoardView) -> Int
        
        // Preguntar al Data Source que imagen hay que poner como fondo en una posicion del tablero.
        func backgroundImageName(in: BoardView, atRow row: Int, atColumn column: Int) -> UIImage?
        
        // Preguntar al Data Source que imagen hay que poner en primer plano en una posicion del tablero.
        func foregroundImageName(in: BoardView, atRow row: Int, atColumn column: Int) -> UIImage?
        
    }
    
    @IBDesignable
    class BoardView: UIView {
        
        weak var dataSource : BoardViewDataSource!
        
        @IBInspectable
        var bgColor : UIColor! = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.5)
        
        var boxSize : CGFloat!
        
        //Aqui ponemos las sentencias con las que pintamos en el tablero
        
        override func draw(_ rect: CGRect) {
            //Pintamos el tablero como un array de cuadradinos que a medida que se rellenan cambian de línea=> Pintas fila y columna doble array
            updateBoxSize()
            drawBackground()
            drawBlocks()
            
        }
        
        //Pinta el fondo
        private func drawBackground(){
            
            //tamaño del tablero
            let rows = dataSource.numberOfRows(in: self)
            let columns = dataSource.numberOfColumns(in: self)
            
            //Rectangulo de la zona de la view donde pintare
            let canvasWidth = box2Point(columns)
            let canvasHeight = box2Point(rows)
            let path = UIBezierPath(roundedRect: CGRect(x: 2.5, y: 2.5, width: canvasWidth-5, height: canvasHeight-5), cornerRadius: 10)
            bgColor.setStroke()
            path.lineWidth = 5
            UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.25).setFill()
            path.stroke()
            path.fill()
            
        }
        
        //Pinta los bloques añadidos/congelados/depositados en el tablero
        private func drawBlocks(){
            //tamaño del tablero
            let rows = dataSource.numberOfRows(in:self)
            let columns = dataSource.numberOfColumns(in:self)
            
            for r in 0..<rows{
                for c in 0..<columns{
                    drawBox(row:r, column:c)
                }
            }
        }
        
        //Dibuja el cuadradito de la posicion indicada
        private func drawBox(row: Int, column: Int){
            let x = box2Point(column)
            let y = box2Point(row)
            let width = box2Point(1)
            let height = box2Point(1)
            
            let rect = CGRect(x: x, y: y, width: width, height: height)
            
            if let bgImg = dataSource.backgroundImageName(in:self, atRow: row, atColumn: column){
                bgImg.draw(in:rect)
            }
            
            if let fgImg = dataSource.foregroundImageName(in:self, atRow: row, atColumn: column){
                fgImg.draw(in:rect)
            }
        }
        
        private func updateBoxSize(){
            let rows = dataSource.numberOfRows(in:self)
            let columns = dataSource.numberOfColumns(in:self)
            //Tamaño en puntos de la zona de la view donde se puede dibujar
            let width = bounds.size.width
            let height = bounds.size.height
            
            //Tamaño de un cuadradito en puntos
            let boxWidth = width / CGFloat(columns)
            let boxHeight = height / CGFloat(rows)
            
            boxSize = min(boxWidth,boxHeight)
        }
        
        
        private func box2Point(_ box : Int) -> CGFloat {
            return CGFloat(box) * boxSize
        }

}
