//
//  postBodyView.swift
//  saucialApp
//
//  Created by kawayuta on 4/24/21.
//

import SwiftUI
import SwiftUIX

struct postBodyView: View {
    
    @StateObject var viewModel: ReviewViewModel
    
    init(viewModel: ReviewViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        VStack {
            bodyView(viewModel: viewModel)
        }
    }
}

struct bodyView: View {
   
    let mainColor = Color.Neumorphic.main
    @StateObject var viewModel: ReviewViewModel
    
    init(viewModel: ReviewViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        VStack {
            textBodyArea
        }
    }
    
    var textBodyArea: some View {
        
            GeometryReader { geometry in
                
                VStack(alignment: .trailing) {
                    CustomTextField(text: $viewModel.paramsTextArea, isFirstResponder: true)
                        .onChange(of: viewModel.paramsTextArea, perform: { _ in viewModel.textAreaValidate()
                        print(viewModel.textAreaValidateState)
                    })
                    .foregroundColor(.black).font(.title3)
                    .background(RoundedRectangle(cornerRadius: 0)
                                    .fill(mainColor)
                                    .softInnerShadow(RoundedRectangle(cornerRadius: 0),
                                                         darkShadow: .gray,
                                                         lightShadow: .white,
                                                         spread: 0.01, radius: 2)
                        )
                    VStack(alignment: .trailing) {
                        Text("\(viewModel.paramsTextArea.count) / 300文字")
                            .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                            .foregroundColor(viewModel.paramsTextArea.count <= 300 ? .black : .red)
                    }
                    VStack(alignment: .leading) {
                        postBodyMultiImagePickerView(viewModel: viewModel).frame(height: 80)
                    }
                }.frame(height: geometry.size.height / 1.4)
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            }
    }
    
}



struct CustomTextField: UIViewRepresentable {
    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String
//        @Binding var clear: Bool
        var didBecomeFirstResponder = false
        init(text: Binding<String>) {
            _text = text
//            _clear = clear
        }
        private func textFieldDidChangeSelection(_ textField: UITextView) {
            text = textField.text ?? ""
//            if clear == true{
//                textField.text?.removeAll()
//                clear = false
//            }
        }
    }
    @Binding var text: String
//    @Binding var clear: Bool
    var isFirstResponder = false
    func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> UITextView {
        let textField = UITextView(frame: .zero)
        textField.delegate = context.coordinator
        textField.font =  UIFont.systemFont(ofSize: 18.0)
        textField.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        textField.sizeToFit()
        return textField
    }
    func makeCoordinator() -> CustomTextField.Coordinator {
        return Coordinator(text: $text)
    }
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<CustomTextField>) {
        uiView.text = text
        if isFirstResponder && !context.coordinator.didBecomeFirstResponder  {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
    }
}
