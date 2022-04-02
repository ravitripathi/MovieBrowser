//
//  MovieBrowserView.swift
//  
//
//  Created by Ravi Tripathi on 24/10/21.
//

import SwiftUI
import Kingfisher

public struct MovieBrowserView: View {
    let store = MovieNetworkStore()
    @State var movies = [Movie]()
    @State var searchTerm = ""
    public init() {}
    var columns: [GridItem] =
    Array(repeating: .init(.flexible()), count: 3)
    public var body: some View {
        ScrollView {
            withAnimation(.interpolatingSpring(stiffness: 30, damping: 8)) {
                LazyVGrid(columns: columns) {
                    ForEach(movies) { movie in
                        KFImage(URL(string: movie.poster)!)
                            .resizable()
                            .frame(width: nil, height: 300)
                    }
                }
            }
            
            //            .animation(.interpolatingSpring(stiffness: 30, damping: 8), value: 4)
            //            .animation(.interpolatingSpring(stiffness: 30, damping: 8, initialVelocity: 4))
        }
        .searchable(text: $searchTerm)
        .onSubmit(of: .search) {
            Task {
                self.movies = (try? await store.search(movie: searchTerm).search) ?? []
            }
        }
    }
    
    
}

struct MovieBrowserView_Previews: PreviewProvider {
    static var previews: some View {
        MovieBrowserView()
    }
}
