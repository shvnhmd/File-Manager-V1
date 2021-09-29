//
//  FolderViewController.swift
//  File Manager V1
//
//  Created by Ikhtiar Ahmed on 11/29/20.
//

import UIKit
//import BSImagePicker
import Photos


class FolderViewController: UIViewController , UINavigationControllerDelegate , UIImagePickerControllerDelegate {
    
    
    
    @IBOutlet weak var navBarSample: UINavigationBar!
    
    @IBOutlet weak var folderTableView : UITableView!
    
    var myDocArray = NSMutableArray()
    var isEditMode = false
    var folderPhoto = NSMutableArray()
    //var photos = [PhotoGallery]()
    var indexPath: Int?
    var selectedFolderName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addTapped))
        
        // Do any additional setup after loading the view.
        
        
        folderTableView.delegate = self
        folderTableView.dataSource = self
        folderTableView.register(ImageTableViewCell.nib(), forCellReuseIdentifier: ImageTableViewCell.idetifier)
        
        getImage()
        folderTableView.reloadData()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        folderTableView.reloadData()
    }
    
    
    
    func getUIImage(asset: PHAsset) -> UIImage? {
        
        var img: UIImage?
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        manager.requestImageData(for: asset, options: options) { data, _, _, _ in
            
            if let data = data {
                img = UIImage(data: data)
            }
        }
        return img
    }
    
    
    
    func getDate() -> String{
        
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        let fileName =  "\(year)-\(month)-\(day)-\(hour)-\(minutes)-\(seconds).jpg"
        return fileName
    }
    
    
    func getImage()
    {
        let fileManager = FileManager.default
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("folderName").appendingPathComponent("\(selectedFolderName!)/thumb1")
        
        do {
            
            let fileArray : NSArray = try fileManager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil) as NSArray
            
            myDocArray = fileArray.mutableCopy() as! NSMutableArray
            
        } catch {
            print("Error while enumerating files \(documentsDirectory.path): \(error.localizedDescription)")
        }
        
    }
    func saveImage(folder_name: String,image: UIImage)
    {
        let fileManager = FileManager.default
        
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("folderName/\(folder_name)/thumb1")
        
        do {
            try fileManager.createDirectory(atPath: documentsDirectory.path, withIntermediateDirectories: false, attributes: nil)
        } catch let error as NSError {

            print(error.localizedDescription);
        }
        let uuid = UUID().uuidString
        let fileName = "\(uuid).jpg"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        if let data = image.jpegData(compressionQuality:  0.5) {
            do {
                try data.write(to: fileURL)
                self.getImage()
                self.folderTableView.reloadData()
                print("Main image file saved")
            } catch {
                print("error saving file:", error)
            }
        }
    }
    
    
    func deleteImage(folderName : String , itemName : String){
        
        let fileManager = FileManager.default
        
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("folderName/\(folderName)/thumb1")
        
        let urlPath = documentsDirectory.appendingPathComponent(itemName)
        
        
        
        if fileManager.fileExists(atPath: urlPath.path) {
            
            try! fileManager.removeItem(atPath: urlPath.path)
            CoreDataManager.deleteFromFavourite(name: itemName)
            //CoreDataManager.fetchData()
            print("item deleted successfully from folder")
            self.folderTableView.reloadData()
        }
        else{
            print("file  doesn't exists")
            self.folderTableView.reloadData()
        }
    }
    
    
    func modifyFolder(a : String, b : String, targetString : String) -> String{
        var newString = targetString
        newString = newString.replacingOccurrences(of: a, with: b, options: NSString.CompareOptions.literal, range: nil)
        return newString
    }
    
    @objc func addTapped()
    {
//        let imagePicker = ImagePickerController()
//        imagePicker.settings.selection.max = 5000
//        imagePicker.settings.theme.selectionStyle = .checked
//        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
//        imagePicker.settings.selection.unselectOnReachingMax = true
//        
//        // let start = Date()
//        self.presentImagePicker(imagePicker, select: { (asset) in
//            print("Selected: \(asset)")
//        }, deselect: { (asset) in
//            print("Deselected: \(asset)")
//        }, cancel: { (assets) in
//            print("Canceled with selections: \(assets)")
//        }, finish: { (assets) in
//            print("Finished with selections: \(assets)")
//            
//            
//            for item in assets{
//                let image = self.getUIImage(asset: item)
//                self.saveImage(folder_name: self.selectedFolderName!, image: image!)
//    
//            }
//            
//        }, completion: {})
        
        
        
    }
}


//MARK: Extension function tableview

extension FolderViewController: UITableViewDelegate, UITableViewDataSource , FavouriteCellDelegate {
    func favButtonTapped(cell: ImageTableViewCell) {
       
        self.indexPath = self.folderTableView.indexPath(for: cell)!.row
        let imagePath: URL = myDocArray[indexPath!] as! URL
        let imageName = imagePath.lastPathComponent
        
        let folderName = self.selectedFolderName
        
        if (UserDefaults.standard.string(forKey: imageName) != nil)
        {
            if UserDefaults.standard.string(forKey: imageName) == "marked"
            {
                UserDefaults.standard.set("unmarked", forKey: imageName)
                CoreDataManager.deleteFromFavourite(name: imageName)
            }
            else
            {
                UserDefaults.standard.set("marked", forKey: imageName)
                CoreDataManager.insertData(folder_name: folderName!, image_name: imageName, mark: true)
            }
        }
        else
        {
            UserDefaults.standard.set("marked", forKey: imageName)
            
            CoreDataManager.insertData(folder_name: folderName!, image_name: imageName, mark: true)
        }
        
            self.folderTableView.reloadData()
        
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myDocArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as! ImageTableViewCell
        
        let imagePath: URL = myDocArray[indexPath.row] as! URL
        let imageName = imagePath.lastPathComponent
        
        let image =  UIImage(contentsOfFile: imagePath.path)
        
        if UserDefaults.standard.string(forKey: imageName) == "marked"
        {
            
            cell.favButton.setImage(UIImage(named: "favorite"), for: UIControl.State.normal)
            
        }
        else{
            cell.favButton.setImage(UIImage(named: "nonfavourite"), for: UIControl.State.normal)
        }
        cell.imageView!.image = image
        cell.delegate = self
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let imagePath = self.myDocArray[indexPath.row] as? URL
            let imageName = imagePath?.lastPathComponent
            
            let folderName = selectedFolderName!
            deleteImage(folderName: folderName , itemName: imageName!)
            
            getImage()
            folderTableView.reloadData()
            
            
        }
        
    }
    
}

