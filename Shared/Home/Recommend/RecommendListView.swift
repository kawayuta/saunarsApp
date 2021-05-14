//
//  RecommendListView.swift
//  saucialApp
//
//  Created by kawayuta on 5/4/21.
//

import SwiftUI
import UIKit
import Shuffle_iOS
import SnapKit

struct RecommendListView: UIViewRepresentable {
    let saunaIndex: Int
    @ObservedObject var viewModel: RecommendViewModel
    
    init(viewModel: RecommendViewModel, saunaIndex: Int) {
        self.viewModel = viewModel
        self.saunaIndex = saunaIndex
    }
    
    func makeUIView(context: Context) -> UIView {
        let main = UIView()
        let cardStack = SwipeCardStack()
        let button = ButtonStackView()
        button.delegate = context.coordinator
        cardStack.dataSource = context.coordinator
        cardStack.delegate = context.coordinator
        main.addSubview(cardStack)
//        main.addSubview(button)
        
        cardStack.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
//        button.snp.makeConstraints { make in
//            make.height.equalTo(50)
//            make.bottom.equalToSuperview()
//            make.leading.equalToSuperview()
//            make.trailing.equalToSuperview()
//        }
        return main
    }
    
    
    func makeCoordinator() -> RecommendListView.Coordinator {
        return Coordinator(viewModel: viewModel, saunaIndex: saunaIndex)
    }


    func updateUIView(_ uiView: UIView, context: Context) {
        print("\(#function)")
    }
}


extension RecommendListView {
    class Coordinator: NSObject, ButtonStackViewDelegate, SwipeCardStackDataSource, SwipeCardStackDelegate {
        func didTapButton(button: TinderButton) {
            print(1)
        }
        
        
        let saunaIndex: Int
        @ObservedObject var viewModel: RecommendViewModel
        
        init(viewModel: RecommendViewModel, saunaIndex: Int) {
            self.saunaIndex = saunaIndex
            self.viewModel = viewModel
            
        }
        
//        func didTapButton(button: TinderButton) {
//            switch button.tag {
//                case 1:
//                  cardStack.undoLastSwipe(animated: true)
//                case 2:
//                  cardStack.swipe(.left, animated: true)
//                case 3:
//                  cardStack.swipe(.up, animated: true)
//                case 4:
//                  cardStack.swipe(.right, animated: true)
//                case 5:
//                  cardStack.reloadData()
//                default:
//                  break
//            }
//        }
        
        func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
            return card(fromImage: viewModel.saunas[saunaIndex].image.url, index: index)
        }

        func numberOfCards(in cardStack: SwipeCardStack) -> Int {
          return [viewModel.saunas[saunaIndex]].count
        }
        
        func card(fromImage image_url: String, index: Int) -> SwipeCard {
            
            let card = SwipeCard()
            card.swipeDirections = [.left, .right]
            card.footerHeight = 80
            for direction in card.swipeDirections {
                card.setOverlay(RecommendCardOverlay(direction: direction), forDirection: direction)
            }
            
            card.content = RecommendCardContent(withImage: image_url, sauna: viewModel.saunas[index])
            card.footer = RecommendCardFooter(withTitle: viewModel.saunas[index].name_ja, subtitle: viewModel.saunas[index].address)
            
            return card
        }
        
        func cardStack(_ cardStack: SwipeCardStack, didUndoCardAt index: Int, from direction: SwipeDirection) {
            print("Undo \(direction) swipe on \(viewModel.saunas[index].name_ja)")
          }

        func didSwipeAllCards(_ cardStack: SwipeCardStack) {
//            self.cardStack.deleteCards(atIndices: 0)
//            viewModel.searchSaunaList(writeRegion: false)
        }
        
        func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
            
            if direction == SwipeDirection.right {
//                viewModel.putWent(sauna_id: String(viewModel.saunas[index].id))
//                print("Swiped \(direction) on \(viewModel.saunas[index].name_ja)")
                print("いきたい")
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.prepare()
                generator.impactOccurred()
            } else if direction == SwipeDirection.left {
//                viewModel.putNotWent(sauna_id: String(viewModel.saunas[index].id))
//                print("Swiped \(direction) on \(viewModel.saunas[index].name_ja)")
                print("いきたくない")
                let generator = UIImpactFeedbackGenerator(style: .soft)
                generator.prepare()
                generator.impactOccurred()
            }
            viewModel.swipeDidEnd(saunaIndex: saunaIndex)
          }

        func cardStack(_ cardStack: SwipeCardStack, didSelectCardAt index: Int) {
            print("Card tapped")
        }
        
        
    }
}
