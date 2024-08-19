//
//  DeviceTableViewCell.swift
//  AirPlay
//
//  Created by Aj on 18/08/24.
//

import UIKit

class DeviceTableViewCell: UITableViewCell {
    // MARK: - Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ipLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    static let identifier = "DeviceTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "DeviceTableViewCell", bundle: nil)
    }
    
    // MARK: - Life cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(data:AirPlayDevice) {
        nameLabel.text = data.name
        ipLabel.text = data.ipAddress
        statusLabel.text = data.status
    }
    
}
