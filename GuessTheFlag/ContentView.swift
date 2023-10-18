//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Vitaliy Novichenko on 18.08.2023.
//

import SwiftUI

struct FlagImage: View {
    var image: String
    
    var body: some View {
        Image(image)
            .renderingMode(.original)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    @State private var score = 0
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    @State private var questions = 8
    @State private var correct = 0
    @State private var wrong = 0
    @State private var color = RadialGradient(stops: [
        .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
        .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
              ], center: .top, startRadius: 200, endRadius: 700)
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US", "Monaco"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var animationAmount = 0.0
    @State private var flagWasTapped = 4
    @State private var opacity = 1.0
    
    
    var body: some View {
        ZStack {
            color
                .ignoresSafeArea()
            VStack {
                Spacer()
                Button("Guess the Flag", action: newGame)
                //Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag off...")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                         } label: {
                            FlagImage(image: countries[number])
                                .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
                              
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                
                Spacer()
                Spacer()
                
                Text("Score \(score) from \(questions)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
        }
        .alert(questions != 0 ? scoreTitle : "Game Over", isPresented: $showingScore) {
            if questions != 0 { Button("Continue", action: askQuestion) } else {
                
                Button("New Game", role: .destructive, action: newGame)
                
            }
        } message: {
            Text(questions > 0 ? scoreMessage : "Correct: \(correct), Wrong: \(wrong)")
        }
    }
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
            correct += 1
            questions -= 1
            scoreMessage = "Your score is \(score)"
            animationAmount += 360
            flagWasTapped = number
            opacity = 1
        } else {
            scoreTitle = "Wrong"
            score -= 1
            wrong += 1
            questions -= 1
            opacity = 0.25
            scoreMessage = """
Thats the flag off \(countries[number])
     Your score is \(score)
"""
        }
        showingScore = true
        
    }
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    opacity = 1
    }
    func newGame() {
        score = 0
        questions = 8
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
