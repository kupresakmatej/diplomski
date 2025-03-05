import SwiftUI
import CoreML
import Foundation

struct ContentView: View {
    @State private var age = ""
    @State private var hypertension = ""
    @State private var heartDisease = ""
    @State private var bmi = ""
    @State private var hba1cLevel = ""
    @State private var bloodGlucoseLevel = ""
    @State private var smokingHistory = ""
    @State private var gender = ""
    @State private var predictionResult = ""
    
    var body: some View {
        ScrollView {
            VStack {
                TextField("Age", text: $age)
                    .padding()
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Hypertension (0 or 1)", text: $hypertension)
                    .padding()
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Heart Disease (0 or 1)", text: $heartDisease)
                    .padding()
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("BMI", text: $bmi)
                    .padding()
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("HbA1c Level", text: $hba1cLevel)
                    .padding()
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Blood Glucose Level", text: $bloodGlucoseLevel)
                    .padding()
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Smoking History (0-5)", text: $smokingHistory)
                    .padding()
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Gender (0=Female, 1=Male, 2=Other)", text: $gender)
                    .padding()
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button("Make Prediction") {
                    let input = prepareInput()
                    makePrediction(input: input)
                }
                .padding()

                Text("Prediction Result: \(predictionResult)")
                    .padding()
            }
            .padding()
            .onTapGesture {
                hideKeyboard()
            }
        }
    }

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    func prepareInput() -> diabetes_modelInput? {
        guard let ageValue = Double(age),
              let hypertensionValue = Double(hypertension),
              let heartDiseaseValue = Double(heartDisease),
              let bmiValue = Double(bmi),
              let hba1cLevelValue = Double(hba1cLevel),
              let bloodGlucoseValue = Double(bloodGlucoseLevel),
              let smokingHistoryValue = Double(smokingHistory),
              let genderValue = Double(gender) else {
            return nil
        }

        let means = [
            41.885856,
            0.074850,
            0.039420,
            27.320767,
            5.527507,
            138.058060,
            1.306950,
            0.414660
        ]
        let stdDevs = [
            22.516840,
            0.263150,
            0.194593,
            6.636783,
            1.070672,
            40.708136,
            1.454501,
            0.493031
        ]
        
        let scaledInputs: [Double] = [
            (ageValue - means[0]) / stdDevs[0],
            (hypertensionValue - means[1]) / stdDevs[1],
            (heartDiseaseValue - means[2]) / stdDevs[2],
            (bmiValue - means[3]) / stdDevs[3],
            (hba1cLevelValue - means[4]) / stdDevs[4],
            (bloodGlucoseValue - means[5]) / stdDevs[5],
            (smokingHistoryValue - means[6]) / stdDevs[6],
            (genderValue - means[7]) / stdDevs[7]
        ]
        
        do {
            let multiArray = try MLMultiArray(shape: [1, NSNumber(value: scaledInputs.count)], dataType: .double)
            for (index, value) in scaledInputs.enumerated() {
                multiArray[index] = NSNumber(value: value)
            }
            return diabetes_modelInput(dense_input: multiArray)
        } catch {
            print("Error creating MLMultiArray: \(error)")
            return nil
        }
    }

    func convertToDouble(_ string: String) -> Double? {
        let formattedString = string.replacingOccurrences(of: ",", with: ".")
        return Double(formattedString)
    }

    func makePrediction(input: diabetes_modelInput?) {
        guard let input = input else {
            print("Invalid input data")
            return
        }

        let configuration = MLModelConfiguration()
        configuration.computeUnits = .cpuOnly

        guard let model = try? diabetes_model(configuration: configuration) else {
            print("Failed to load model")
            return
        }

        do {
            let prediction = try model.prediction(input: input)
            
            print("Prediction successful. Available features in the output:")
            for feature in prediction.featureNames {
                print("Feature: \(feature), Value: \(String(describing: prediction.featureValue(for: feature)))")
            }

            if let resultArray = prediction.featureValue(for: "Identity")?.multiArrayValue {
                let result = resultArray
                print("Prediction result array: \(result)")

                let probabilityForNegative = result[0].doubleValue
                let probabilityForPositive = result[1].doubleValue

                if probabilityForNegative > probabilityForPositive {
                    self.predictionResult = "Predicted: Diabetes Negative (Probability: \(probabilityForNegative))"
                } else {
                    self.predictionResult = "Predicted: Diabetes Positive (Probability: \(probabilityForPositive))"
                }
            } else {
                self.predictionResult = "No diabetes prediction result found"
            }
        } catch {
            print("Error during prediction: \(error.localizedDescription)")
            self.predictionResult = "Error during prediction: \(error.localizedDescription)"
        }
    }
}

#Preview {
    ContentView()
}
