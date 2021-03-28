//
//  CoreData.swift
//  PostalCode
//
//  Created by Gustavo Quenca on 27/03/21.
//

import Foundation
import UIKit
import CoreData

struct CoreData {

    func createData(data: [PostalCode]){

        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext

        //Now let’s create an entity and new user records.
        let userEntity = NSEntityDescription.entity(forEntityName: "PostalCodePortugal", in: managedContext)!

        //final, we need to add some data to our newly created record for each keys using

        for object in data {

            let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
            user.setValue(object.nome_localidade, forKey: "nome_localidade")
            user.setValue(object.num_cod_postal, forKey: "num_cod_postal")

        }

        //Now we have set all the values. The next step is to save them inside the Core Data

        do {
            try managedContext.save()

        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }


    func retrieveData() -> [PostalCode] {

        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return []}

        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext

        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PostalCodePortugal")

        var postalCodeList = [PostalCode]()

        do {
            let result = try managedContext.fetch(fetchRequest)

            for data in result {
                let postalCode = PostalCode(nome_localidade: data.value(forKey: "nome_localidade") as? String, num_cod_postal: data.value(forKey: "num_cod_postal") as? String)

                postalCodeList.append(postalCode)
            }
        } catch {

            print("Failed")
        }
        return postalCodeList
    }
    
    func filterData(with searchText: String ) -> [PostalCode] {
        
        var postalCodeList = [PostalCode]()
        
        var predicate: NSPredicate = NSPredicate()
        predicate = NSPredicate(format: "nome_localidade contains[c] '\(searchText)'")
        
        var predicateCod: NSPredicate = NSPredicate()
        predicateCod = NSPredicate(format: "num_cod_postal contains[c] '\(searchText)'")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            let empty: [PostalCode] = []
            return empty
        }
        
        let predicateCompound = NSCompoundPredicate(type: .or, subpredicates: [predicate,predicateCod])
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PostalCodePortugal")
        fetchRequest.predicate = predicateCompound
        
        
        do {
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            
            for data in result {
                let postalCode = PostalCode(nome_localidade: data.value(forKey: "nome_localidade") as? String, num_cod_postal: data.value(forKey: "num_cod_postal") as? String)

                postalCodeList.append(postalCode)
            }
        } catch {
            print("error")
        }
        
        return  postalCodeList
    }
}

