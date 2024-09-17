//
//  ContentView.swift
//  ConvertUnit
//
//  Created by Stefan Olarescu on 17.09.2024.
//

import SwiftUI

enum TemperatureUnit: CaseIterable {
    case celsius, fahrenheit, kelvin
    
    private var letter: String {
        switch self {
        case .celsius: return "C"
        case .fahrenheit: return "F"
        case .kelvin: return "K"
        }
    }
    
    var text: String {
        return "°\(letter)"
    }
}

struct ContentView: View {
    
    // MARK: - PROPERTIES
    @State private var temperatureInputUnit = TemperatureUnit.celsius
    @State private var temperatureOutputUnit = TemperatureUnit.fahrenheit
    @State private var temperatureValue = Double.zero
    
    @FocusState private var temperatureValueTextFieldIsFocused: Bool
    
    private let temperatureUnits = TemperatureUnit.allCases
    
    // MARK: - COMPUTED PROPERTIES
    private var convertedTemperature: Double {
        // Convert the input unit to celsius
        var celsius: Double
        switch temperatureInputUnit {
        case .celsius: celsius = temperatureValue
        case .fahrenheit: celsius = (temperatureValue - 32) / 1.8
        case .kelvin: celsius = temperatureValue - 273.15
        }
        
        // Convert celsius to output unit
        switch temperatureOutputUnit {
        case .celsius: return celsius
        case .fahrenheit: return celsius * 1.8 + 32
        case .kelvin: return celsius + 273.15
        }
    }
    
    // MARK: - UI
    var body: some View {
        NavigationStack {
            Form {
                Section("Temperature unit") {
                    Picker(
                        "Input",
                        selection: $temperatureInputUnit,
                        content: {
                            ForEach(
                                temperatureUnits,
                                id: \.self
                            ) {
                                Text($0.text)
                            }
                        }
                    )
                    
                    Picker(
                        "Output",
                        selection: $temperatureOutputUnit,
                        content: {
                            ForEach(
                                temperatureUnits,
                                id: \.self
                            ) {
                                Text($0.text)
                            }
                        }
                    )
                }
                
                Section("Temperature value") {
                    TextField(
                        "Input",
                        value: $temperatureValue,
                        format: .number
                    )
                    .keyboardType(.decimalPad)
                    .focused($temperatureValueTextFieldIsFocused)
                }
                
                Text("\(convertedTemperature.formatted())")
            }
            .navigationTitle("ConvertUnit")
            .toolbar {
                if temperatureValueTextFieldIsFocused {
                    Button("Done") {
                        temperatureValueTextFieldIsFocused = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
