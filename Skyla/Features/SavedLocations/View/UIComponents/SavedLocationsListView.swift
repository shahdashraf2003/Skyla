import SwiftUI

struct SavedLocationsListView: View {

    let locations: [SavedLocation]
    let foregroundColor: Color

    let onSelect: (SavedLocation) -> Void
    let onDeleteRequest: (SavedLocation) -> Void

    var body: some View {
        List {
            ForEach(locations) { location in

                SavedLocationRow(
                    location: location,
                    foregroundColor: foregroundColor
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    onSelect(location)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    if !location.isCurrent {
                        Button(role: .destructive) {
                            onDeleteRequest(location)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }

                if location.isCurrent && locations.count > 1 {
                    Rectangle()
                        .fill(foregroundColor.opacity(0.5))
                        .frame(height: 0.5)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .environment(\.defaultMinListRowHeight, 0)
        .animation(.spring(response: 0.4, dampingFraction: 0.85), value: locations)
    }
}