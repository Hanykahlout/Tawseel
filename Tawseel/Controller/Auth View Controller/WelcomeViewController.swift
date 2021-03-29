//
//  WelcomeViewController.swift
//  Tawseel
//
//  Created by macbook on 11/03/2021.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var skipButton: ButtonDesignable!
    @IBOutlet weak var startNowButton: ButtonDesignable!
    @IBOutlet weak var nextButton: ButtonDesignable!
    @IBOutlet weak var pageButton1: UIButton!
    @IBOutlet weak var pageButton2: UIButton!
    @IBOutlet weak var pageButton3: UIButton!
    @IBOutlet weak var startButtonArrow: UIImageView!
    private var data = [(image:UIImage,imageHeightConstant:CGFloat,title:String,details:String)]()
    private var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
        navigationController?.navigationBar.isHidden = true
        
        pageButton1.setImage(UIImage(named: "l2")!, for: .normal)
        pageButton2.setImage(UIImage(named: "l2")!, for: .normal)
        pageButton3.setImage(UIImage(named: "l1")!, for: .normal)
    }
    
    private func initlization() {
        setUpCollectionView()
        setData()
        setUpButtons()
    }
    
    private func setUpButtons() {
        nextButton.setGradient(firstColor: #colorLiteral(red: 0, green: 0.5764705882, blue: 0.6823529412, alpha: 1), secondColor: #colorLiteral(red: 0.04705882353, green: 0.1647058824, blue: 0.3058823529, alpha: 1), startPoint: nil, endPoint: nil)
        startNowButton.setGradient(firstColor: #colorLiteral(red: 0, green: 0.5764705882, blue: 0.6823529412, alpha: 1), secondColor: #colorLiteral(red: 0.04705882353, green: 0.1647058824, blue: 0.3058823529, alpha: 1), startPoint: nil, endPoint: nil)
    }
    
    private func setData() {
        data.append((image: #imageLiteral(resourceName: "i1"),imageHeightConstant : 195, title: "Ask for the closest", details: """
Tawseel application helps you to choose the closest marketing personnel to the location of your order by displaying them on the map
"""))
        data.append((image: #imageLiteral(resourceName: "i2"),imageHeightConstant : 300 , title: "Electronic payment", details: """
The application provides you with a variety of electronic payment options such as, Visa Card, Paypal and Master Card with the ability to pay in cash
"""))
        data.append((image: #imageLiteral(resourceName: "i3"),imageHeightConstant : 265 , title: "join us", details: """
If you own a car, you can join us and work as a delivery representative within a distinguished team by filling in the registration data in the application
"""))
    }
    
    @IBAction func skipAction(_ sender: Any) {
        collectionView.selectItem(at: IndexPath.init(row: 2, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
    
    @IBAction func startNowAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AuthNav") as! UINavigationController
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func nextAction(_ sender: Any) {
        index = (index+1)%3
        collectionView.selectItem(at: IndexPath.init(row: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
    
    private func changePageControl() {
        switch index {
        case 0:
            pageButton1.setImage(UIImage(named: "l2")!, for: .normal)
            pageButton2.setImage(UIImage(named: "l2")!, for: .normal)
            pageButton3.setImage(UIImage(named: "l1")!, for: .normal)
            break
        case 1:
            pageButton1.setImage(UIImage(named: "l2")!, for: .normal)
            pageButton2.setImage(UIImage(named: "l1")!, for: .normal)
            pageButton3.setImage(UIImage(named: "l2")!, for: .normal)
            break
        case 2:
            pageButton1.setImage(UIImage(named: "l1")!, for: .normal)
            pageButton2.setImage(UIImage(named: "l2")!, for: .normal)
            pageButton3.setImage(UIImage(named: "l2")!, for: .normal)
            break
        default:
            break
        }
    }
}

extension WelcomeViewController: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    private func setUpCollectionView()  {
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WelcomePageCollectionViewCell", for: indexPath) as! WelcomePageCollectionViewCell
        cell.setData(data: data[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = CGFloat(scrollView.contentOffset.x/view.frame.width).rounded()
        switch currentPage {
        case 0.0,1.0:
            startButtonArrow.isHidden = true
            startNowButton.isHidden = true
            nextButton.isHidden = false
            skipButton.isHidden = false
            break
        case 2.0:
            startButtonArrow.isHidden = false
            startNowButton.isHidden = false
            nextButton.isHidden = true
            skipButton.isHidden = true
            break
        default:
            break
        }
        index = Int(currentPage)
        changePageControl()
    }
}

