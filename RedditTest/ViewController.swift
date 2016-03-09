//
//  ViewController.swift
//  RedditTest
//
//  Created by taiwei.tseng on 2016/3/9.
//  Copyright © 2016年 taiwei.tseng. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ErrorType {
    var tableData = [];
    @IBOutlet weak var redditListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getRedditJSON("http://reddit.com/.json")
    }

    func parseJson(data: NSData) -> NSMutableDictionary{
        var newData:NSMutableDictionary?;
        do{
            newData = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as?NSMutableDictionary
        }catch{
            print("error")
        }
        return newData!;
    }
    
    func getRedditJSON(whichReddit : String){
        let mySession = NSURLSession.sharedSession()
        let url: NSURL = NSURL(string: whichReddit)!
        let networkTask = mySession.dataTaskWithURL(url, completionHandler : {data, response, error -> Void in
            let theJSON = self.parseJson(data!)
            let results : NSArray = theJSON["data"]!["children"] as! NSArray
            dispatch_async(dispatch_get_main_queue(), {
                self.tableData = results
                self.redditListTableView!.reloadData()
            })
        })
        networkTask.resume()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        let redditEntry : NSMutableDictionary = self.tableData[indexPath.row] as! NSMutableDictionary
        if (redditEntry["data"] != nil) {
            cell.textLabel!.text = redditEntry["data"]!["title"] as? String
            cell.detailTextLabel!.text = redditEntry["data"]!["author"] as? String
        }else{
            print("loadin")
            cell.textLabel!.text = "Loading"
            cell.detailTextLabel!.text = ""
            
        }
        return cell
    }


}

