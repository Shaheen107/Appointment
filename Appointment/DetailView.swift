import SwiftUI

struct DetailView: View {
    var appointment: Appointment
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Title: \(appointment.title)")
                    .font(.title)
                Text("Date: \(appointment.date, style: .date) \(appointment.date, style: .time)")
                    .font(.headline)
                Text("Location: \(appointment.location)")
                    .font(.subheadline)
                Text("Notes: \(appointment.notes)")
                    .font(.body)
                Text("Priority: \(appointment.priority.rawValue.capitalized)")
                    .font(.footnote)
                Text("Reminder: \(appointment.reminder ? "Yes" : "No")")
                    .font(.footnote)
                Text("Booked By: \(appointment.bookedBy)")
                    .font(.footnote)
                Text("Contact: \(appointment.contactNumber)")
                    .font(.footnote)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Appointment Details")
    }
}
