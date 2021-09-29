//
//  FavouriteViewController.swift
//  File Manager V1
//
//  Created by Ikhtiar Ahmed on 11/25/20.
//

import UIKit
import CoreData

protocol UpdateTableViewDelegate {
    func updateTableView()
}

class FavouriteViewController: UIViewController,FavouriteCellDlegate {
    
    @IBOutlet weak var favouriteTableView : UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var folderName : String = ""
    var delegate1 : UpdateTableViewDelegate!
    var myDocArray = NSMutableArray()
    var photos = [PhotoGallery]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setUpTableView()
        photos = CoreDataManager.fetchData()
        favouriteTableView.tableFooterView = UIView()
        favouriteTableView.reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        photos = CoreDataManager.fetchData()
        self.setUpTableView()
        
        self.getImageFromDocumentDirectory()
        if(photos.count > 0){
            folderName = photos[0].folderName!
        }
        favouriteTableView.reloadData()
        if(photos.count < 1){
            checkEmpty()
            
        }
    }
    
    func modifyFolder(a : String, b : String, targetString : String) -> String{
           var newString = targetString
           newString = newString.replacingOccurrences(of: a, with: b, options: NSString.CompareOptions.literal, range: nil)
           return newString
    }
    
    func checkEmpty(){
        let alert = UIAlertController(title: "", message: "Empty Folder", preferredStyle: .alert)
        
        self.present(alert, animated: true, completion: nil)

        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when){
          alert.dismiss(animated: true, completion: nil)
        }
        let subview = (alert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        subview.layer.cornerRadius = 1
        subview.backgroundColor = .gray
        subview.alpha = CGFloat(1.0)
        
    }
    
    func notify(text : String){
        let alert = UIAlertController(title: text, message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .default){(action) in
            
            self.dismiss(animated: true, completion: nil)
            
        }
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    func setUpTableView(){
        favouriteTableView.delegate = self
        
        favouriteTableView.dataSource = self
        
        favouriteTableView.register(UINib(nibName: "FavouriteTableViewCell", bundle: nil), forCellReuseIdentifier: "FavouriteTableViewCell")
        
        favouriteTableView.tableFooterView = UIView.init()
        
    }
    
    func getImageFromDocumentDirectory(){
        
        let fileManager = FileManager.default
        
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("folderName")
 
        let documentsURL = URL(fileURLWithPath: paths)
        
        do {
            
            let fileArray : NSArray = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil) as NSArray
            
            myDocArray = fileArray.mutableCopy() as! NSMutableArray
            
        } catch {
            self.notify(text : "Not Found")
        }
        
        favouriteTableView.reloadData()
        
    }
    
    func saveData(){
        do{
            try context.save()
        } catch{
            self.notify(text : "Not Found")
        }
        self.favouriteTableView.reloadData()
    }
}


extension FavouriteViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favouriteTableView.dequeueReusableCell(withIdentifier: "FavouriteTableViewCell", for: indexPath) as! FavouriteTableViewCell
        
        cell.delegate = self
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("folderName")

        let documentsURL = URL(fileURLWithPath: paths).appendingPathComponent(modifyFolder(a: " ", b: "x", targetString: photos[indexPath.row].folderName!)).appendingPathComponent("thumb1/\(photos[indexPath.row].urls!)")
        
        let image = UIImage(contentsOfFile: documentsURL.path)
        
        cell.favouriteFolderImage.image = image
        cell.folderNameLabel.text = photos[indexPath.row].urls
        cell.favouriteButton.setImage(UIImage(named: "favorite"), for: .normal)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
        
    }
    
    func favouriteCellButtonTapped(cell: FavouriteTableViewCell){
        let indexPath = self.favouriteTableView.indexPath(for: cell)
        let imageName = photos[indexPath!.row].urls
        
            if UserDefaults.standard.string(forKey: imageName!) == "marked"
            {
                UserDefaults.standard.set("unmarked", forKey: imageName!)
                CoreDataManager.deleteFromFavourite(name: imageName!)
            }
            else
            {
                UserDefaults.standard.set("marked", forKey: imageName!)
                
            }
        photos = CoreDataManager.fetchData()
        
        self.favouriteTableView.reloadData()
        

    }
}
