import SwiftUI

struct CategorySelectionView<Destination: View>: View {

    let destinationView: (ContentCategory) -> Destination
    let title: String
    @State private var selectedCategory: ContentCategory = .general
    @State private var navigate = false // ✅ Track navigation state

    var body: some View {
        VStack {
            Text("Select Category")
                .font(.title)
                .bold()
                .foregroundStyle(Color.white)
                .padding()
            Spacer()
            ForEach(ContentCategory.allCases, id: \.self) { category in
                Button(action: {
                    selectedCategory = category
                    navigate = true // ✅ Set navigation trigger
                }) {
                    Text(category.rawValue)
                        .frame(maxWidth: .infinity)
                }
                .gaButton
                .customBackButton()
                .padding(.horizontal)
            }

            NavigationLink(destination: destinationView(selectedCategory), isActive: $navigate) {
                EmptyView()
            }
            Spacer()
        }
        .padding()
        .custombackground

    }
}

