import Foundation

enum SideMenuViewModel: Int, CaseIterable{
    case Account
    case help
    case logout
    
    var description: String{
        switch self{
        case .Account: return "Account Information"
        case .help: return "Help"
        case .logout: return "Logout"
        }
    }
    
    var imageName: String{
        switch self{
        case .Account: return "person.crop.circle"
        case .help: return "questionmark.circle"
        case .logout: return "arrow.left.square"
        }
    }
}
