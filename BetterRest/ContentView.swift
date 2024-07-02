//
//  ContentView.swift
//  BetterRest
//
//  Created by Milena Beicker on 01/07/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var sleepAmount = 8.0
    @State private var wakeUp = Date.now
    @State private var coffeAmount = 1
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Quando você quer acordar")
                    .font(.headline)
                
                DatePicker("Please enter a date", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()
               
                Text("Quantidade desejada de sono")
                    .font(.headline)
                
                Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                
                Text("Ingestão diária de café")
                    .font(.headline)
                Stepper("\(coffeAmount) xícaras", value: $coffeAmount, in: 1...20)
            }
            .padding()
            .navigationTitle("Better Rest")
            .toolbar {
                Button("Calcular", action: calculateBedTime)
            }
        }
    }
    
    func calculateBedTime() {
        
    }
    
}

#Preview {
    ContentView()
}
