//
//  ListTableViewCell.swift
//  ApiManger
//
//  Created by Prashant Gajjar on 18/11/22.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    //MARK: - Properties
    @IBOutlet private weak var lblTitle: UILabel!
    
    public var hit: Hit? {
        didSet {
            lblTitle.text = hit?.user ?? "NA"
        }
    }
    
    //MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print(#function, " called")
        #warning("prepareForReuse is not calling, why?")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
