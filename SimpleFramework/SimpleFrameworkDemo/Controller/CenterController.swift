//
//  CenterController.swift
//  SimpleFramework
//
//  Created by admin on 16/7/5.
//  Copyright © 2016年 egg. All rights reserved.
//

import UIKit
import SimpleFramework

class CenterController: SimpleController {
    @IBOutlet weak var tableView: UITableView!

    var originY:CGFloat?
    var lastY:CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        // Do any additional setup after loading the view.
        addRecognizerOnNavigationController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

extension CenterController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "row:\(indexPath.row)"
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension CenterController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)")
    }
}

//MARK: - NavigationController滑动隐藏
extension CenterController:UIScrollViewDelegate {
    
    
    //开始拖拽
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        originY = scrollView.contentOffset.y
        lastY = originY
    }
    
    //正在拖拽
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //控制器第一次显示的时候，会调用一次这个方法，而不调用上一个方法，所以要在这里做一层判断
        //print("scrollViewDidSroll y:\(scrollView.contentOffset.y)")
        
        guard let naviCtl = self.navigationController else {
            return
        }
        
        guard let last = lastY else {
            return
        }
        
        let distance = scrollView.contentOffset.y - last
        
        if (distance >= 0) {
            if naviCtl.navigationBar.frame.origin.y <= CGFloat(-44.0) {
                naviCtl.navigationBar.transform = CGAffineTransform(translationX: 0, y: -64)
                return
            }
        } else {
            if naviCtl.navigationBar.frame.origin.y >= CGFloat(20.0) {
                naviCtl.navigationBar.transform = CGAffineTransform(translationX: 0, y: 0)
                return
            }
        }
        
        lastY = scrollView.contentOffset.y
        if originY != nil {
            if scrollView.contentOffset.y - originY! > 64 {
                naviCtl.navigationBar.transform = CGAffineTransform(translationX: 0, y: -64)
            } else if originY! - scrollView.contentOffset.y > 64 {
                naviCtl.navigationBar.transform = CGAffineTransform(translationX: 0, y: 0)
            }
        } else {
            naviCtl.navigationBar.transform = CGAffineTransform(translationX: 0, y: -distance)
        }
    }
    
    //拖拽结束
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        navigationBarAnimation(scrollView: scrollView)
        //print("scrollViewDidEndDragging y:\(scrollView.contentOffset.y)")
        lastY = nil
        originY = nil
    }
    
    //减速结束
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //print("scrollViewDidEndDecelerating y:\(scrollView.contentOffset.y)")
        navigationBarAnimation(scrollView: scrollView)
        lastY = nil
        originY = nil
    }
    
    func navigationBarAnimation(scrollView: UIScrollView) {
        if let y = self.navigationController?.navigationBar.frame.origin.y {
            //print("y:\(y) ")
            if y == 20 {
                return
            }
            
            if y > -11 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.navigationController?.navigationBar.transform = CGAffineTransform(translationX: 0, y: -64)
                })
            } else {
                
            }
            if scrollView.contentOffset.y < 0 {
                scrollView.setContentOffset(CGPoint.zero, animated: true)
            }
        }
        
    }
}
