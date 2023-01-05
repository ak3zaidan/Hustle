import Foundation

class BubbleViewModel: ObservableObject{
    
    let message: Message
    
    init(message: Message){
        self.message = message
        
    }
}
