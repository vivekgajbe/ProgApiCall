//
//  ViewController.swift
//  iosTest_apiCall
//
//  Created by vivek G on 16/04/20.
//  Copyright © 2020 vivek G. All rights reserved.
//

import UIKit

struct Facts:Codable {
    let title: String
    let rows: [Rows]!
}
struct Rows:Codable {
    var title: String?
    var description: String?
    var imageHref: String?
}


class ViewController: UIViewController
{

    var arrHomeData = [Rows]()
    var tblViwHome = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setControllerPrefrences()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK: - User define method
    func setControllerPrefrences()
    {
        self.view.backgroundColor = .white
        
        view.addSubview(tblViwHome)
        
        tblViwHome.translatesAutoresizingMaskIntoConstraints = false
        
        tblViwHome.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        tblViwHome.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tblViwHome.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tblViwHome.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        tblViwHome.estimatedRowHeight = 80
        tblViwHome.rowHeight = UITableView.automaticDimension
        
//        tblViwHome.dataSource = self
//        tblViwHome.delegate = self
        
//        tblViwHome.register(clsTeamTableViewCell.self, forCellReuseIdentifier: "rowCell")
        
        self.getMatchesResultList()
    }
    //MARK: - api call
    //method is used for gettting viewed Team list
    func getMatchesResultList()
    {
        let objRequest = RequestManager()
        let strUrl = UrlConstants.homeUrl
        
        let dictMyContact = [String:Any]()
        
        Utility.shared.showLoader()
        objRequest.requestCommonApiMethodCall_WithParam(strAPIName: strUrl, strMethodType: "GET", strParameterName: dictMyContact)
        { (result, isSuccess, error) in
            
            Utility.shared.hideLoader()
            if isSuccess{
                let entData = result as! Facts
                
                self.arrHomeData = entData.rows
                //print(self.arrHomeData)
                
                DispatchQueue.main.async {
                    self.navigationItem.title = entData.title
                    //Constants.APP_DEL.navigationController.title = entData.title
                    self.tblViwHome.reloadData()
                }
                
            }
            else
            {
                
                self.view.makeToast(message: error)
            }
        }
    }
}
