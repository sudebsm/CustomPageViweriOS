//
//  ViewController.swift
//  PageViwer
//
//  Created by Sudeb Sarkar on 29/06/20.
//  Copyright © 2020 Sudeb Sarkar. All rights reserved.
//

import UIKit

class MainViewColtroller: UIViewController  {
    
    
    @IBOutlet var stackView : UIStackView?
    @IBOutlet var collectionView : UICollectionView?
    var arrName = [String]()
    var arrButton = [UIButton]()

    var arrPage = [UIViewController]() {
        didSet{
            
            if arrPage.count > 0{
            let button = UIButton()
            button.setTitle(arrName[arrPage.count - 1], for: .normal)
            button.backgroundColor = UIColor.blue
            button.tag = arrPage.count - 1
            button.addTarget(self,action:#selector(buttonClicked), for:.touchUpInside)
 
                button.setBackgroundColor(  UIColor.lightGray, for: .normal)
                button.setBackgroundColor(  UIColor.darkGray  , for: .selected)
 
            stackView!.alignment = .fill
            stackView!.distribution = .fillEqually
            stackView!.spacing = 0
            stackView!.translatesAutoresizingMaskIntoConstraints = false
            stackView!.addArrangedSubview(button)
                
            arrButton.append(button)
            }
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePageViwer()
        // Do any additional setup after loading the view.
    }
    
    
    func configurePageViwer(){
        
        collectionView!.register(UINib(nibName: "collectionTaskHolderViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "collectionTaskHolderViewCell")
        
        
        let page1 =   self.storyboard?.instantiateViewController(withIdentifier: "FirstVC") as! FirstVC
        arrName.append("First Page")

        arrPage.append(page1)
        
        let page2 =   self.storyboard?.instantiateViewController(withIdentifier: "SecondVC") as! SecondVC
        arrName.append("Second Page")

        arrPage.append(page2)
        selectedIndex(visibleIndex: 0)
        
    }
    
    
    func selectedIndex(visibleIndex : Int ){
        
        
        for btn in arrButton {
                   
                   btn.isSelected = false
        }
        arrButton[visibleIndex].isSelected = true
        if self.view.viewWithTag(90908) != nil {
           
            return
         }
        let lbl = UILabel()
        lbl.frame = arrButton[visibleIndex].frame
        lbl.tag = 90908
        lbl.backgroundColor = .yellow
        lbl.frame = CGRect(x: Int(lbl.bounds.origin.x) , y: Int((stackView!.frame.origin.y + stackView!.frame.size.height) - 4), width: Int( Int(stackView!.frame.width) / arrButton.count) , height: 4)
        arrButton[visibleIndex].addSubview(lbl)
 
        stackView!.bringSubviewToFront(arrButton[visibleIndex])
         
    }
    
    
    @objc func buttonClicked(sender:UIButton)
    {
        collectionView!.scrollToItem(at:IndexPath(item: sender.tag, section: 0), at: .right, animated: false)

       // selectedIndex(visibleIndex: sender.tag)
        print("hello")
    }
     
}



extension MainViewColtroller : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrPage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionTaskHolderViewCell", for: indexPath) as! collectionTaskHolderViewCell
        
        let currentVC = self.arrPage[indexPath.row]
        self.addChild(currentVC)
        currentVC.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(currentVC.view)
        currentVC.didMove(toParent: self)
        cell.contentView.addSubview(currentVC.view)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width , height: collectionView.bounds.size.height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let visibleIndex = Int(targetContentOffset.pointee.x / collectionView!.frame.width)
        print(visibleIndex)
        
        selectedIndex(visibleIndex: visibleIndex)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
           
            if let selLbl = self.view.viewWithTag(90908) {
    
                let frame = CGRect(x: (scrollView.contentOffset.x / CGFloat(arrName.count)), y: selLbl.frame.origin.y , width: selLbl.frame.size.width, height: selLbl.frame.size.height)
                      selLbl.frame = frame
                      print("Just check if it's called")
               
               
                  }
    
       }
       
}

extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
    let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
    UIGraphicsBeginImageContext(rect.size)
    color.setFill()
    UIRectFill(rect)
    let colorImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    setBackgroundImage(colorImage, for: state)
  }
}
