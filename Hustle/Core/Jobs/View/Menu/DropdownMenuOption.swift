import Foundation

struct DropdownMenuOption: Identifiable, Hashable {
    let id = UUID().uuidString
    let option: String
}

extension DropdownMenuOption {
    static let testSingleMonth: DropdownMenuOption = DropdownMenuOption(option: "March")
    static let testAllMonths: [DropdownMenuOption] = [
        DropdownMenuOption(option: "25 mile"),
        DropdownMenuOption(option: "100 mile"),
        DropdownMenuOption(option: "Remote"),
    ]
}

