//
//  PathRecordView.swift
//  05 - Background Location
//
//  Created by Andrei Maksimovich on 14/04/2026.
//

import SwiftUI

struct PathListItemView: View {
    
    var pathRecord: PathRecord
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(pathRecord.title).font(.headline)
            if !pathRecord.text.isEmpty {
                Text(pathRecord.text).font(.subheadline)
            }
        }
    }
}

#Preview {
    PreviewConatiner {
        PathListItemView(pathRecord: pathRecordPreviewMockData)
    }
}
