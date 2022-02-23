//
//  CheckoutView.swift
//  CakeCorner
//
//  Created by Elman Asadi on 2/22/22.
//

import SwiftUI

struct CheckoutView: View {
    
    @ObservedObject var order : Order
    @State private var confirmationMessage = ""
    @State private var showConfirmation = false
    
    var body: some View {
        
        ScrollView {
            
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)
                
                Text("Your total is \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)
                
                Button("Place Order") {
                    Task {
                        await placeOrder()
                    }
                    
                }
                .padding()
            }
            
        }
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Thank you!", isPresented: $showConfirmation) {
            Button("ok") {}
        } message: {
            Text(confirmationMessage)
        }
        
    }
    
    func placeOrder() async {
        guard let  encoded = try? JSONEncoder().encode(order) else {
            print("Failde to encode order!")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            showConfirmation = true
            
        } catch {
            print("checkout failed!")
        }
        
    }
    
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
