//
//  SleepView.swift
//  WellnessApp
//
//  Sleep tracking view
//

import SwiftUI

struct SleepView: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var showingAddSleep = false
    
    var body: some View {
        NavigationView {
            List {
                Section("Last Night") {
                    if let lastSleep = dataStore.getLastSleepRecord() {
                        SleepDetailCard(record: lastSleep)
                    } else {
                        Text("No sleep data recorded")
                            .foregroundColor(.secondary)
                            .italic()
                    }
                }
                
                Section("Sleep History") {
                    let sortedRecords = dataStore.sleepRecords.sorted { $0.date > $1.date }
                    if sortedRecords.isEmpty {
                        Text("No sleep records yet")
                            .foregroundColor(.secondary)
                            .italic()
                    } else {
                        ForEach(sortedRecords.prefix(7)) { record in
                            SleepHistoryRow(record: record)
                        }
                    }
                }
                
                Section("Sleep Tips") {
                    TipRow(
                        icon: "moon.stars.fill",
                        title: "Consistent Schedule",
                        description: "Go to bed and wake up at the same time every day"
                    )
                    
                    TipRow(
                        icon: "bed.double.fill",
                        title: "Comfortable Environment",
                        description: "Keep your bedroom cool, dark, and quiet"
                    )
                    
                    TipRow(
                        icon: "iphone.slash",
                        title: "Limit Screen Time",
                        description: "Avoid screens 1 hour before bedtime"
                    )
                }
            }
            .navigationTitle("Sleep")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddSleep = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSleep) {
                AddSleepView()
                    .environmentObject(dataStore)
            }
        }
    }
}

struct SleepDetailCard: View {
    let record: SleepRecord
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "moon.fill")
                    .foregroundColor(.blue)
                    .font(.title)
                
                Spacer()
                
                Text(record.quality.rawValue)
                    .font(.headline)
                    .foregroundColor(.green)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Duration")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(String(format: "%.1f", record.duration)) hours")
                        .font(.headline)
                }
                
                HStack {
                    Text("Bedtime")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(record.sleepTime, style: .time)
                        .font(.headline)
                }
                
                HStack {
                    Text("Wake Time")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(record.wakeTime, style: .time)
                        .font(.headline)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct SleepHistoryRow: View {
    let record: SleepRecord
    
    var body: some View {
        HStack {
            Image(systemName: "moon.fill")
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(record.date, style: .date)
                    .font(.headline)
                
                HStack {
                    Text(record.sleepTime, style: .time)
                    Text("→")
                        .foregroundColor(.secondary)
                    Text(record.wakeTime, style: .time)
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(String(format: "%.1f", record.duration))h")
                    .font(.headline)
                Text(record.quality.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct AddSleepView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataStore: DataStore
    
    @State private var sleepDate = Date()
    @State private var sleepTime = Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var wakeTime = Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var quality = SleepQuality.good
    
    var body: some View {
        NavigationView {
            Form {
                Section("Sleep Details") {
                    DatePicker("Date", selection: $sleepDate, displayedComponents: .date)
                    DatePicker("Sleep Time", selection: $sleepTime, displayedComponents: [.hourAndMinute])
                    DatePicker("Wake Time", selection: $wakeTime, displayedComponents: [.hourAndMinute])
                    
                    Picker("Quality", selection: $quality) {
                        ForEach(SleepQuality.allCases, id: \.self) { quality in
                            Text(quality.rawValue).tag(quality)
                        }
                    }
                }
                
                Section {
                    let duration = Calendar.current.dateComponents([.hour, .minute], from: sleepTime, to: wakeTime)
                    let hours = Double(duration.hour ?? 0) + Double(duration.minute ?? 0) / 60.0
                    Text("Duration: \(String(format: "%.1f", hours)) hours")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Add Sleep Record")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let record = SleepRecord(
                            date: sleepDate,
                            sleepTime: sleepTime,
                            wakeTime: wakeTime,
                            quality: quality
                        )
                        dataStore.addSleepRecord(record)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SleepView()
        .environmentObject(DataStore())
}

