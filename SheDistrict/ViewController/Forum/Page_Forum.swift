//  ViewController.swift
//  SheDistrict
//  Created by appentus on 1/15/20.
//  Copyright © 2020 appentus. All rights reserved.


import UIKit


class Page_Forum: UIPageViewController , UIPageViewControllerDelegate, UIPageViewControllerDataSource , UIScrollViewDelegate{
    var pages = [UIViewController]()
    var curr = Int()
    var current = Int()
    
    var last_x : CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        let storyboard = UIStoryboard (name: "Main_3", bundle: nil)
        let page_1 = storyboard.instantiateViewController(withIdentifier: "Forum_List_ViewController") as! Forum_List_ViewController
        let page_2 = storyboard.instantiateViewController(withIdentifier: "Latest_Posts_ViewController") as! Latest_Posts_ViewController
        let page_3 = storyboard.instantiateViewController(withIdentifier: "New_Topics_ViewController") as! New_Topics_ViewController
        
        pages.append(page_1)
        pages.append(page_2)
        pages.append(page_3)
        
        setViewControllers([page_1], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.move_by_buttons(_:)), name: Notification.Name("move_by_buttons_forum"), object: nil)
    }
    
    @objc func move_by_buttons(_ sender:NSNotification) {
        let index = sender.object as! Int
        
        if index == 1 {
            self.setViewControllers([pages[index]], direction:.forward, animated:true, completion: nil)
        } else {
            self.setViewControllers([pages[index]], direction: .reverse, animated:true, completion: nil)
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController)-> UIViewController? {
        curr = pages.index(of: viewController)!
        
        NotificationCenter.default.post(name: NSNotification.Name (rawValue:"selected_forum"), object:curr)
        
        // if you prefer to NOT scroll circularly, simply add here:
        if curr == 0 { return nil }
        let prev = abs((curr - 1) % pages.count)
        return pages[prev]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController)-> UIViewController? {
        let current = pages.firstIndex(of: viewController)!
        NotificationCenter.default.post(name: NSNotification.Name (rawValue:"selected_forum"), object:current)
        if current == (pages.count - 1) { return nil }
        let nxt = abs((current + 1) % pages.count)
        return pages[nxt]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if (!completed) {
            return
        }
        
        if previousViewControllers[0] != pages[0] {
            NotificationCenter.default.post(name: Notification.Name("get_offset_set_view"), object: 0)
        } else {
            NotificationCenter.default.post(name: Notification.Name("get_offset_set_view"), object: UIScreen.main.bounds.width/2)
        }
    }
    
    
}

