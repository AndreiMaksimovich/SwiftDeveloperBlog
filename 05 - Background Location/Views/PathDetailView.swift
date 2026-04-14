//
//  PathRecordDetailView.swift
//  05 - Background Location
//
//  Created by Andrei Maksimovich on 14/04/2026.
//

import SwiftUI
import MapKit

struct PathDetailView: View {
    var pathRecord: PathRecord
    
    var body: some View {
        VStack {
            if !pathRecord.text.isEmpty {
                Text(pathRecord.text)
            }
            Map {
                MapPolyline(coordinates: pathRecord.points.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) })
                    .stroke(.blue, lineWidth: 5)
            }
            List {
                Section("Path") {
                    ForEach(pathRecord.points) {pathPoint in
                        PathPointView(pathPoint: pathPoint)
                    }
                }
            }
        }
        .navigationTitle(pathRecord.title)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit", systemImage: "pencil") {
                    AppNavigator.shared.open(destination: .editPath(pathRecord: pathRecord))
                }
            }
        }
    }
}

#Preview {
    PreviewConatiner {
        PathDetailView(pathRecord: pathRecordPreviewMockData)
    }
}
