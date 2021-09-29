//
//  CoreDataSupport.swift
//  Ringtone
//
//  Created by Twinbit Sabuj on 19/1/20.
//  Copyright © 2020 Twinbit. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager{
    
    static let shared = CoreDataManager()
    
    init(){}
    
    
    class func insertData(folder_name:String, image_name : String, mark : Bool){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let contact = NSEntityDescription.insertNewObject(forEntityName: "PhotoGallery", into: context) as! PhotoGallery
        
        contact.folderName = folder_name
        contact.isFavourite = mark
        contact.urls = image_name

        do {
            
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    class func updateData(newName : String, oldName : String){
        
        
        var listArray = [PhotoGallery]()
        
        let request : NSFetchRequest <PhotoGallery>  = PhotoGallery.fetchRequest()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        request.predicate = NSPredicate(format: "folderName = %@", oldName)
        
        do{
            listArray = try context.fetch(request)
            for data in listArray{
                if(data.folderName == oldName){
                    let contact = NSEntityDescription.insertNewObject(forEntityName: "PhotoGallery", into: context) as! PhotoGallery
                    context.delete(data)
                    contact.folderName = newName
                    
                    contact.urls = data.urls
                    
                }
            }
            do {
                
                try context.save()
            } catch {
                print("Failed saving")
            }
        }
        catch{
            print("Error loading data \(error)")
        }
        
    }
   
    class func deleteData(name : String){
        
        var listArray = [PhotoGallery]()
        
        let request : NSFetchRequest <PhotoGallery>  = PhotoGallery.fetchRequest()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        request.predicate = NSPredicate(format: "folderName = %@", name)
         do
         {
             listArray = try context.fetch(request)
                 for data in listArray{
                     if(data.folderName == name){
                        
                         context.delete(data)
                     }
                 }
                 do {
                     
                     try context.save()
                 } catch {
                     print("Failed saving")
                 }
             }
             catch{
                 print("Error loading data \(error)")
             }
    }
    
    class func deleteFromFavourite(name: String)
    {
        var listArray = [PhotoGallery]()
        
        let request : NSFetchRequest <PhotoGallery>  = PhotoGallery.fetchRequest()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        request.predicate = NSPredicate(format: "urls = %@", name)
        
        do
        {
            listArray = try context.fetch(request)
                for data in listArray{
                    if(data.urls == name){
                       
                        context.delete(data)
                    }
                }
                do {
                    
                    try context.save()
                } catch {
                    print("Failed saving")
                }
            }
            catch{
                print("Error loading data \(error)")
            }
        
        
        
        
        
        
    }
    
    
    
    
    
    
    class func fetchData() -> [PhotoGallery]{
        var listArray = [PhotoGallery]()
        
        let request : NSFetchRequest <PhotoGallery>  = PhotoGallery.fetchRequest()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        do{
            listArray = try context.fetch(request)
            return listArray
        }
        catch{
            print("Error loading data \(error)")
        }
        return listArray
    }
    
}

