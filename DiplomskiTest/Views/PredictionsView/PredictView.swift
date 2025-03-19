import SwiftUI

struct PredictView: View {
    @ObservedObject var viewModel: PredictViewModel
    
    var body: some View {
        NavigationStack {
            List {
                CustomInputField(
                    inputValue: viewModel.age,
                    label: "Age",
                    placeholderValue: "Age"
                )
                
                MultichoicePicker(selectedValue: viewModel.hypertension, values: viewModel.hypertensionOptions, title: "Hypertension")
                
                MultichoicePicker(selectedValue: viewModel.heartDisease, values: viewModel.heartDiseaseOptions, title: "Heart disease")
                
                TextField("BMI", text: $viewModel.bmi)
                    .padding()
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("HbA1c Level", text: $viewModel.hba1cLevel)
                    .padding()
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Blood Glucose Level", text: $viewModel.bloodGlucoseLevel)
                    .padding()
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                MultichoicePicker(selectedValue: viewModel.smokingHistory, values: viewModel.smokingHistoryOptions, title: "Smoking history")
                
                MultichoicePicker(selectedValue: viewModel.gender, values: viewModel.genderOptions, title: "Gender")
                
                Button("Make Prediction") {
                    let input = viewModel.prepareInput()
                    viewModel.makePrediction(input: input)
                }
                .padding()
                
                Text("Prediction Result: \(viewModel.predictionResult)")
                    .padding()
            }
            .navigationTitle("Make a prediction")
        }
    }
}

#Preview {
    PredictView(viewModel: PredictViewModel())
}
