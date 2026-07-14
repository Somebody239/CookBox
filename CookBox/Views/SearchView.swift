//
//  SentView.swift
//  CookBox
//
//  Created by Kishan on 2026-07-13.
//

import SwiftUI

struct SearchView: View {
    @State private var showingSheet = false
    @State private var colorDark = Color(red: 20 / 255, green: 17 / 255, blue: 15 / 255)
    @State private var colorLight = Color(red: 237 / 255, green: 242 / 255, blue: 244 / 255)
    @Environment(\.colorScheme) var colorScheme

    let today = Date.now
        
    
    @State private var searchText = ""
    
    var body: some View {
        
        NavigationStack() {
            ZStack {
                
                if colorScheme == .dark {
                    colorDark
                        .ignoresSafeArea()

                } else {
                    colorLight
                        .ignoresSafeArea()
                }
                
                VStack() {
                    ScrollView {
                        //Recepis Here
                    }
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search recipes...", text: $searchText)
                            .textFieldStyle(.plain)
                            .autocorrectionDisabled ()
                        if !searchText.isEmpty {
                            Button (action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(12)
                    .glassEffect()
                    .padding()
                    
                }
                
                
                
            }
            
        }
    }
}

#Preview {
    SearchView()
}
