import SwiftUI

struct AddAppointmentView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AppointmentViewModel
    
    @State private var title: String
    @State private var date: Date
    @State private var location: String
    @State private var notes: String
    @State private var priority: Priority
    @State private var reminder: Bool
    @State private var bookedBy: String
    @State private var contactNumber: String
    @State private var showAlert = false
    @State private var showSuccessAlert = false
    
    private let existingAppointment: Appointment?
    
    init(viewModel: AppointmentViewModel, appointment: Appointment? = nil) {
        _title = State(initialValue: appointment?.title ?? "")
        _date = State(initialValue: appointment?.date ?? Date())
        _location = State(initialValue: appointment?.location ?? "")
        _notes = State(initialValue: appointment?.notes ?? "")
        _priority = State(initialValue: appointment?.priority ?? .medium)
        _reminder = State(initialValue: appointment?.reminder ?? false)
        _bookedBy = State(initialValue: appointment?.bookedBy ?? "")
        _contactNumber = State(initialValue: appointment?.contactNumber ?? "")
        self.existingAppointment = appointment
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Appointment Details")) {
                    TextField("Title", text: $title)
                    DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                    TextField("Location", text: $location)
                    TextField("Notes", text: $notes)
                    Picker("Priority", selection: $priority) {
                        ForEach(Priority.allCases) { priority in
                            Text(priority.rawValue.capitalized).tag(priority)
                        }
                    }
                    Toggle("Set Reminder", isOn: $reminder)
                }
                
                Section(header: Text("Additional Information")) {
                    TextField("Booked By", text: $bookedBy)
                    TextField("Contact Number", text: $contactNumber)
                }
                
                Button("Save") {
                    if validateFields() {
                        let newAppointment = Appointment(
                            id: existingAppointment?.id ?? UUID(),
                            title: title,
                            date: date,
                            location: location,
                            notes: notes,
                            priority: priority,
                            reminder: reminder,
                            bookedBy: bookedBy,
                            contactNumber: contactNumber
                        )
                        
                        if let existingAppointment = existingAppointment {
                            if let index = viewModel.appointments.firstIndex(where: { $0.id == existingAppointment.id }) {
                                viewModel.appointments[index] = newAppointment
                            }
                        } else {
                            viewModel.addAppointment(newAppointment)
                        }
                        
                        if reminder {
                            scheduleNotification(for: newAppointment)
                        }
                        
                        showSuccessAlert = true
                    } else {
                        showAlert = true
                    }
                }
            }
            .navigationTitle(existingAppointment == nil ? "New Appointment" : "Edit Appointment")
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Incomplete Data"),
                    message: Text("Please fill out all required fields."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .alert(isPresented: $showSuccessAlert) {
                Alert(
                    title: Text("Success"),
                    message: Text("Appointment saved successfully!"),
                    dismissButton: .default(Text("OK")) {
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            }
        }
    }
    
    private func validateFields() -> Bool {
        return !title.isEmpty && !location.isEmpty && !bookedBy.isEmpty && !contactNumber.isEmpty
    }
}
