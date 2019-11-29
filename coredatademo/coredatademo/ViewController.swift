//
//  ViewController.swift
//  coredatademo
//
//  Created by Edgar Penate on 11/27/19.
//  Copyright © 2019 Edgar Penate. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController, UITableViewDataSource {
  
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return names.count
        return people.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let person = people[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        //cell.textLabel?.text = names[indexPath.row]
        cell.textLabel?.text = person.value(forKey: "name") as? String
        return cell
        
    }
    

    
    //var names: [String] = []
    var people :[NSManagedObject] = []
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addName(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Nuevo Cliente",
                                      message: "Nuevo ",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Guardar",
                                       style: .default) {
          [unowned self] action in
                                        
          guard let textField = alert.textFields?.first,
            let nameToSave = textField.text else {
              return
          }
          
         // self.names.append(nameToSave)
                                        
          self.save(name:nameToSave)
                                        
          self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar",
                                         style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
        
        
    }
    
    ///este es el metodo para guardar cuando core data ya esta habilitado !!!!
    
    func save(name: String) {
      
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
        return
      }
      
      // 1
      let managedContext =
        appDelegate.persistentContainer.viewContext
      
      // 2
      let entity =
        NSEntityDescription.entity(forEntityName: "Person",
                                   in: managedContext)!
      
      let person = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
      // 3
      person.setValue(name, forKeyPath: "name")
      
      // 4
      do {
        try managedContext.save()
        people.append(person)
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }
    
    
    ////// para ir a leer de core data
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      //1
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
          return
      }
      
      let managedContext =
        appDelegate.persistentContainer.viewContext
      
      //2
      let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "Person")
      
      //3
      do {
        people = try managedContext.fetch(fetchRequest)
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Las Lista"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        
    }
    


}

