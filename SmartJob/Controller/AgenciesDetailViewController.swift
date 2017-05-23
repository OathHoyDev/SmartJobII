//
//  AgenciesListViewController.swift
//  SmartJob
//
//  Created by SilVeriSm on 14/1/2560 .
//  Copyright © 2560 th.go.doe.smartjob. All rights reserved.
//

import UIKit

class AgenciesDetailViewController: UIViewController {
    @IBOutlet weak var agenciesDetailButton: UIButton!
    @IBOutlet weak var employeeDetailButton: UIButton!
    @IBOutlet weak var agenciesDetailView: UIView!
    
    @IBOutlet weak var agenciesView: UIView!
    
    @IBOutlet weak var employeeView: UIView!
    
    
    var buttonFrameSize = CGSize()
    var agenciesFrameSize = CGSize()
    var tableRowViewFrameSize = CGSize()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //viewDidLayoutSubviews()
        
        agenciesDetailButton.addDashedBorder(size: buttonFrameSize , color : ServiceConstant.DASH_BORDER_COLOR)
        employeeDetailButton.addDashedBorder(size: buttonFrameSize , color : ServiceConstant.DASH_BORDER_COLOR)
        
        agenciesDetailView.addDashedBorder(size: agenciesFrameSize , color : ServiceConstant.ENABLE_LABEL_COLOR)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        agenciesDetailButton.backgroundColor = ServiceConstant.ENABLE_LABEL_COLOR
        employeeDetailButton.backgroundColor = ServiceConstant.DISABLE_LABEL_COLOR
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backPageAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewDidLayoutSubviews() {
        //super.viewDidLayoutSubviews()
        
        buttonFrameSize = agenciesDetailButton.frame.size
        agenciesFrameSize = agenciesDetailView.frame.size
        
    }
    @IBAction func agenciesViewAction(_ sender: Any) {
        agenciesView.isHidden = false
        employeeView.isHidden = true
        
        agenciesDetailButton.backgroundColor = ServiceConstant.ENABLE_LABEL_COLOR
        employeeDetailButton.backgroundColor = ServiceConstant.DISABLE_LABEL_COLOR
        
    }
    @IBAction func employeeViewAction(_ sender: Any) {
        agenciesView.isHidden = true
        employeeView.isHidden = false
        
        agenciesDetailButton.backgroundColor = ServiceConstant.DISABLE_LABEL_COLOR
        employeeDetailButton.backgroundColor = ServiceConstant.ENABLE_LABEL_COLOR
    }
}


