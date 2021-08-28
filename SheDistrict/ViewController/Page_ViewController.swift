//
//  Page_.swift
//  SheDistrict
//
//  Created by appentus on 1/6/20.
//  Copyright © 2020 appentus. All rights reserved.
//

import UIKit

class page: UIPageViewController , UIPageViewControllerDelegate, UIPageViewControllerDataSource , UIScrollViewDelegate{
    
    var pages = [UIViewController]()
    var curr = Int()
    var current = Int()
    
    var last_x : CGFloat = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        let home_VC = storyboard?.instantiateViewController(withIdentifier: "Home_ViewController") as! Home_ViewController
        let search_VC = storyboard?.instantiateViewController(withIdentifier: "Search_ViewController") as! Search_ViewController
        let calendar_VC = storyboard?.instantiateViewController(withIdentifier: "Event_ViewController") as! Event_ViewController
        let message_VC = storyboard?.instantiateViewController(withIdentifier: "Message_ViewController") as! Message_ViewController
        let more_VC = storyboard?.instantiateViewController(withIdentifier: "More_ViewController") as! More_ViewController
        
        pages.append(home_VC)
        pages.append(search_VC)
        pages.append(calendar_VC)
        pages.append(message_VC)
        pages.append(more_VC)
        
        setViewControllers([home_VC], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.move_by_buttons(_:)), name: Notification.Name("move_by_buttons"), object: nil)
        
        for views in self.view.subviews{
            if views.isKind(of: UIScrollView.self){
                let v = views as? UIScrollView
                v?.isScrollEnabled = false
            }
        }
    }
    
    @objc func move_by_buttons(_ sender:NSNotification) {
        self.setViewControllers([pages[sender.object as! Int]], direction: .forward, animated: false, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController)-> UIViewController? {
        curr = pages.index(of: viewController)!
        
        // if you prefer to NOT scroll circularly, simply add here:
        if curr == 0 { return nil }
        let prev = abs((curr - 1) % pages.count)
        return pages[prev]
        
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController)-> UIViewController? {
        
        let current = pages.firstIndex(of: viewController)!
        // if you prefer to NOT scroll circularly, simply add here:
        if current == (pages.count - 1) { return nil }
        let nxt = abs((current + 1) % pages.count)
        return pages[nxt]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        if (!completed)
        {
            return
        }
        if previousViewControllers[0] != pages[0]{
            NotificationCenter.default.post(name: Notification.Name("get_offset_set_view"), object: 0)
        }else{
            NotificationCenter.default.post(name: Notification.Name("get_offset_set_view"), object: UIScreen.main.bounds.width/2)
        }
    }
    
    
}

