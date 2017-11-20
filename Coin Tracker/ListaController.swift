import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage

//Duhet te jete conform protocoleve per tabele
class ListaController: UIViewController, UITableViewDelegate ,UITableViewDataSource {

     //Krijo IBOutlet tableView nga View
         @IBOutlet weak var tableView: UITableView!
    
     //Krijo nje varg qe mban te dhena te tipit CoinCellModel
         var coincell = [CoinCellModel]()
   
     //Krijo nje variable slectedCoin te tipit CoinCellModel!
    var selectedCoin : CoinCellModel!
    //kjo perdoret per tja derguar Controllerit "DetailsController"
    //me poshte, kur ndodh kalimi nga screen ne screen (prepare for segue)
    
    
    //URL per API qe ka listen me te gjithe coins
    //per me shume detaje : https://www.cryptocompare.com/api/
    let APIURL = "https://min-api.cryptocompare.com/data/all/coinlist"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //regjistro delegate dhe datasource per tableview
        tableView.delegate = self
        tableView.dataSource = self
        
        //regjistro custom cell qe eshte krijuar me NIB name dhe
        //reuse identifier
        tableView.register(UINib.init(nibName: "CoinCell", bundle: nil),forCellReuseIdentifier: "coinCell")
        
        getDataFromAPI()
       
        //Thirr funksionin getDataFromAPI()
    }
    
    
   
    
    //Shkruaj dy funksionet e tabeles ketu
    //cellforrowat indexpath dhe numberofrowsinsection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coincell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "coinCell") as! CoinCell
        cell.lblEmri.text = coincell[indexPath.row].coinName
        cell.lblAlgoritmi.text = coincell[indexPath.row].coinAlgo
        cell.lblSymboli.text = coincell[indexPath.row].coinSymbol
        cell.lblTotali.text = coincell[indexPath.row].totalSuppy
        cell.imgFotoja.af_setImage(withURL: URL(string:coincell[indexPath.row].coinImage())!)
        return cell
    }
    
    
    
    
    

    //Funksioni getDataFromAPI()
    //Perdor alamofire per te thirre APIURL dhe ruan te dhenat
    //ne listen vargun me CoinCellModel
    //Si perfundim, thrret tableView.reloadData()
    func getDataFromAPI(){
        
        Alamofire.request(APIURL).responseData { (data) in
            
            
            if data.result.isSuccess{
                let coinJSON = try! JSON(data: data.result.value!)
                
                //print(coinJSON["Data"])
                for( key , value):(String,JSON) in coinJSON["Data"]{
                    //print(key)
                    //print(value)
                   let coin = CoinCellModel(coinName: value["CoinName"].stringValue, coinSymbol: value["Name"].stringValue, coinAlgo: value["Algorithm"].stringValue, totalSuppy: value["TotalCoinSupply"].stringValue, imagePath: value["ImageUrl"].stringValue)
                    
                    self.coincell.append(coin)
                    
                }
                
       self.tableView.reloadData()
                    
            }
        }
    }

    
    
    
    
    
    //Funksioni didSelectRowAt indexPath merr parane qe eshte klikuar
    //Ruaj Coinin e klikuar tek selectedCoin variabla e deklarurar ne fillim
    //dhe e hap screenin tjeter duke perdore funksionin
    //performSeguew(withIdentifier: "EmriILidhjes", sender, self)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedCoin = coincell[indexPath.row]
        performSegue(withIdentifier: "shfaqDetajet", sender: self)
    }
   
    
    //Beje override funksionin prepare(for segue...)
    //nese identifier eshte emri i lidhjes ne Storyboard.
    //controllerit tjeter ja vendosim si selectedCoin, coinin
    //qe e kemi ruajtur me siper
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "shfaqDetajet"{
            let zgjedhCoininController = segue.destination as! DetailsController
        
          zgjedhCoininController.selectedCoin = selectedCoin
            
        }
    }
    

   

}
