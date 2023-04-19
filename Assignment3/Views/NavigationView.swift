//
//  NavigationView.swift
//  Assignment3
//
//  Created by Dan Kolan on 3/20/23.
//

import SwiftUI

struct NavigationView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(
                    destination:
                        BugListView(),
                    label: {
                        Text("Bugs")
                    }
                )
                NavigationLink(
                    destination:
                        FishListView(),
                    label: {
                        Text("Fish")
                    }
                )
                NavigationLink(
                    destination:
                        VillagersListView(),
                    label: {
                        Text("Villagers")
                    }
                )
            }
            .navigationBarTitle("Animal Crossing Reference")
            .listStyle(.grouped)
        }
    }
}

struct CategoryNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView()
    }
}
