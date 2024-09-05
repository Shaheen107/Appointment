import SwiftUI

struct EditAppointmentView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AppointmentViewModel
    @Binding var appointment: Appointment
    
    var body: some View {
        Form {
            Section(header: Text("Appointment Details")) {
                TextField("Title", text: $appointment.title)
                DatePicker("Date", selection: $appointment.date, displayedComponents: [.date, .hourAndMinute])
                TextField("Location", text: $appointment.location)
                TextField("Notes", text: $appointment.notes)
                Picker("Priority", selection: $appointment.priority) {
                    ForEach(Priority.allCases) { priority in
                        Text(priority.rawValue.capitalized).tag(priority)
                    }
                }
                Toggle("Set Reminder", isOn: $appointment.reminder)
            }
            
            Section(header: Text("Additional Information")) {
                TextField("Booked By", text: $appointment.bookedBy)
                TextField("Contact Number", text: $appointment.contactNumber)
            }
            
            Button("Save") {
                if let index = viewModel.appointments.firstIndex(where: { $0.id == appointment.id }) {
                    viewModel.appointments[index] = appointment
                }
                presentationMode.wrappedValue.dismiss()
            }
        }
        .navigationTitle("Edit Appointment")
    }
}
