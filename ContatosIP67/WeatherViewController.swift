//
//  WeatherViewController.swift
//  ContatosIP67
//
//  Created by ios6584 on 13/01/17.
//  Copyright © 2017 ios6584. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=-23.588453&lon=-46.632103&appid=f0c49d55ff8843dc732dc8d4811d25e3&units=metrics")
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url!) { (data, response, error) in
            print("Data: \(data)")
            print("Response: \(response)")
            
            if (error == nil) {
                let httpResponse = response as! HTTPURLResponse
                if (httpResponse.statusCode == 200) {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as! Dictionary<String, AnyObject>
                        print("Json: \(json)")
                        
                        let weather = json["weather"]![0]! as! Dictionary<String, AnyObject>
                        let icon = weather["icon"] as! String
                        self.setImageView(icon: icon)
                        
                        let temp_min = json["main"]?["temp_min"] as! Double
                        let temp_max = json["main"]?["temp_max"] as! Double
                        let main = weather["main"] as! String
                        
                        DispatchQueue.main.async {
                            self.minLabel.text = temp_min.description
                            self.maxLabel.text = temp_max.description
                            self.conditionLabel.text = main.description
                        }
                        
                    } catch let serializationError {
                        print(serializationError.localizedDescription)
                    }
                }
            }
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setImageView(icon: String) {
        let url = URL(string: "http://api.openweathermap.org/img/w/\(icon).png")
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url!) { (data, response, error) in
            print("Data: \(data)")
            print("Response: \(response)")
            
            if (error == nil) {
                let httpResponse = response as! HTTPURLResponse
                if (httpResponse.statusCode == 200) {
                    let image = UIImage(data: data!)
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }
        }
        task.resume()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
