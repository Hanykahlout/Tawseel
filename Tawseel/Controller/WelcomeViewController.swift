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
    
    var data = [(image:UIImage,imageHeightConstant:CGFloat,title:String,details:String)]()
    var index = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        initlization()
        navigationController?.navigationBar.isHidden = true
    }
    func initlization() {
        setUpCollectionView()
        setData()
        setUpButtons()
    }
    func setUpButtons() {
        nextButton.setGradient(firstColor: #colorLiteral(red: 0, green: 0.5764705882, blue: 0.6823529412, alpha: 1), secondColor: #colorLiteral(red: 0.04705882353, green: 0.1647058824, blue: 0.3058823529, alpha: 1), startPoint: nil, endPoint: nil)
        startNowButton.setGradient(firstColor: #colorLiteral(red: 0, green: 0.5764705882, blue: 0.6823529412, alpha: 1), secondColor: #colorLiteral(red: 0.04705882353, green: 0.1647058824, blue: 0.3058823529, alpha: 1), startPoint: nil, endPoint: nil)
    }
    func setData() {
        data.append((image: #imageLiteral(resourceName: "i1"),imageHeightConstant : 195, title: "اطلب الأقرب", details: """
يساعدك تطبيق توصيل على اختيار اقرب
مناديب التسويق الى موقع طلبك من خلال
عرضهم عبر الخريطة
"""))
        data.append((image: #imageLiteral(resourceName: "i2"),imageHeightConstant : 300 , title: "دفع الكتروني", details: """
يساعدك تطبيق توصيل على اختيار اقربيسهلك لك التطبيق تعدد خيارات الدفع الالكتروني مثل،
فيزا كارد و بيبال و ماستر كارد
مع إمكانية الدفع كاش
"""))
        data.append((image: #imageLiteral(resourceName: "i3"),imageHeightConstant : 265 , title: "انضم الينا", details: """
يساعدك تطبيق توصيل على اختيار اقربيسهلك لك التطبيق تعدد خيارات الدفع الالكتروني مثل،اذا كنت تملك سيارة ، فبامكانك الانضمام الينا و العمل ك مندوب توصيل ضمن فريق عمل متميز
من خلال تعبئة بيانات التسجيل في التطبيق
"""))
    }
    
    @IBAction func skipAction(_ sender: Any) {
        collectionView.selectItem(at: IndexPath.init(row: 2, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        nextButton.isHidden = true
        skipButton.isHidden = true
        startNowButton.isHidden = false
        changePageControl()
    }
    
    @IBAction func startNowAction(_ sender: Any) {
    }
    @IBAction func nextAction(_ sender: Any) {
        index = (index+1)%3
        collectionView.selectItem(at: IndexPath.init(row: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        switch index {
        case 0,1:
            nextButton.isHidden = false
            skipButton.isHidden = false
            startNowButton.isHidden = true
            break
        case 2:
            nextButton.isHidden = true
            skipButton.isHidden = true
            startNowButton.isHidden = false
            break
        default:
            break
        }
        changePageControl()
    }
    
    func changePageControl() {
        switch index {
        case 0:
            pageButton1.setImage(UIImage(named: "l1")!, for: .normal)
            pageButton2.setImage(UIImage(named: "l2")!, for: .normal)
            pageButton3.setImage(UIImage(named: "l2")!, for: .normal)
            break
        case 1:
            pageButton1.setImage(UIImage(named: "l2")!, for: .normal)
            pageButton2.setImage(UIImage(named: "l1")!, for: .normal)
            pageButton3.setImage(UIImage(named: "l2")!, for: .normal)
            break
        case 2:
            pageButton1.setImage(UIImage(named: "l2")!, for: .normal)
            pageButton2.setImage(UIImage(named: "l2")!, for: .normal)
            pageButton3.setImage(UIImage(named: "l1")!, for: .normal)
            break
        default:
            break
        }
    }
}

extension WelcomeViewController: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func setUpCollectionView()  {
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.delegate = self
        collectionView.dataSource = self
        // Depending on the language
        collectionView.semanticContentAttribute = .forceRightToLeft
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
        case 2.0,1.0:
            startNowButton.isHidden = true
            nextButton.isHidden = false
            skipButton.isHidden = false
            if currentPage == 2{
                index = 0
            }else{
                index = 1
            }
            changePageControl()
            break
        case 0.0:
            startNowButton.isHidden = false
            nextButton.isHidden = true
            skipButton.isHidden = true
            index = 2
            changePageControl()
            break
        default:
            break
        }
    }
}

