//
//  ViewModel.swift
//  TableMultiCell
//
//  Created by Santiago Ramirez on 28/04/2020.
//  Copyright © 2020 Santiago Ramirez. All rights reserved.
//

import Foundation
import UIKit

enum ProfileViewModelItemType {
    case nameAndPicture(ProfileViewModelNameItem)
    case about(ProfileViewModelAboutItem)
    case email(ProfileViewModelEmailItem)
    case friend(ProfileViewModeFriendsItem)
    case attribute(ProfileViewModelAttributeItem)
    
    func count() -> Int {
        switch self {
        case .friend(let item):
            return item.friends.count
        case .attribute(let item):
            return item.attributes.count
        default:
            return 1
        }
    }
    
    func sctionTitle() -> String {
        switch self {
        case .nameAndPicture:
            return "Main info"
        case .about:
            return "About"
        case .email:
            return "Email"
        case .friend:
            return "Friends"
        case .attribute:
            return "Attributes"
        }
        
    }
}


class ProfileViewModelNameItem {
    
    var pictureUrl: String
    var userName: String
    init(pictureUrl: String, userName: String) {
       self.pictureUrl = pictureUrl
       self.userName = userName
    }
    
}

class ProfileViewModelAboutItem {
    
   var about: String
  
   init(about: String) {
      self.about = about
   }
}

class ProfileViewModelEmailItem {

   var email: String
   init(email: String) {
      self.email = email
   }
}
class ProfileViewModelAttributeItem {

   var attributes: [Attribute]
   init(attributes: [Attribute]) {
      self.attributes = attributes
   }
}
class ProfileViewModeFriendsItem {

   var friends: [Friend]
   init(friends: [Friend]) {
      self.friends = friends
   }
}

class ProfileViewModel: NSObject {
    var items = [ProfileViewModelItemType]()
    override init() {
        super.init()
        guard let data = dataFromFile("ServerData"), let profile = Profile(data: data) else {
            return
        }
 
        if let name = profile.fullName, let pictureUrl = profile.pictureUrl {
            let nameAndPictureItem = ProfileViewModelNameItem(pictureUrl: pictureUrl, userName: name)
            items.append(ProfileViewModelItemType.nameAndPicture(nameAndPictureItem))
        }
        if let about = profile.about {
            let aboutItem = ProfileViewModelAboutItem(about: about)
            items.append(ProfileViewModelItemType.about(aboutItem))
        }
        if let email = profile.email {
            let dobItem = ProfileViewModelEmailItem(email: email)
            items.append(ProfileViewModelItemType.email(dobItem))
        }
        let attributes = profile.profileAttributes
        if !attributes.isEmpty {
            let attributesItem = ProfileViewModelAttributeItem(attributes: attributes)
            items.append(ProfileViewModelItemType.attribute(attributesItem))
        }
        let friends = profile.friends
        if !profile.friends.isEmpty {
            let friendsItem = ProfileViewModeFriendsItem(friends: friends)
            items.append(ProfileViewModelItemType.friend(friendsItem))
        }
   }
}

extension ProfileViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
      return items.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       return items[section].sctionTitle()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch items[indexPath.section] {
        case .nameAndPicture(let item):
            if let cell = tableView.dequeueReusableCell(withIdentifier: TestViewCell.identifier, for: indexPath) as? TestViewCell {
                cell.setData(item)
                return cell
            }
                    
        case .about(let item):
            if let cell = tableView.dequeueReusableCell(withIdentifier: SimpleViewCell.identifier, for: indexPath) as? SimpleViewCell {
                cell.setData(item)
                return cell
            }
        case .email(let item):
            if let cell = tableView.dequeueReusableCell(withIdentifier: SimpleViewCell.identifier, for: indexPath) as? SimpleViewCell {
                cell.setData(item)
                return cell
            }
        case .friend(let item):
            if let cell = tableView.dequeueReusableCell(withIdentifier: TestViewCell.identifier, for: indexPath) as? TestViewCell {
                cell.setData(item.friends[indexPath.row])
                return cell
            }
        case .attribute(let item):
            if let cell = tableView.dequeueReusableCell(withIdentifier: DoubleViewCell.identifier, for: indexPath) as? DoubleViewCell {
                cell.setData(item.attributes[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    
    }
    
}
