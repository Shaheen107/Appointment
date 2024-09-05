import SwiftUI

struct CalendarView: View {
    @Binding var selectedDate: Date
    @ObservedObject var viewModel: AppointmentViewModel
    @State private var calendar = Calendar.current
    
    var body: some View {
        VStack {
            DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
            
            List {
                ForEach(appointmentsForDate(selectedDate)) { appointment in
                    Text(appointment.title)
                }
            }
        }
    }
    
    private func appointmentsForDate(_ date: Date) -> [Appointment] {
        viewModel.appointments.filter { calendar.isDate($0.date, inSameDayAs: date) }
    }
}
