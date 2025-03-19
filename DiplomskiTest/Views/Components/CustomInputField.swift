//
//  CustomInputField.swift
//  DiplomskiTest
//
//  Created by Matej Kuprešak on 18.03.2025..
//

import SwiftUI

struct CustomInputField: View {
    @State var inputValue: String
    let label: String
    let placeholderValue: String
    
    var body: some View {
        VStack {
            Text("\(label)")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading, .top], 10)
                .font(.caption)
            
            TextField("\(placeholderValue)", text: $inputValue)
                .keyboardType(.numberPad)
                .textFieldStyle(.plain)
                .padding([.leading, .bottom], 10)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.gray, lineWidth: 0.5)
        )
        .padding()
    }
}

#Preview {
    CustomInputField(
        inputValue: "",
        label: "BMI",
        placeholderValue: "BMI"
    )
}
