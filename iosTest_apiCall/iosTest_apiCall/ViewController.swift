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
        
        tblViwHome.dataSource = self
        tblViwHome.delegate = self
        
        tblViwHome.register(clsTeamTableViewCell.self, forCellReuseIdentifier: "rowCell")
        
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
//MARK: - extension for table view methods
extension ViewController : UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
//MARK: - extension for table view methods
extension ViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrHomeData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rowCell", for: indexPath) as! clsTeamTableViewCell
        let ent = arrHomeData[indexPath.row]
        cell.nameLabel.text = ent.title
        cell.detailLabel.text = ent.description
        cell.imgProfile.sd_setImage(with: URL(string: ent.imageHref ?? ""))
        cell.selectionStyle = .none
        return cell
    }
}

class clsTeamTableViewCell: UITableViewCell
{
    let nameLabel = UILabel()
    let detailLabel = UILabel()
    let imgProfile = UIImageView()
    
    // MARK: Initalizers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let marginGuide = contentView.layoutMarginsGuide
        
        contentView.addSubview(imgProfile)
        imgProfile.translatesAutoresizingMaskIntoConstraints = false
        imgProfile.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        imgProfile.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant:10).isActive = true
        imgProfile.widthAnchor.constraint(equalToConstant:70).isActive = true
        imgProfile.heightAnchor.constraint(equalToConstant:70).isActive = true
        imgProfile.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: marginGuide.topAnchor, multiplier: 1.0).isActive = true
        // imgProfile.bottomAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: marginGuide.bottomAnchor, multiplier: 1.0).isActive = true
        
        imgProfile.layer.cornerRadius = 35
        imgProfile.clipsToBounds = true
        
        // configure titleLabel
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant:90).isActive = true
        //nameLabel.leadingAnchor.constraint(equalTo: imgProfile.leadingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.systemFont(ofSize: 16)//UIFont(name: "AvenirNext-DemiBold", size: 16)
        
        // configure authorLabel
        contentView.addSubview(detailLabel)
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant:90).isActive = true
        //        detailLabel.leadingAnchor.constraint(equalTo: imgProfile.leadingAnchor).isActive = true
        detailLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        detailLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        detailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        detailLabel.numberOfLines = 0
        detailLabel.font = UIFont.systemFont(ofSize: 12)
        detailLabel.textColor = UIColor.lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
}

