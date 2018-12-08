//
//  ViewController.swift
//  Hepsiburada
//
//  Created by macbookair on 20.09.2018.
//  Copyright © 2018 Erim Kurt. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var elementArray: [UserSchema] = []
    var listArray: [List] = []
    var productArray: [ProductGrid] = []
    var carouselItem: Carousel!
    var bannerItem: Banner!
    
    enum CellType : String, Decodable {
        case carousel
        case grid
        case banner
        case list
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshServices()
    }
    
    func refreshServices() {
        WebHelper().getUserInterfaceSchema(success: { response in
            DispatchQueue.main.async {
                self.elementArray = (response as? [UserSchema])!
                WebHelper().getProductGrid(success: { response in
                    DispatchQueue.main.async {
                        self.productArray = (response as? [ProductGrid])!
                        self.tableView.reloadData()
                    }
                })
                WebHelper().getList(success: { response in
                    DispatchQueue.main.async {
                        self.listArray = (response as? [List])!
                        self.tableView.reloadData()
                    }
                })
                WebHelper().getCarousel(success: { response in
                    DispatchQueue.main.async {
                        self.carouselItem = (response as? Carousel)!
                        self.tableView.reloadData()
                    }
                })
                WebHelper().getBanner(success: { response in
                    DispatchQueue.main.async {
                        self.bannerItem = (response as? Banner)!
                        self.tableView.reloadData()
                    }
                })
            }
        })
    }
    
    func findListStringWithID(index: Int) -> Any{
        for object in listArray{
            if object.id == index{
                return object
            }
        }
        return Any.self
    }
}

//MARK: Table Delegate
extension ViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elementArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let userSchema = elementArray[indexPath.row]
        
        switch userSchema.elementType {
        case CellType.carousel.rawValue:
            //Carousel
            if let _ = carouselItem{
                let cell = tableView.dequeueReusableCell(withIdentifier: userSchema.elementType, for: indexPath) as! CarouselTableViewCell
                cell.imageArray = carouselItem.imagePaths
                cell.changePageViewImage()
                return cell
            }
        case CellType.list.rawValue:
            //List
            if listArray.count > 0{
                let listData = findListStringWithID(index: userSchema.id) as! List
                let cell = tableView.dequeueReusableCell(withIdentifier: userSchema.elementType, for: indexPath) as! ListTableViewCell
                cell.buttonLabel.text = listData.nameString
                return cell
            }
        case CellType.banner.rawValue:
            //Banner
            if let _ = bannerItem{
                let cell = tableView.dequeueReusableCell(withIdentifier: userSchema.elementType, for: indexPath) as! BannerTableViewCell
                cell.imageCover.displayImageFromURL(imagePath: bannerItem.bannerPath)
                return cell
            }
        case CellType.grid.rawValue:
            //Product Grid
            let cell = tableView.dequeueReusableCell(withIdentifier: userSchema.elementType, for: indexPath) as! ProductGridTableViewCell
            return cell
        default: break
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        let userSchema = elementArray[indexPath.row]
        
        if userSchema.elementType == CellType.grid.rawValue {
            var productCount: CGFloat = CGFloat(productArray.count)/2
            productCount.round(.up)
            var itemWidth = tableView.bounds.width
            itemWidth.calculateSquared(numberOfEachItemsPerRow: 2.0)
            
            return productCount*itemWidth + productCount*5
        }
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let userSchema = elementArray[indexPath.row]
        
        if userSchema.elementType == CellType.grid.rawValue {
            if let cell = cell as? ProductGridTableViewCell{
                cell.collectionView.dataSource = self
                cell.collectionView.delegate = self
                cell.collectionView.reloadData()
                cell.collectionView.isScrollEnabled = false
            }
        }
    }
}

//MARK: Collection Delegate
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let productContent = productArray[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductGridCollectionViewCell", for: indexPath) as! ProductGridCollectionViewCell
        cell.productName.text = productContent.title
        cell.commentCount.text = "(\(productContent.commentCount))"
        cell.coverImage.displayImageFromURL(imagePath: productContent.imagePath)
        
        //Star Rate
        let rateCount = productContent.rate
        for (index, imageView) in [cell.star1, cell.star2, cell.star3, cell.star4, cell.star5].enumerated() {
            imageView!.changeStar(isFull: index+1 <= rateCount)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 5.0
        layout.minimumInteritemSpacing = 2.5
        
        var itemWidth = collectionView.bounds.width
        itemWidth.calculateSquared(numberOfEachItemsPerRow: 2.0)
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
}

//MARK: Width Of Per Row By Items
extension CGFloat{
    mutating func calculateSquared(numberOfEachItemsPerRow: CGFloat){
        let minimumLineSpacing: CGFloat = 5.0
        let itemWidth = (self - minimumLineSpacing) / numberOfEachItemsPerRow
        self = itemWidth
    }
}

extension UIImageView{
    func changeStar(isFull: Bool){
        var color: UIColor = UIColor.lightGray
        if isFull {
            color = UIColor.orange
        }
        changeColorOfIcon(color: color)
    }
    
    func changeColorOfIcon(color: UIColor){
        self.image = self.image!.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
    
    func displayImageFromURL(imagePath: String){
        DispatchQueue.main.async {
            let url = URL(string: imagePath)
            let data = try? Data(contentsOf: url!)
            if let imageData = data {
                let image = UIImage(data: imageData)
                self.image = image
            }
        }
    }
}
