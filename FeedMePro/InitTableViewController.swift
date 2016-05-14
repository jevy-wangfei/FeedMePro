//
//  InitTableViewController.swift
//  FeedMePro
//
//  Created by jevy on 20/03/2016.
//  Copyright © 2016 jevy.wf. All rights reserved.
//

import UIKit

class InitTableViewController: UITableViewController {
    
    var staple = [Dish]()
    var soup = [Dish]()
    var dessert = [Dish]()
    var drinks = [Dish]()
    var others = [Dish]()
    
//    @IBAction func stockDownUp(sender: UIButton) {
//        if ( sender.titleLabel?.text == "Disable"){
//            sender.setTitle("Active", forState: UIControlState.Normal)
//        }
//    }
    @IBAction func stockDownUp(sender: UIButton) {
        if ( sender.titleLabel?.text == "On Stock"){
            offStock(sender)
            FeedMe.Variable.dishes[sender.tag]?.status = 0
        }else{
           onStock(sender)
            FeedMe.Variable.dishes[sender.tag]?.status = 1
        }
        
    }
    
    func offStock(sender: UIButton){
        sender.setTitle("Out Stock", forState: UIControlState.Normal)
     
        sender.layer.backgroundColor = FeedMe.grayColor.CGColor
    }
    
//    @IBAction func initDishes(sender: UIBarButtonItem) {
//        let host = FeedMe.Path.TEXT_HOST+"restaurant/refreshMenu/?dishlog=" + getDishLog()
//        print(host)
//        let url = NSURL(string: host)
//        
//        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {
//            (myData, response, error) in
//            
//            dispatch_async(dispatch_get_main_queue(), {
//                if myData != nil {
//                    self.initSuccess(myData!)
//                }
//            })
//        }
//
//        task.resume()
//
//    }
    
    func getDishLog()->String{
        
        var dishLogs: String = "["
        
        let today = NSDate().dateByAddingTimeInterval(0)
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd";
        
        let dateToPrint = dateFormatter.stringFromDate(today)
        
        let dateFormatter2 = NSDateFormatter()
        dateFormatter2.timeZone = NSTimeZone(name: "UTC")
        dateFormatter2.dateFormat = "yyyy-MM-dd"
        let currentDate = dateFormatter2.dateFromString(dateToPrint)
        
        
        for everyDish in FeedMe.Variable.dishes{
            let dish = everyDish.1
            let dishLog = DishLog(ID: dish.ID, shopID: dish.shopID,status: dish.status,dat: currentDate!)
            dishLogs = dishLogs + (dishLog?.toJsonString())!+","
        }
        
        dishLogs = dishLogs + "]"
        
        //        do{
        //
        //        let json =  try NSJSONSerialization.dataWithJSONObject(dishLogs, options: NSJSONWritingOptions.PrettyPrinted)
        //
        //         return NSString(data: json, encoding: NSUTF8StringEncoding) as! String;
        //
        //        }catch{
        //            print(error)
        //        }
//        NSLog(dishLogs)
        return dishLogs
        
    }

    @IBAction func initDishes(sender: UIButton) {
        
        let url = FeedMe.Path.TEXT_HOST + "restaurant/refreshMenu"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
      
        request.HTTPBody = getDishLog().dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // NSLog("reuqest body: %@", request.HTTPBody!)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {
                // check for fundamental networking error
                NSLog("error: %@", error!)
                FeedMeAlert.alertSignUpFailure(self, message: "Unknown error")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {
                // check for http errors
                NSLog("statusCode should be 200, but is: %@", httpStatus.statusCode)
                NSLog("response: %@", response!)
                FeedMeAlert.alertSignUpFailure(self, message: "Unknown error")
                return
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            NSLog("response string: %@", responseString!)
        }
            task.resume()
        
    }
        
    func initSuccess(data:NSData){
        print(data)
    }
   
    
    func onStock(sender: UIButton){
        sender.setTitle("On Stock", forState: UIControlState.Normal)
        sender.layer.backgroundColor = FeedMe.redColor.CGColor
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FeedMe.Variable.images = [String: UIImage]()
        FeedMe.Variable.dishes = [Int: Dish]()
        
        self.setBackground(self)
        self.setBar(self)
        
        
        
//        var logButton : UIBarButtonItem = UIBarButtonItem(title: "RigthButtonTitle", style: UIBarButtonItemStyle.Plain, target: self, action: self.initDishes())
//  
//        self.navigationItem.rightBarButtonItem = logButton
        
        //Test only
        FeedMe.Variable.restaurantID = 18

        if(FeedMe.Variable.restaurantID != nil){
            
                        NSLog("RestaurantID = \(FeedMe.Variable.restaurantID!)");
            NSLog("URL: \(FeedMe.Path.TEXT_HOST)dishes/query/?shopId=\(FeedMe.Variable.restaurantID!)");
            loadAllDishes(FeedMe.Path.TEXT_HOST + "dishes/query/?shopId=\(FeedMe.Variable.restaurantID!)")
            //+ String(FeedMe.Variable.restaurantID!))
            //        loadAllDishes(FeedMe.Path.TEXT_HOST + "restaurant/checkin/?restaurantId=18")
        }else{
            NSLog("Restaurant ID is null, go to login view")
            //            let nextView = self.storyboard?.instantiateViewControllerWithIdentifier("login")
            //            self.presentViewController(nextView!, animated: true, completion:nil)
            self.dismissViewControllerAnimated(true, completion: nil)
        }

        
//        loadAllDishes(FeedMe.Path.TEXT_HOST + "dishes/query/?shopId=18")
            //+ String(FeedMe.Variable.restaurantID!))
//        loadAllDishes(FeedMe.Path.TEXT_HOST + "restaurant/checkin/?restaurantId=18")
        
    }
    
