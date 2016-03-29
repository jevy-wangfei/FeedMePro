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
            sender.setTitle("Out Of Stock", forState: UIControlState.Normal)
            sender.layer.backgroundColor = UIColor(red:153/255,green:153/255,blue:153/255, alpha: 1.0).CGColor
        }else{
            sender.setTitle("On Stock", forState: UIControlState.Normal)
            sender.layer.backgroundColor = UIColor(red:254/255, green:169/255, blue:68/255, alpha: 1.0).CGColor
        }
        
    }
//    func loadSampleMeals(){
//        let photo2 = UIImage(named: "meal2")!
//        let photo3 = UIImage(named: "meal3")!
//        let photo4 = UIImage(named: "meal4")!
//        let photo5 = UIImage(named: "meal5")!
//
//        let meal1 = Dish(name: "Caprese Salad", photo: photo2, btn: "On Stock")
//        
//        
//        let meal2 = Dish(name: "Chicken and Potatoes", photo: photo3, btn: "On Stock")
//        
//        let meal3 = Dish(name: "Pasta with Meatballs and salad", photo: photo4, btn: "On Stock")
//        let meal4 = Dish(name: "Praw with Meatballs", photo: photo5, btn: "On Stock")
//        dishes += [meal1,meal2,meal3, meal4]
//    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FeedMe.Variable.images = [String: UIImage]()
        FeedMe.Variable.dishes = [Int: Dish]()
        
        let bgImage = UIImage(named:"background.png")
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.image = bgImage
        
        self.view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
        


        
//        self.navigationController?.navigationBar.addSubview(imageView)
//        self.navigationController?.navigationBar.sendSubviewToBack(imageView)
//        self.navigationController?.navigationBar.translucent = true;


//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
//        loadSampleMeals()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        loadAllDishes(FeedMe.Path.TEXT_HOST + "dishes/query/?shopId=18")
            //+ String(FeedMe.Variable.restaurantID!))
        
        let nav = self.navigationController?.navigationBar
        
        nav?.tintColor = UIColor.whiteColor()
        nav?.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        let ngColor = UIColor(red: 203/255, green:41/225, blue: 10/255, alpha: 1)
        nav?.backgroundColor = ngColor
        nav?.barTintColor = ngColor
        self.tabBarController?.tabBar.backgroundColor = ngColor
        self.tabBarController?.tabBar.barTintColor = ngColor
        
        self.navigationController?.toolbarHidden = false
        self.navigationController?.toolbar.backgroundColor = ngColor
        self.navigationController?.toolbar.barTintColor = ngColor
        self.navigationController?.toolbar.tintColor = UIColor.whiteColor()
        self.navigationController?.toolbar.translucent  = true

        
    }
    
    func loadAllDishes(urlString: String) {
        let url = NSURL(string: urlString)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {
            (myData, response, error) in
            
            dispatch_async(dispatch_get_main_queue(), {
                self.setDishInfo(myData!)
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
                    
                    var photo: UIImage?
                    
                    var dish = Dish(ID: ID, shopID: shopID, type: type, name: name, description: description, photo: photo, ingredient: ingredient, price: price, discount: discount, flavor: flavor, sold: sold)!
                    
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

        
        cell.offStock.setTitle(dish.type, forState: UIControlState.Normal)
        cell.offStock.layer.cornerRadius = 10.0
        cell.offStock.layer.borderWidth = 2.0
        cell.offStock.layer.borderColor = UIColor(white: 1.0, alpha: 1.0).CGColor
        cell.offStock.clipsToBounds = true;
        
        if ((indexPath.row)%2 == 0){
            cell.backgroundColor = UIColor(red:255/255, green:255/255, blue:255/255, alpha: 0.5)
            cell.dishImg.layer.borderColor = UIColor(red:255/255, green:255/255, blue:255/255, alpha: 0.5).CGColor
        }else{
            cell.backgroundColor = UIColor(red:255/255, green:255/255, blue:255/255, alpha: 0.6)
            cell.dishImg.layer.borderColor = UIColor(red:255/255, green:255/255, blue:255/255, alpha: 0.6).CGColor
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
