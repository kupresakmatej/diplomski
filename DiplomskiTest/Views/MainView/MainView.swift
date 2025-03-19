//
//  MainView.swift
//  DiplomskiTest
//
//  Created by Matej Kuprešak on 14.03.2025..
//

import SwiftUI

struct MainView: View {
    @ObservedObject var landingViewModel = LandingViewModel()
    @ObservedObject var predictionsViewModel = PredictionsViewModel()
    
    var body: some View {
        TabView {
            LandingView(viewModel: landingViewModel)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            PredictionsView(viewModel: predictionsViewModel)
                .tabItem {
                    Label("Predictions", systemImage: "pencil.and.list.clipboard")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.text.rectangle")
                }
        }
    }
}

#Preview {
    MainView()
}
