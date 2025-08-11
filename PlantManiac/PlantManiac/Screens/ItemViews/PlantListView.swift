import SwiftUI

struct PlantListView: View {
    
    var plant: PlantFirestoreModel
    var onLikeToggle: () -> Void
    
    @State private var isLiked: Bool = false
    
    @State private var showSafari = false
    @State private var safariURL: URL?

    init(plant: PlantFirestoreModel, onLikeToggle: @escaping () -> Void) {
        self.plant = plant
        _isLiked = State(initialValue: plant.isLiked)
        self.onLikeToggle = onLikeToggle
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            
            ValidatedAsyncImageView(urlString: plant.imageURL)
                .frame(width: 90, height: 90)
                .cornerRadius(20)
                .clipped()
            
            VStack(alignment: .leading, spacing: 12) {
                Text(plant.name)
                    .font(.custom("Georgia-Italic", size: 18))
                    .foregroundColor(.accent)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(2)
                        .truncationMode(.tail)
                
                Text("\(NSLocalizedString("price", comment: "")): \(plant.price)")
                    .font(.custom("Georgia", size: 16))
                    .foregroundColor(.accent)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                         
                Button(action: {
                    isLiked.toggle()
                    updateIsLiked(for: plant, to: isLiked)
                    onLikeToggle()
                }) {
                               Image(systemName: isLiked ? "heart.fill" : "heart")
                                   .foregroundColor(isLiked ? .red : .gray)
                                   .font(.system(size: 24))
                           }
                           .padding(.top, -6)
                
                Button(action: {

                    if let url = URL(string: "https://dzungla-plants.hr") {
                            safariURL = url
                            print("✅ Valid URL set: \(url)")
                       }
                }) {
                    Text("buy_now")
                        .font(.custom("Georgia", size: 14))
                        .textCase(.uppercase)
                        .foregroundColor(.accent)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.button)
                        .cornerRadius(12)
                }
            }
            .sheet(item: $safariURL) { url in
                SafariView(url: url)
            }


        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.button.opacity(1), lineWidth: 3)
        )
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
        .padding(.horizontal)
        

    }
}

