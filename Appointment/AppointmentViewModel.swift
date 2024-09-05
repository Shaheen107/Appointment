import Foundation

class AppointmentViewModel: ObservableObject {
    @Published var appointments: [Appointment] = [] {
        didSet {
            saveAppointments()
        }
    }
    
    private let appointmentsKey = "appointments"
    
    init() {
        loadAppointments()
    }
    
    func addAppointment(_ appointment: Appointment) {
        appointments.append(appointment)
    }
    
    func deleteAppointment(at offsets: IndexSet) {
        appointments.remove(atOffsets: offsets)
    }
    
    private func saveAppointments() {
        let encoder = JSONEncoder()
        do {
            let encoded = try encoder.encode(appointments)
            UserDefaults.standard.set(encoded, forKey: appointmentsKey)
        } catch {
            print("Failed to encode appointments: \(error.localizedDescription)")
        }
    }
    
    private func loadAppointments() {
        let decoder = JSONDecoder()
        if let savedAppointments = UserDefaults.standard.data(forKey: appointmentsKey) {
            do {
                let decodedAppointments = try decoder.decode([Appointment].self, from: savedAppointments)
                appointments = decodedAppointments
            } catch {
                print("Failed to decode appointments: \(error.localizedDescription)")
            }
        }
    }
}
