//
//  GenderPicker.swift
//  DiplomskiTest
//
//  Created by Matej Kuprešak on 18.03.2025..
//

import SwiftUI

struct MultichoicePicker: View {
    @State var selectedValue: String
    let values: [String]
    let title: String
    
    var body: some View {
        Section {
            HStack {
                Text("\(title):")
                
                Spacer()
                
                Picker("", selection: $selectedValue) {
                    ForEach(values, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
            }
        }
    }
}

#Preview {
    MultichoicePicker(selectedValue: "Male", values: ["Male", "Female", "Other"], title: "Gender")
}
