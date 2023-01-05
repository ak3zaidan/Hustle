import SwiftUI

struct DropdownMenuListRow: View {
    //@StateObject var viewModel = JobViewModel()
    let option: DropdownMenuOption
    let onSelectedAction: (_ option: DropdownMenuOption) -> Void
    
    var body: some View {
        Button {
            self.onSelectedAction(option)
        } label: {
            Text(option.option)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .foregroundColor(.black)
        .padding(.vertical, 5)
        .padding(.horizontal)
    }
}
