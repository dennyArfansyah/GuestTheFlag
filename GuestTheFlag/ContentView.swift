//
//  ContentView.swift
//  GuestTheFlag
//
//  Created by Denny Arfansyah on 29/12/22.
//

import SwiftUI

struct FlagImage: View {
    var imageName: String
    
    var body: some View {
        Image(imageName.lowercased())
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    @State private var scoreTitle = ""
    @State private var showingAlert = false
    @State private var countries = ["Estonia", "France", "Germany", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score = 0
    @State private var totalQuestion = 0
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)],
                           center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            VStack {
                Spacer()
                
                Text("Guess The Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag!")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                        Text(countries[correctAnswer].lowercased().uppercased())
                            .font(.largeTitle.weight(.semibold))
                            .foregroundColor(.white)
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(imageName: countries[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20.0))
                
                Spacer()
                Spacer()
                
                Text("Score is \(score)")
                    .font(.headline.bold())
                    .foregroundColor(.white)
                
                Spacer()
            }.padding(20)
        }
        .alert("Answer", isPresented: $showingAlert) {
            Button(totalQuestion != 8 ? "Continue" : "Reset", action: askQuestion)
        } message: {
            Text(scoreTitle)
        }
    }
    
    private func flagTapped(_ number: Int) {
        if number == correctAnswer {
            showingAlert = false
            score += 1
            askQuestion()
        } else {
            showingAlert = true
            scoreTitle = "Wrong, that flag of \(countries[number].lowercased().uppercased())"
            score -= 1
        }
        totalQuestion += 1
        if totalQuestion == 8 {
            scoreTitle = "Your score is \(score). Game will reset and your score back to 0"
            showingAlert = true
        }
    }
    
    private func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        if totalQuestion == 8 {
            totalQuestion = 0
            score = 0
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
