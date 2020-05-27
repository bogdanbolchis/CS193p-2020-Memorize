//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Bogdan Bolchis on 24/05/2020.
//  Copyright © 2020 Bogdan Bolchis. All rights reserved.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame

    var body: some View {
        Grid(items: viewModel.cards) { card in
            CardView(card: card).onTapGesture {
                self.viewModel.choose(card: card)
            }
            .padding(5)
        }
        .padding()
        .foregroundColor(Color.orange)
        .background(Color.black)
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    func body(for size: CGSize) -> some View {
        ZStack {
            if self.card.isFaceUp {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                Text(self.card.content)
            } else {
                if !card.isMatched {
                    RoundedRectangle(cornerRadius: cornerRadius).fill()
                }
            }
        }
        .font(Font.system(size: fontSize(for: size)))
    }
    
    func fontSize(for size: CGSize) -> CGFloat {
        return min(size.width, size.height) * fontScaleFactor
    }
    
    let cornerRadius: CGFloat = 10
    let edgeLineWidth: CGFloat = 3
    let fontScaleFactor: CGFloat = 0.75
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
