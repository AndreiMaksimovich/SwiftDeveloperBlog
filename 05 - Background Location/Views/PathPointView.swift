//
//  PathPointView.swift
//  05 - Background Location
//
//  Created by Andrei Maksimovich on 15/04/2026.
//

import SwiftUI

struct PathPointView: View {
    
    let pathPoint: PathRecordPoint
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(String(stringLiteral: "lat:  " + String(format: "%.7f", pathPoint.latitude)))
            Text(String(stringLiteral: "long: " + String(format: "%.7f", pathPoint.longitude)))
            Text(String(stringLiteral: "alt : " + String(format: "%.2f", pathPoint.latitude)))
        }
    }
}

#Preview {
    PreviewConatiner {
        PathPointView(
            pathPoint: .init(latitude: 11.2345, longitude: 55.12345678, altitude: 10.11)
        )
    }
}
