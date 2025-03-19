import SwiftUI

struct PredictionsView: View {
    @ObservedObject var viewModel: PredictionsViewModel
    @ObservedObject var predictViewModel = PredictViewModel()
    
    var body: some View {
        NavigationStack {
            Text("Your predictions")
                .navigationTitle("Predictions")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            PredictView(viewModel: predictViewModel)
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundStyle(.blue)
                        }
                    }
                }
        }
    }
}

#Preview {
    PredictionsView(viewModel: PredictionsViewModel())
}
