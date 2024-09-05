import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AppointmentViewModel()
    @State private var showingAddAppointment = false
    @State private var showingCalendar = false
    @State private var selectedDate = Date()
    @State private var selectedAppointment: Appointment?
    @State private var showingDeleteAlert = false
    @State private var appointmentToDelete: Appointment?
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.appointments.isEmpty {
                    Text("No appointments available")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(viewModel.appointments) { appointment in
                            NavigationLink(
                                destination: DetailView(appointment: appointment),
                                label: {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(appointment.title)
                                                .font(.headline)
                                            Text(appointment.date, style: .date)
                                                .font(.subheadline)
                                            Text(appointment.location)
                                                .font(.subheadline)
                                        }
                                        Spacer()
                                        Menu {
                                            Button(action: {
                                                selectedAppointment = appointment
                                                showingAddAppointment.toggle() // Show edit view
                                            }) {
                                                Label("Edit", systemImage: "pencil")
                                            }
                                            Button(action: {
                                                appointmentToDelete = appointment
                                                showingDeleteAlert.toggle() // Show delete confirmation alert
                                            }) {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        } label: {
                                            Image(systemName: "ellipsis")
                                                .foregroundColor(.blue)
                                        }
                                    }
                                }
                            )
                        }
                    }
                }
            }
            .navigationTitle("Appointments")
            .toolbar {
                Button(action: {
                    selectedAppointment = nil
                    showingAddAppointment.toggle() // Show add view
                }) {
                    Label("Add Appointment", systemImage: "plus")
                }
                
                Button(action: {
                    showingCalendar.toggle()
                }) {
                    Label("Calendar", systemImage: "calendar")
                }
            }
            .sheet(isPresented: $showingAddAppointment) {
                AddAppointmentView(viewModel: viewModel, appointment: selectedAppointment)
            }
            .sheet(isPresented: $showingCalendar) {
                CalendarView(selectedDate: $selectedDate, viewModel: viewModel)
            }
            .alert(isPresented: $showingDeleteAlert) {
                Alert(
                    title: Text("Confirm Deletion"),
                    message: Text("Are you sure you want to delete this appointment?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let appointmentToDelete = appointmentToDelete {
                            deleteAppointment(appointmentToDelete)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
    
    private func deleteAppointment(_ appointment: Appointment) {
        if let index = viewModel.appointments.firstIndex(where: { $0.id == appointment.id }) {
            viewModel.appointments.remove(at: index)
        }
    }
}
