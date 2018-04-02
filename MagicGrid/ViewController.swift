//
//  ViewController.swift
//  MagicGrid
//
//  Created by John Bogil on 3/27/18.
//  Copyright © 2018 John Bogil. All rights reserved.
//

// FEATURE IDEAS:
// 3D TOUCH PRESSURE
// MULTI TOUCH
// SETTINGS PANEL
// HAPTIC FEEDBACK
// ALLOW USER TO CHANGE COLOR OF CELLS


import UIKit

let cellsPerRow = 15
var cellsDict = [String: UIView]()
var cellSideLength = CGFloat()
var cellsPerColumn = Int()
var selectedcell: UIView?
var touchForce = CGFloat()
var forceCell = UIView()

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cellSideLength = view.frame.width / CGFloat(cellsPerRow)
        cellsPerColumn = Int(view.frame.height / cellSideLength)
        
        for j in 0...cellsPerColumn {
            for i in 0...cellsPerRow {
                let cell = createCellAtPosition(i: i, j: j)
                view.addSubview(cell)
                let key = "\(i)|\(j)"
                cellsDict[key] = cell
            }
        }
        view.addGestureRecognizer(UIPanGestureRecognizer(target:self, action:#selector(handlePan)))
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(handlePan)))
    }
    
    func createCellAtPosition(i:Int,j:Int) -> UIView {
        let cell = UIView()
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0.5
        cell.backgroundColor = randomColor()
        let xPosition = CGFloat(i) * cellSideLength
        let yPosition = CGFloat(j) * cellSideLength
        cell.frame = CGRect(x: xPosition, y: yPosition, width: cellSideLength, height: cellSideLength)
        return cell
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        
        let location = gesture.location(in: view)
        guard let cell = getCellForLocation(location: location) else {return}
        
        if selectedcell != cell {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                selectedcell?.layer.transform = CATransform3DIdentity
            })
        }
        
        view.bringSubview(toFront: cell)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            cell.transform = CGAffineTransform(scaleX: 3, y: 3)
        })
        
        selectedcell = cell
        
        if gesture.state == .ended {
            UIView.animate(withDuration: 0.5, delay: 0.25, options: .curveEaseOut, animations: {
                cell.layer.transform = CATransform3DIdentity
            })
        }
    }
    
    func randomColor() -> UIColor {
        let red = CGFloat(drand48())
        let blue = CGFloat(drand48())
        let green = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 1
        )
    }
    
    func getCellForLocation(location:CGPoint) -> UIView? {
        let location = location
        let cellSideLength = view.frame.width / CGFloat(cellsPerRow)
        let columnNumber = Int(location.x / cellSideLength)
        let rowNumber = Int(location.y / cellSideLength)
        let key = "\(columnNumber)|\(rowNumber)"
        let cell = cellsDict[key]
        return cell 
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if let touch = touches.first {
            let location = touch.location(in: self.view)
            if view.traitCollection.forceTouchCapability == .available {
                print(touch.force)
                guard let cell = getCellForLocation(location: location) else {return}
                view.bringSubview(toFront: cell)
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    cell.transform = CGAffineTransform(scaleX: touch.force, y: touch.force)
                })
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesended")
        if let touch = touches.first {
            let location = touch.location(in: self.view)
            guard let cell = getCellForLocation(location: location) else {return}
            view.bringSubview(toFront: cell)
            UIView.animate(withDuration: 0.5, delay: 0.25, options: .curveEaseOut, animations: {
                cell.layer.transform = CATransform3DIdentity
            })
        }
    }
}
