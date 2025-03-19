import SwiftUI

struct LandingView: View {
    @ObservedObject var viewModel: LandingViewModel
    
    var body: some View {
        Text("Home")
    }
}

#Preview {
    LandingView(viewModel: LandingViewModel())
}
