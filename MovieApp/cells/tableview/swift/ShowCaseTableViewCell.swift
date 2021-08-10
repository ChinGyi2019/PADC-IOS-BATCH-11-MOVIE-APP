//
//  ShowCaseTableViewCell.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 30/01/2021.
//

import UIKit

class ShowCaseTableViewCell: UITableViewCell {
    @IBOutlet weak var lblShowCases: UILabel!
    @IBOutlet weak var lblMoreShowCases: UILabel!
    @IBOutlet weak var collectionShowCasesHeight : NSLayoutConstraint!
    
    @IBOutlet weak var collectionViewShowCase: UICollectionView!
    
    var delegate  : MovieItemDelegate? = nil
    var showMoreCasesDelegate : ShowMoreShowCasesDelegate? = nil
    
    var data  = [MovieResult](){ //MovieListResponse?
        didSet{
        
            if !data.isEmpty{
                collectionViewShowCase.reloadData()
            }
               
        
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblMoreShowCases.underLineText(text: "MORE CASES", stroke: 2)
        _ = UIColor(named: "primary_color")
        
        registerGestureRecognizer()
        
        collectionViewShowCase.dataSource = self
        collectionViewShowCase.delegate = self
        collectionViewShowCase.register(UINib(nibName: String(describing: ShowCaseCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ShowCaseCollectionViewCell.self))
        //CollectionView Height
        let width = collectionViewShowCase.frame.width - 50
        let height =  (width / 16) * 9
        collectionShowCasesHeight.constant = height
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    fileprivate func registerGestureRecognizer(){
        let tabGestForMoreShowCases = UITapGestureRecognizer(target: self, action: #selector(onTapMoreActors) )
        lblMoreShowCases.isUserInteractionEnabled = true
        lblMoreShowCases.addGestureRecognizer(tabGestForMoreShowCases)
        
    }
    
    @objc func onTapMoreActors(){
        showMoreCasesDelegate?.didTabMoreShowCases()
    }
}

extension ShowCaseTableViewCell : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionViewShowCase.frame.width - 50
        let height = (width / 16) * 9
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ShowCaseCollectionViewCell.self), for: indexPath) as? ShowCaseCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.data = data[indexPath.row ]

        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //For Vertical Indicator
        //((scrollView.subviews[(scrollView.subviews.count-2)]).subviews[0])
        
        //For Horizontal Indicator
        ((scrollView.subviews[(scrollView.subviews.count-1)]).subviews[0])
            .backgroundColor = UIColor(named: "color_yellow")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = data[indexPath.row]
        delegate?.onTapMovie(id: item.id ?? -1 , isSeries: false)
    }
    
    
}
