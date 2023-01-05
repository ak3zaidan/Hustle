import SwiftUI

struct DropdownMenuList: View {

    let options: [DropdownMenuOption]
    
    let onSelectedAction: (_ option: DropdownMenuOption) -> Void
    
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 2) {
            ForEach(options) { option in
                DropdownMenuListRow(option: option, onSelectedAction: self.onSelectedAction)
            
            }
        }
        .background(Color.white)
        .frame(width: 100,height: CGFloat(self.options.count * 32) > 300
               ? 300 : CGFloat(self.options.count * 32)
        )
        .padding(.vertical, 5)
        .overlay {
            RoundedRectangle(cornerRadius: 5)
                .stroke(.gray, lineWidth: 2)
        }
    }
}

struct DropdownMenuList_Previews: PreviewProvider {
    static var previews: some View {
        DropdownMenuList(options: DropdownMenuOption.testAllMonths, onSelectedAction: { _ in })
    }
}
