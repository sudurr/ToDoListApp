//
//  TableViewDelegate.swift
//  ToDoListApp
//
//  Created by Судур Сугунушев on 30.06.2023.
//

import UIKit

extension DetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