    func loadAllDishes(urlString: String) {
        let url = NSURL(string: urlString)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {
            (myData, response, error) in
            
            dispatch_async(dispatch_get_main_queue(), {
                if myData != nil {
                    self.setDishInfo(myData!)
                }
            })
        }
        
        task.resume()
    }
    
    func setDishInfo(dishData: NSData) {
        let json: Array<AnyObject>
        
        do {
            json = try NSJSONSerialization.JSONObjectWithData(dishData, options: .AllowFragments) as! Array<AnyObject>
            for index in 0...json.count-1 {
                
                if let ID = json[index]["id"] as?Int {
                    let shopID = json[index]["shopId"] as?Int
                    let type = json[index]["type"] as?String
                    let name = json[index]["name"] as?String
                    let description = json[index]["description"] as?String
                    
                    let ingredient = json[index]["ingredient"] as?String
                    let price = json[index]["price"] as?Int
                    let discount = json[index]["discount"] as?Int
                    let flavor = json[index]["flavor"] as?String
                    let sold = json[index]["sold"] as?Int
//                    let available = json[index]["available"] as? Bool
//                    print("Avaliable: \(available)");
                    
                    var photo: UIImage?
                    
                    var dish = Dish(ID: ID, shopID: shopID, type: type, name: name, description: description, photo: photo, ingredient: ingredient, price: price, discount: discount, flavor: flavor, sold: sold, status: 1)!
                    
                    // load image:
                    let photoName = json[index]["photo"] as?String
                    if photoName != nil {
                        if let _ = FeedMe.Variable.images![photoName!] {
                            photo = FeedMe.Variable.images![photoName!]
                            dish.setPhoto(photo)
                        } else {
                            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), {
                                self.setImageInBG(&dish, photoName: photoName)
                            })
                        }
                    }
                    
                    FeedMe.Variable.dishes[dish.ID] = dish
                    
                    switch dish.type! {
                    case DishType.Staple.rawValue:
                        staple += [dish]
                    case DishType.Soup.rawValue:
                        soup += [dish]
                    case DishType.Dessert.rawValue:
                        dessert += [dish]
                    case  DishType.Drinks.rawValue:
                        drinks += [dish]
                    default:
                        others += [dish]
                    }
                }
            }
            
            do_table_refresh()
            
        } catch _ {
            
        }
    }
    
    func setImageInBG(inout dish: Dish, photoName: String?) {
        let url = NSURL(string: FeedMe.Path.PICTURE_HOST + "img/photo/" + photoName!)
        let data = NSData(contentsOfURL : url!)
        let photo = UIImage(data : data!)
        
        dish.photo = photo!
        
        // Cache the newly loaded image:
        FeedMe.Variable.images![photoName!] = photo
        
        do_table_refresh()
    }
    
    func do_table_refresh()
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        switch section {
        case 0:
            return staple.count
        case 1:
            return soup.count
        case 2:
            return dessert.count
        case 3:
            return drinks.count
        case 4:
            return others.count
        default:
            return 0
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "InitTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! InitTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        
        
        var dish: Dish!
        switch indexPath.section {
        case 0:
            dish = staple[indexPath.row]
        case 1:
            dish = soup[indexPath.row]
        case 2:
            dish = dessert[indexPath.row]
        case 3:
            dish = drinks[indexPath.row]
        case 4:
            dish = others[indexPath.row]
        default:
            break
        }
        
        
        cell.dishName.text = dish.name
        cell.dishImg.image = dish.photo
        cell.dishImg.layer.cornerRadius=10.0
        cell.dishImg.layer.borderWidth = 1.0
        cell.dishImg.clipsToBounds = true

        var dishAvailable = "On Stock"
        
        if(dish.status == 0){
            dishAvailable = "Out Stock"
        }
        cell.offStock.setTitle(dishAvailable, forState: UIControlState.Normal)
        cell.offStock.layer.cornerRadius = 10.0
        cell.offStock.layer.borderWidth = 2.0
        cell.offStock.layer.borderColor = UIColor(white: 1.0, alpha: 1.0).CGColor
        cell.offStock.clipsToBounds = true;
        cell.offStock.tag = dish.ID
        
        if ((indexPath.row)%2 == 0){
            cell.backgroundColor = FeedMe.transColor4
            cell.dishImg.layer.borderColor = FeedMe.transColor4.CGColor
        }else{
            cell.backgroundColor = FeedMe.transColor7
            cell.dishImg.layer.borderColor = FeedMe.transColor7.CGColor
        }
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            FeedMe.Variable.dishID = staple[indexPath.row].ID
        case 1:
            FeedMe.Variable.dishID = soup[indexPath.row].ID
        case 2:
            FeedMe.Variable.dishID = dessert[indexPath.row].ID
        case 3:
            FeedMe.Variable.dishID = drinks[indexPath.row].ID
        case 4:
            FeedMe.Variable.dishID = others[indexPath.row].ID
        default:
            break
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return DishType.Staple.rawValue + " ( " + String(staple.count) + " )"
        case 1:
            return DishType.Soup.rawValue + " ( " + String(soup.count) + " )"
        case 2:
            return DishType.Dessert.rawValue + " ( " + String(dessert.count) + " )"
        case 3:
            return DishType.Drinks.rawValue + " ( " + String(drinks.count) + " )"
        case 4:
            return DishType.Others.rawValue + " ( " + String(others.count) + " )"
        default:
            return "Unclassfied"
        }
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
