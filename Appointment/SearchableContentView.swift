import SwiftUI

struct SearchableContentView: View {
    @StateObject private var viewModel = AppointmentViewModel()
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.appointments.filter { appointment in
                    searchText.isEmpty || appointment.title.localizedCaseInsensitiveContains(searchText)
                }) { appointment in
                    VStack(alignment: .leading) {
                        Text(appointment.title)
                            .font(.headline)
                        Text(appointment.date, style: .date)
                            .font(.subheadline)
                        Text(appointment.location)
                            .font(.subheadline)
                        Text(appointment.notes)
                            .font(.body)
                    }
                }
            }
            .navigationTitle("Appointments")
            .searchable(text: $searchText)
        }
    }
}
