//
//  RecommendVIew.swift
//  saucialApp
//
//  Created by kawayuta on 4/29/21.
//

import SwiftUI
import UIKit
import Shuffle_iOS
import SnapKit

struct RecommendView: UIViewRepresentable {
    @EnvironmentObject var mapViewModel: MapViewModel
    @EnvironmentObject var viewModel: RecommendViewModel
    @EnvironmentObject var saunaviMessageViewModel: SaunaviMessageViewModel
    let main = UIView()
    let cardStack = SwipeCardStack()
    let button = ButtonStackView()
    
//    init() {
//        viewModel.region = mapViewModel.region
//        viewModel.currentRegion = mapViewModel.currentRegion
//    }
    
    
    func makeUIView(context: Context) -> UIView {
        button.delegate = context.coordinator
        cardStack.dataSource = context.coordinator
        cardStack.delegate = context.coordinator
        main.addSubview(cardStack)
        main.addSubview(button)
        
        cardStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(button.snp.top).inset(-10)
        }
        
        button.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.bottom.equalToSuperview().inset(15)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        return main
    }
    
    
    func makeCoordinator() -> RecommendView.Coordinator {
        return Coordinator(viewModel: viewModel, cardStack: cardStack, saunaviMessageViewModel: saunaviMessageViewModel)
    }


    func updateUIView(_ uiView: UIView, context: Context) {
        print("\(#function)")
        cardStack.reloadData()
    }
}


extension RecommendView {
    class Coordinator: NSObject, ButtonStackViewDelegate, SwipeCardStackDataSource, SwipeCardStackDelegate {
        
        
        @EnvironmentObject var saunaviViewModel: SaunaviMessageViewModel
        @ObservedObject var viewModel: RecommendViewModel
        @ObservedObject var saunaviMessageViewModel: SaunaviMessageViewModel
        let cardStack: SwipeCardStack
        
        init(viewModel: RecommendViewModel, cardStack: SwipeCardStack, saunaviMessageViewModel: SaunaviMessageViewModel) {
            self.viewModel = viewModel
            
            self.cardStack = cardStack
            self.saunaviMessageViewModel = saunaviMessageViewModel
        }
        
        func didTapButton(button: TinderButton) {
            switch button.tag {
                case 1:
                  cardStack.undoLastSwipe(animated: true)
                case 2:
                  cardStack.swipe(.left, animated: true)
                case 3:
                  cardStack.swipe(.up, animated: true)
                case 4:
                  cardStack.swipe(.right, animated: true)
                case 5:
                  cardStack.reloadData()
                default:
                  break
            }
        }
        
        func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
            return card(sauna: viewModel.saunas[index])
        }

        func numberOfCards(in cardStack: SwipeCardStack) -> Int {
          return viewModel.saunas.count
        }
        
        func card(sauna: Sauna) -> SwipeCard {
            
            let card = SwipeCard()
            card.swipeDirections = [.left, .right]
            card.footerHeight = 80
            for direction in card.swipeDirections {
                card.setOverlay(RecommendCardOverlay(direction: direction), forDirection: direction)
            }
            
            card.content = RecommendCardContent(withImage: sauna.image.url, sauna: sauna)
            card.footer = RecommendCardFooter(withTitle: sauna.name_ja, subtitle: sauna.address)
            
            return card
        }
        
        func cardStack(_ cardStack: SwipeCardStack, didUndoCardAt index: Int, from direction: SwipeDirection) {
            print("Undo \(direction) swipe on \(viewModel.saunas[index].name_ja)")
          }

        func didSwipeAllCards(_ cardStack: SwipeCardStack) {
            DispatchQueue.main.async {
                self.viewModel.shouldFetch.toggle()
            }
        }
        
        func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
            
            if direction == SwipeDirection.right {
                viewModel.putWent(sauna_id: String(viewModel.saunas[index].id))
                print("Swiped \(direction) on \(viewModel.saunas[index].name_ja)")
                print("いきたい")
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.prepare()
                generator.impactOccurred()
            } else if direction == SwipeDirection.left {
                viewModel.putNotWent(sauna_id: String(viewModel.saunas[index].id))
                print("Swiped \(direction) on \(viewModel.saunas[index].name_ja)")
                print("いきたくない")
                let generator = UIImpactFeedbackGenerator(style: .soft)
                generator.prepare()
                generator.impactOccurred()
            }
          }

        func cardStack(_ cardStack: SwipeCardStack, didSelectCardAt index: Int) {
            print("Card tapped")
        }
        
        
    }
}
