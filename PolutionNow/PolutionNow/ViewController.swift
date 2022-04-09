//
//  ViewController.swift
//  PolutionNow
//
//  Created by Dominick Rangel on 3/23/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var pollutionImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pollutionImage.image = UIImage(named: "neutral")!
        // Do any additional setup after loading the view.

        //create our views
        
        //populate views based on response
        }
    
    @IBAction func getPollutionIndex(_ sender: Any) {
        makeRequest { response in
            let aqiusValue = response.data.current.pollution.aqius
            let image:UIImage!
            
            if aqiusValue <= 50{
                image = UIImage(named:"positive")!
            } else if aqiusValue > 50 && aqiusValue <= 100 {
                image = UIImage(named:"neutral")!
            } else {
                image = UIImage(named:"negative")!
            }
            
            DispatchQueue.main.async{
                self.pollutionImage.image = image
            }
        }
    }
    
    func makeRequest(completeion: @escaping(Response)-> Void){
        //add our url
        let urlString = "http://api.airvisual.com/v2/city?city=Stockton&state=California&country=USA&key=536bdfea-f5a7-4ea8-803f-f1727decce74"
        let url = URL(string:urlString)!
        
        //make a simple api call
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let actualData = data else {
                print("No data for this request")
                return
            }
            // check that we have a response
            print(String(data:actualData, encoding: .utf8)!)
            
            //Save the data in an object
            var result: Response?

            do {
                result = try JSONDecoder().decode(Response.self, from: data!)
            } catch{
                print("Error converting data \(error.localizedDescription)")
            }
            if let finalResult = result{
            completeion(result!)

//            print("Success is \(result?.status)")
//            print("Success is \(result?.data.current.pollution.aqius)")
            }
        }
        task.resume()
        
    }
    
}



struct Response: Codable {
    let status: String
    let data: MyData
}

struct MyData: Codable {
    let current: CurrentPollution
}

struct CurrentPollution: Codable {
    let pollution: Pollution
}
struct Pollution: Codable{
    let aqius: Int
}

