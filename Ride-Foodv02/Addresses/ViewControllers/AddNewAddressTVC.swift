//
//  AddNewAddressTVC.swift
//  Ride-Foodv02
//
//  Created by Владислав Белов on 26.07.2021.
//

import UIKit

class AddNewAddressTVC: UITableViewController {
    
    @IBOutlet weak var VerticalSeparatorView: UIView! {didSet{
        VerticalSeparatorView.backgroundColor = UIColor.ProfileButtonBorderColor
    }}
    
    @IBOutlet weak var MapButton: UIButton! { didSet {
        let fullString = NSMutableAttributedString(string: "Карта ")
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: "MapArrow")
        let imageString = NSAttributedString(attachment: imageAttachment)
        fullString.append(imageString)
        MapButton.setAttributedTitle(fullString, for: .normal)
        
        
    }}
    
    
    @IBOutlet weak var NewAddressTitleTextView: UITextView! { didSet {
        NewAddressTitleTextView.textColor = UIColor.ProfileButtonBorderColor
        NewAddressTitleTextView.font = UIFont.SFUIDisplayRegular(size: 17)
        NewAddressTitleTextView.text = "Название адреса"
        NewAddressTitleTextView.textAlignment = .left
    }
    }
    
    @IBOutlet weak var NewAddressTextView: UITextView! { didSet {
        NewAddressTextView.textColor = UIColor.ProfileButtonBorderColor
        NewAddressTextView.font = UIFont.SFUIDisplayRegular(size: 17)
        NewAddressTextView.text = "Адрес"
        NewAddressTextView.textAlignment = .left
    }}
    
    @IBOutlet weak var CommentaryForDriverTextView: UITextView! { didSet{
        CommentaryForDriverTextView.textColor = UIColor.ProfileButtonBorderColor
        CommentaryForDriverTextView.font = UIFont.SFUIDisplayRegular(size: 17)
        CommentaryForDriverTextView.text = "Комментарий для водителя"
        CommentaryForDriverTextView.textAlignment = .left
    }}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        tableView.separatorColor = UIColor.ProfileButtonBorderColor
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func configureNavigationItem(){
        let doneButton = UIBarButtonItem(image: UIImage(named: "BackButton"), style: .done, target: self, action: #selector(dismissVC))
        doneButton.tintColor = .black
        navigationItem.leftBarButtonItem = doneButton
        
    }
    
    @objc func dismissVC(){
        navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 50
    }

    // MARK: - Table view data source

 

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
