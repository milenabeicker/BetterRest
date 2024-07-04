//
//  ContentView.swift
//  BetterRest
//
//  Created by Milena Beicker on 01/07/24.
//

import CoreML
import SwiftUI

struct ContentView: View {
    
    @State private var sleepAmount = 8.0
    @State private var wakeUp = defaultWakeTime
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    var body: some View {
        NavigationStack {
            Form {
                VStack(alignment: .leading, spacing: 0){
                    Text("Quando você quer acordar")
                        .font(.headline)
                    
                    DatePicker("Please enter a date", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                VStack(alignment: .leading, spacing: 0) {
                    Text("Quantidade desejada de sono")
                        .font(.headline)
                    
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                VStack(alignment: .leading, spacing: 0){
                    Text("Ingestão diária de café")
                        .font(.headline)
                    Stepper("^[\(coffeeAmount) cup](inflect: true)", value: $coffeeAmount, in: 1...20)
                }
            }
            .navigationTitle("Better Rest")
            .toolbar {
                Button("Calcular", action: calculateBedTime)
            }
            .alert(alertTitle, isPresented: $showingAlert ) {
                Button("Ok"){}
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    func calculateBedTime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Int64(Double(hour + minute)), estimatedSleep: sleepAmount, coffee: Int64(Double(coffeeAmount)))
            
            let sleepTime = wakeUp - prediction.actualSleep //let sleepTime
            alertTitle = "Your ideal bedtime is…"
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
            
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, houve um problema ao calcular sua hora de dormir"
        }
        showingAlert = true
    }
    
}

#Preview {
    ContentView()
}
