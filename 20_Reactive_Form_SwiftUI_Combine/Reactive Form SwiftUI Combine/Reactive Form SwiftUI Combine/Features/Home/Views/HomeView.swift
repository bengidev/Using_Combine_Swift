//
//  HomeView.swift
//  Reactive Form SwiftUI Combine
//
//  Created by Bambang Tri Rahmat Doni on 06/01/24.
//

import SwiftUI

struct HomeView: View {
    // $model is a ObservedObject<ExampleModel>.Wrapper
    // and $model.objectWillChange is a Binding<ObservableObjectPublisher>
    @StateObject private var model = HomeViewModel() // 1
    
    // $buttonIsDisabled is a Binding<Bool>
    @State private var isDisabledButton = true // 2
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                    Text("Hello, world!")
                }
                .font(.headline)
                Divider()
                
                Form {
                    TextField("First Entry", text: $model.firstEntry) // 3
                        .lineLimit(1)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    TextField("Second Entry", text: $model.secondEntry) // 3
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    ForEach(model.validationMessages, id: \.self) {message in // 4
                        Text(message)
                            .foregroundColor(.red)
                            .font(.callout)
                            .transition(.opacity)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 7.0))
                .frame(height: UIScreen.main.bounds.height * 0.4)
                
                Spacer()
                
                Button("Submit") { }
                    .buttonStyle(.borderedProminent)
                    .disabled(isDisabledButton)
                    .onReceive(model.submitAllowed) { submitAllowed in // 5
                        self.isDisabledButton = !submitAllowed
                    }
            }
            .animation(.easeInOut, value: model.validationMessages)
            .padding()
            .navigationTitle("Reactive Form")
        }
    }
}

/// 1. The model is exposed to SwiftUI using @ObservedObject.
/// 2. @State buttonIsDisabled is declared locally to this view, with a default value of true.
/// 3. The projected value from the property wrapper ($model.firstEntry and $model.secondEntry)
///     are used to pass a Binding to the TextField view element. The Binding will trigger updates
///     back on the reference model when the user changes a value, and will let SwiftUI’s components
///     know that changes are about to happen if the exposed model is changing.
/// 4. The validation messages, which are generated and assigned within the model is invisible
///     to SwiftUI here as a combine publisher pipeline. Instead this only reacts to the model changes 
///     being exposed by those values changing, irregardless of what mechanism changed them.
/// 5. As an example of how to use a published with onReceive, an onReceive subscriber is used to listen
///     to a publisher which is exposed from the model reference. In this case, we take the value and
///     store is locally as @State within the SwiftUI view, but it could also be used after
///     some transformation if that logic were more relevant to just the view display of the resulting values.
///     In this case, we use it with disabled on Button to enable or disable that UI element based on
///     the value stored in the @State.
///

#Preview {
    HomeView()
}
