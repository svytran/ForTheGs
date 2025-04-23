//import SwiftUI
//
//struct ContentView: View {
//    var body: some View {
//        MainTabView()
//    }
//}
//
//#Preview {
//    ContentView()
//} 

import SwiftUI

struct ContentView: View {
    let repository: SelfCareActivityRepositoryProtocol

    var body: some View {
        let viewModel = SelfCareViewModel(repository: repository)
        MainTabView(viewModel: viewModel)
    }
}
