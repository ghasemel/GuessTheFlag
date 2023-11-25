//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Raouf on 25/11/2023.
//

import SwiftUI

struct ContentView: View {
    public static let COUNTRIES = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"]
    
    @State private var countries = COUNTRIES
    
    @State private var correctAnswer = Int.random(in: 0...COUNTRIES.count - 1)
    @State private var numberOfCorrectAnswer = 0
    @State private var numberOfWrongAnswer = 0
    @State private var finished = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                VStack(spacing: 10) {
                    
                    if finished {
                        let finalMessage = getResultMessage()
                        Text("You \(finalMessage)!")
                            .fontWeight(.heavy)
                            .font(.largeTitle)
                            .foregroundStyle(finalMessage == "Won" ? .green : .red)
                    } else {
                        Text("Tap the flag of")
                        Text(countries[correctAnswer])
                            .font(.title)
                    }
                        
                }
                Spacer()
                
                VStack (spacing: 30) {
                    createFlagButtons()
                }
                .frame(width: 300, height: 400)
                .background(.gray.opacity(0.2))
                .border(.black)
                .disabled(finished)
                
                Spacer()
                
                HStack {
                    
                    VStack {
                        Image(systemName: "x.circle.fill")
                        Text("\(numberOfWrongAnswer)")
                    }
                    .foregroundStyle(.red)

                    Spacer()
                    
                    VStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("\(numberOfCorrectAnswer)")
                    }
                    .foregroundStyle(.green)
                    
                }
                .frame(width: 200, height: 100)
                .font(.largeTitle)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)

                
            }
            .navigationTitle("Guess The Flag!")
            .toolbar {
                if finished {
                    Button("rest", systemImage: "arrow.clockwise.circle.fill") {
                        resetGame()
                    }
                }
            }
            
            //.ignoresSafeArea()
            
        }
    }
    
    func getResultMessage() -> String {
        numberOfCorrectAnswer > numberOfWrongAnswer ? "Won" : "Lost"
    }
    
    func resetGame() {
        countries = ContentView.COUNTRIES
        correctAnswer = Int.random(in: 0..<getCountriesCount())
        finished = false
        numberOfCorrectAnswer = 0
        numberOfWrongAnswer = 0
    }
    
    @ViewBuilder func createFlagButtons() -> some View {
        let selectedCountries = chooseTwoRandomCountriesPlusAnswer()
        
        ForEach(selectedCountries, id: \.self) { countryIndex in
            Button {
                if countryIndex == correctAnswer {
                    numberOfCorrectAnswer += 1
                } else {
                    numberOfWrongAnswer += 1
                }
                countries.remove(at: correctAnswer)
                
                if getCountriesCount() == 3 {
                    finished = true
                    correctAnswer = 0
                    return
                }
                
                correctAnswer = Int.random(in: 0..<getCountriesCount())
            } label: {
                Image(countries[countryIndex])
                    .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
        }
    }
    
    func getCountriesCount() -> Int {
        return countries.count
    }
    
    func chooseTwoRandomCountriesPlusAnswer() -> [Int] {
        var selectedList: [Int] = [correctAnswer]
        
        var i = 0
        repeat {
            let randomIndex = Int.random(in: 0..<getCountriesCount())
            if selectedList.contains(randomIndex)  {
                continue
            }
            
            selectedList.append(randomIndex)
            i += 1
        } while (i < 2)
        
        return selectedList.shuffled()
    }
}

#Preview {
    ContentView()
}
