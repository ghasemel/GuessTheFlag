//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by TAAELGH1 on 24/01/2024.
//

import SwiftUI

struct FlagImage: View {
    var flagName: String
    
    var body: some View {
        Image(flagName)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/.bold())
            .foregroundColor(.white)
    }
}

extension View {
    func titleStyle() -> some   View {
        modifier(Title())
    }
}

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var scoreTitle = ""
    @State private var showingTitle = false
    @State private var score = 0
    
    @State private var questionCounter = 1
    @State private var finished = false
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.25, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.12, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
                  
            
            VStack {
                Spacer()
                
                Text("Guess the flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
                Spacer()
                
                VStack(spacing: 30) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundColor(.secondary)
                        
                        Text("\(countries[correctAnswer])")
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(flagName: countries[number])
                        }
                    }
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Your score is: \(score)")
                    .titleStyle()
                
                
                Spacer()
            }.padding()
            
        }
        .alert(scoreTitle, isPresented: $showingTitle) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is: \(score)")
        }
        .alert("The END", isPresented: $finished) {
            Button("Play Again", action: restartTheGame)
        } message: {
            Text("Your final score is: \(score)")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
        }
        showingTitle = true
    }
    
    func askQuestion() {
        if questionCounter == 8 {
            finished = true
        }
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        questionCounter += 1
    }
    
    func restartTheGame() {
        finished = false
        questionCounter = 1
        score = 0
        askQuestion()
    }
}

#Preview {
    ContentView()
}
