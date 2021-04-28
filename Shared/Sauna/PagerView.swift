//
//  PagerView.swift
//  saucialApp
//
//  Created by kawayuta on 4/28/21.
//

import SwiftUI

class PagerViewModel: ObservableObject {
    @Published var lastDrag: CGFloat = 0.0
    @Binding var currentIndex: Int
    
    init(currentIndex: Binding<Int>) {
        self._currentIndex = currentIndex
    }
}

struct PagerView<Content: View>: View {
    let pageCount: Int
    @Binding var currentIndex: Int
    let content: Content
    
    @ObservedObject var viewModel: PagerViewModel
    @GestureState private var translation: CGFloat = 0
    
    init(pageCount: Int, currentIndex: Binding<Int>, @ViewBuilder content: () -> Content) {
        self.pageCount = pageCount
        self._currentIndex = currentIndex
        self.content = content()
        
        viewModel = PagerViewModel(currentIndex: currentIndex)
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                content.frame(width: geometry.size.width)
            }
            .frame(width: geometry.size.width, alignment: .leading)
            .offset(x: (-CGFloat(viewModel.currentIndex) * geometry.size.width) + viewModel.lastDrag)
            .gesture(
                DragGesture().updating($translation) { value, state, _ in
                    state = value.translation.width
                    viewModel.lastDrag = value.translation.width
                }.onEnded { value in
                    let offset = value.predictedEndTranslation.width / geometry.size.width
                    let newIndex = (CGFloat(self.currentIndex) - offset).rounded()
                    let newIndexBound = min(max(Int(newIndex), 0), self.pageCount - 1)
                    let indexToChangeTo = min(max(newIndexBound, currentIndex - 1), currentIndex + 1)
                    if indexToChangeTo != viewModel.currentIndex {
                        withAnimation(.easeOut) { viewModel.currentIndex = indexToChangeTo }
                    } else {
                        withAnimation(.easeOut) { viewModel.lastDrag = 0 }
                    }
                }
            )
        }
    }
}

#if DEBUG
struct PagerView_Previews: PreviewProvider {
    
    static var previews: some View {
        PagerViewWrapper()
    }
    
    struct PagerViewWrapper: View {
        @State var index = 0
        
        var body: some View {
            PagerView(pageCount: 4, currentIndex: $index) {
                Color.blue
                Color.red
                Color.green
                Color.yellow
            }
        }
    }
    
}
#endif
