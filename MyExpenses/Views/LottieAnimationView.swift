//
//  LottieAnimationView.swift
//  MyExpenses
//
//  Created by Rishat Zakirov on 25.07.2025.
//

//import SwiftUI
//import Lottie
//
//struct LottieView: UIViewRepresentable {
//    let name: String
//    var loopMode: LottieLoopMode = .playOnce
//    var onAnimationCompleted: (() -> Void)? = nil
//    
//    func makeUIView(context: Context) -> UIView {
//        let view = UIView(frame: .zero)
//        let animationView = LottieAnimationView(name: name)
//        animationView.contentMode = .scaleAspectFit
//        animationView.loopMode = loopMode
//        
//        animationView.play { finished in
//            if finished {
//                onAnimationCompleted?()
//            }
//        }
//        
//        animationView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(animationView)
//        
//        NSLayoutConstraint.activate([
//            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
//            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
//            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//        ])
//        
//        return view
//    }
//    
//    func updateUIView(_ uiView: UIView, context: Context) {}
//}
//
//struct SplashView: View {
//    @Binding var isActive: Bool
//    
//    var body: some View {
//        LottieView(name: "animation") {
//            // Когда анимация закончилась
//            withAnimation {
//                isActive = false
//            }
//        }
//        .ignoresSafeArea()
//        .background(Color.white)
//    }
//}
