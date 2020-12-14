//
//  ConnectionViewController.swift
//  Project 1
//
//  Created by Ryan Mitchell on 11/22/20.
//

import UIKit
import CoreData

class ConnectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var connectionTableView: UITableView!
    
    var connectionArray:Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradient: CAGradientLayer = CAGradientLayer()

        gradient.colors = [UIColor(red: 127/255, green: 223/255, blue: 255/255, alpha: 1.0).cgColor, UIColor(red: 1/255, green: 150/255, blue: 255/255, alpha: 1.0).cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        let backgroundView = UIView(frame: connectionTableView.bounds)
        backgroundView.layer.insertSublayer(gradient, at: 0)
        self.connectionTableView.backgroundView = backgroundView
        
        connectionTableView.tableFooterView = UIView()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        connectionTableView.delegate = self
        connectionTableView.dataSource = self

        let managedObjectContainer = DatabaseController.managedObjectContainer()

        let connectionFetchRequest:NSFetchRequest = Connection.fetchRequest()
        
        do{
            let fetchResults = try managedObjectContainer.viewContext.fetch(connectionFetchRequest)

            if( fetchResults.count > 0 ){

                for connection in fetchResults {
                    connectionArray.append(connection.name!.replacingOccurrences(of: "\\n*", with: "", options: .regularExpression) + "\n" + connection.userDesription!.replacingOccurrences(of: "\\n*", with: "", options: .regularExpression) + "\n" + connection.lookingFor!.replacingOccurrences(of: "\\n*", with: "", options: .regularExpression) + "\n" + connection.price!.replacingOccurrences(of: "\\n*", with: "", options: .regularExpression) + "\n" + connection.email!.replacingOccurrences(of: "\\n*", with: "", options: .regularExpression))
                }
            }
            else{
                connectionArray.append("You currently have no connections.")
                connectionTableView.reloadData()
            }
        }
        catch{
            print(exception.self)
        }
        print(connectionArray)
        connectionTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connectionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = connectionArray[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.backgroundColor = UIColor(red: 200/255, green: 230/255, blue: 255/255, alpha: 1.0)
        
        return cell
    }
}
