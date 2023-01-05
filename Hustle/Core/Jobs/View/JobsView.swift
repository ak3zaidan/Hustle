import SwiftUI
import HalfASheet
import SPAlert
import Foundation

struct JobsView: View {
    @State private var distance: DropdownMenuOption? = nil
    @State var isShowing: Bool = false
    @State private var showNewJobView = false
    @StateObject var viewModel = JobViewModel()
    @State var placeHolder: String = "zipCode"
    @State var zipCodeIsValid: Bool = true
    @State var showFixZip: Bool = false
    @State var zipCodeBarPlaceHolder: String = "zipCode"
    static let myColor = Color("lightgray")
    
    var body: some View {
        mainInterFaceView
        
    }
}

struct JobsView_Previews: PreviewProvider {
    static var previews: some View {
        JobsView()
    }
}


extension JobsView{
    var mainInterFaceView: some View{
        ZStack {
            VStack{
                HStack{
                    Button {
                        withAnimation(.easeInOut){
                            zipCodeBarPlaceHolder = viewModel.zip
                            isShowing.toggle()
                        }
                    } label: {
                        HStack{
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundColor(.gray)
                            Text(placeHolder)
                                .onChange(of: viewModel.zip, perform: { _ in
                                    placeHolder = viewModel.zip
                                })
                                .foregroundColor(.gray)
                        }
                    }
                    .offset(x:-80)
                    .sheet(isPresented: $isShowing) {
                        VStack{
                            HStack{
                                Text("Where are you searcing")
                                    .foregroundColor(.black)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                            .padding(.top, 8)
                            
                            Button {
                                if viewModel.menuGetLocationButton == "Current Location"{
                                    viewModel.getZipCode { _ in }
                                    zipCodeBarPlaceHolder = viewModel.zip
                                } else {
                                    if let url = URL(string: UIApplication.openSettingsURLString) {
                                        UIApplication.shared.open(url)
                                    }
                                }
                            } label: {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.primary, lineWidth: 2)
                                    .background(Color.gray)
                                    .frame(width: 200, height: 30, alignment: .top)
                                    .overlay(Text(viewModel.menuGetLocationButton)
                                        .foregroundColor(.white).bold()
                                        .font(.subheadline))
                            }
                            zipCodeBar(text: $zipCodeBarPlaceHolder)
                                .frame(width: 200, height: 50)
                                .padding(.bottom, showFixZip ? 0 : 100)
                                .onDisappear {
                                    self.showFixZip = false
                                }
                            if showFixZip{
                                Text("Please enter a valid US zipCode")
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .padding(.bottom, 100)
                            }
                            Button {
                                let isValid = viewModel.isValidZipCode(zipCodeBarPlaceHolder)
                                if isValid{
                                    showFixZip = false
                                    viewModel.zip = zipCodeBarPlaceHolder
                                    viewModel.uploadZipToDatabase(withZip: viewModel.zip)
                                    viewModel.getJobs(withOption: "25 mile")
                                    distance = DropdownMenuOption(option: "25 mile")
                                    isShowing.toggle()
                                } else {
                                    showFixZip = true
                                }
                            } label: {
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.white, lineWidth: 2)
                                    .background(Color.white)
                                    .frame(width: 300, height: 30)
                                    .padding(.bottom, 5)
                                    .overlay(Text("Apply")
                                        .foregroundColor(.black).bold()
                                        .font(.subheadline))
                                        .padding(.bottom, 5)
                            }
                        }
                        .presentationDetents([.fraction(0.4)])
                        .presentationDragIndicator(.hidden)
                        .background(JobsView.myColor)
                    }

                    Text("Jobs")
                        .font(.title2).bold()
                        .foregroundColor(.orange)
                        .offset(x: -48)
                }
                //job list scroll view
                ZStack(alignment: .bottomTrailing){
                    ScrollView{
                        LazyVStack{
                            ForEach(viewModel.jobs){ job in
                                JobsRowView(job: job)
                                    .padding()
                            }
                        }
                    }
                    Button {
                        showNewJobView.toggle()
                    } label: {
                        Image(systemName: "j.circle")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 28, height: 28)
                            .padding()
                    }
                    .background(Color(.systemOrange))
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .padding()
                    .fullScreenCover(isPresented: $showNewJobView){
                        UploadJobView()
                    }
                }
            }
            DropdownMenu(selectedOption: self.$distance, placeholder: "Distance", options: DropdownMenuOption.testAllMonths)
                .frame(width: 130, height: 40)
                .offset(x: 130, y: -375)
                .scaleEffect(CGSize(width: 0.9, height: 0.9))
                .onChange(of: viewModel.zip, perform: { _ in
                    if (distance?.option != "25 mile" && distance?.option != "100 mile" && distance?.option != "Remote"){
                        if !viewModel.zip.isEmpty{
                            self.distance = DropdownMenuOption(option: "25 mile")
                        } else {
                            self.distance = DropdownMenuOption(option: "Remote")
                        }
                    }
                })
                .onChange(of: distance) { _ in
                    if distance?.option == "25 mile" {
                        viewModel.getJobs(withOption: "25 mile")
                    } else if distance?.option == "100 mile" {
                        viewModel.getJobs(withOption: "100 mile")
                    } else if distance?.option == "Remote" {
                        viewModel.getRemoteJobs()
                    }
                }
                .onAppear(){
                    if (viewModel.zip == "" && distance?.option != "Remote"){
                        viewModel.getZipCode { zip in
                            if viewModel.isValidZipCode(zip){ // access to location
                                self.distance = DropdownMenuOption(option: "25 mile")
                                viewModel.menuGetLocationButton = "Current Location"
                            } else{
                                viewModel.checkIfZipInDatabase()
                                if viewModel.inDataBase{
                                    //zip found in database for user
                                    viewModel.getZipFromDataBase()
                                    self.distance = DropdownMenuOption(option: "25 mile")
                                } else {
                                    //no zip in database for user
                                    self.distance = DropdownMenuOption(option: "Remote")
                                    viewModel.showAlertAddZip = true
                                }
                                viewModel.menuGetLocationButton = "Update in Settings"
                            }
                        }
                    }
                }
            
            //adding alert
            if viewModel.showAlertAddZip{
                Text("")
                    .SPAlert(isPresent: $viewModel.showAlertAddZip,
                             title: "ZipCode",
                             message: "To browse local jobs add in a zipCode",
                             duration: 3,
                             dismissOnTap: true,
                             preset: .custom(UIImage(systemName: "mappin.and.ellipse")!),
                             haptic: .success,
                             layout: .init()) {
                        
                        viewModel.showAlertAddZip = false
                        isShowing = true
                    }
                
            }
        }
    }
}
