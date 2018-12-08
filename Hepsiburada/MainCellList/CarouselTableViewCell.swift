//
//  CarouselTableViewCell.swift
//  Hepsiburada
//
//  Created by macbookair on 21.09.2018.
//  Copyright © 2018 Erim Kurt. All rights reserved.
//

import UIKit

class CarouselTableViewCell: UITableViewCell, UIPageViewControllerDataSource {
    
    var pageViewController: UIPageViewController?
    var imageArray: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        createPageViewContoller()
    }

    func createPageViewContoller(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let pageController =  storyBoard.instantiateViewController(withIdentifier: "CarouselPageViewController") as! UIPageViewController
        pageController.dataSource = self
        if imageArray.count > 0{
            let firstController = getItemController(0)
            let startingViewController = [firstController]
            pageController.setViewControllers(startingViewController, direction: UIPageViewController.NavigationDirection .forward, animated: false, completion: nil)
        }
        pageController.view.frame = CGRect(x: 10, y: 10, width: self.frame.width-20, height: 300)
        pageViewController = pageController
        self.addSubview(pageViewController!.view)
        setupPageController()
    }
    
    func changePageViewImage(){
        if imageArray.count > 0{
            let firstController = getItemController(0)
            let startingViewController = [firstController]
            pageViewController!.setViewControllers(startingViewController, direction: UIPageViewController.NavigationDirection .forward, animated: false, completion: nil)
        }
    }
    
    func setupPageController() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.gray
        appearance.currentPageIndicatorTintColor = UIColor.orange
        appearance.backgroundColor = UIColor.clear
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let carouselController = viewController as! CarouselViewController
        if carouselController.index > 0{
            return getItemController(carouselController.index-1)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let carouselController = viewController as! CarouselViewController
        if carouselController.index+1 < imageArray.count{
            return getItemController(carouselController.index+1)
        }
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return imageArray.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func currentController() -> UIViewController {
        if(self.pageViewController?.viewControllers?.count)! > 0{
            return (self.pageViewController?.viewControllers?[0])!
        }
        return UIViewController()
    }
    
    func getItemController(_ itemIndex: Int) -> CarouselViewController {
        if itemIndex < imageArray.count{
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let pageController =  storyBoard.instantiateViewController(withIdentifier: "CarouselViewController") as! CarouselViewController
            pageController.index = itemIndex
            pageController.image = imageArray[itemIndex]
            return pageController
        }
        return CarouselViewController()
    }
}
