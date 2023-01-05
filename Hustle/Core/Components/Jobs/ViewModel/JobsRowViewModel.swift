import Foundation

class JobsRowViewModel: ObservableObject {
    @Published var job: Job
    private let service = JobService()
    
    init(job: Job){
        self.job = job
    }
}
