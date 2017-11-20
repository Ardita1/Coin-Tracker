import UIKit
import CoreData
//Klasa permbane tabele kshtuqe duhet te kete
//edhe protocolet per tabela
class FavoritetController: UIViewController, UITableViewDataSource, UITableViewDelegate{
   
    @IBOutlet weak var tableView: UITableView!
   
    var allcoin=[CoinCellModel]()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return allcoin.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coinCell") as! CoinCell
        cell.lblEmri.text = allcoin[indexPath.row].coinName
        cell.lblAlgoritmi.text = allcoin[indexPath.row].coinAlgo
        cell.lblSymboli.text = allcoin[indexPath.row].coinSymbol
        cell.lblTotali.text = allcoin[indexPath.row].totalSuppy
        cell.imgFotoja.af_setImage(withURL: URL(string:allcoin[indexPath.row].coinImage())!)
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Lexo nga CoreData te dhenat dhe ruaj me nje varg
        //qe duhet deklaruar mbi funksionin UIViewController
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
         let context = appdelegate.persistentContainer.viewContext
        
        tableView.dataSource=self
        tableView.delegate=self
        tableView.register(UINib.init(nibName: "CoinCell", bundle: nil), forCellReuseIdentifier: "coinCell")
        
       //Lexojme te dhenat
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"Favorites")
        request.returnsObjectsAsFaults = false
        
        do{
            let rezultati = try context.fetch(request)
            if rezultati.count > 0 {
                for item in rezultati as! [NSManagedObject]{
                   
                  
                    
                                            let Algo = item.value(forKey: "coinAlgo") as! String
                                            print(Algo)
                    
                                            let name = item.value(forKey: "coinName") as! String
                                            print(name)
                    
                                            let Symbol = item.value(forKey: "coinSymbol") as! String
                                            print(Symbol)
                    
                                            let image = item.value(forKey: "imagePath") as! String
                                            print(image)
                    
                                            let totalSuppy = item.value(forKey: "totalSuppy") as! String
                                            print(totalSuppy)
                    
                          let coincell = CoinCellModel(coinName: name, coinSymbol: Symbol, coinAlgo: Algo, totalSuppy: totalSuppy, imagePath: image)
                          allcoin.append(coincell)
                    
                                        }
                tableView.reloadData()
                
                
            }
                
                               else {
                                        print("Nuk ka elemente")
                                    }
            
                    }  catch  {
                                    print("Gabim gjate leximit")
                                }
                }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            
            fshije(coin: allcoin[indexPath.row].coinSymbol)
              self.allcoin.remove(at: indexPath.row)
              self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
       
    }
    
    func fshije(coin: String){
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"Favorites")
        request.predicate = NSPredicate(format: "coinSymbol = %@" , coin)
        request.returnsObjectsAsFaults = false
        
        do{
            let rezultati = try! context.fetch(request)
            if rezultati.count > 0 {
            for elementi in rezultati as! [NSManagedObject] {
                context.delete(elementi)
                
            }
             try!   context.save()
        }
    
        }
        
        
    }
    
    
    
    
    @IBAction func kthehu(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
