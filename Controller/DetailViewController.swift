//
//  TableViewController.swift
//  doDone
//
//  Created by Ekrem Alkan on 24.09.2022.
//

import UIKit

class  DetailViewController: UIViewController {
    var baslik = ""
    var detail = ""
    @IBOutlet weak var titleOfDetail: UILabel!
    
    @IBOutlet weak var detailData: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleOfDetail.text = baslik
        detailData.text = detail
      

   
    }


    
    
    

}
