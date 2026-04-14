//
//  PathListView.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich on 14/04/2026.
//

import SwiftUI
import SwiftData

struct PathListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.editMode) var editMode
    @Query private var pathRecords: [PathRecord]
    private let pathRecordManager: any IPathRecordManager
    
    init(pathRecordManager: any IPathRecordManager) {
        self.pathRecordManager = pathRecordManager
    }
    
    init() {
        self.pathRecordManager = AppEnvironment.shared.pathRecordManager
    }
    
    var body: some View {
        List {
            ForEach(pathRecords) {pathRecord in
                NavigationLink(value: AppNavigationDestination.pathDetail(pathRecord: pathRecord)) {
                    PathListItemView(pathRecord: pathRecord)
                }
            }
            .onDelete {indexes in
                withAnimation {
                    indexes.map({pathRecords[$0]}).forEach {
                        pathRecordManager.delete($0)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem {
                Button {
                    AppNavigator.shared.open(destination: .recordNewPath)
                } label: {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
        .navigationTitle("Paths")
        .onChange(of: pathRecords) {
            if pathRecords.isEmpty, editMode?.wrappedValue != .inactive {
                editMode?.wrappedValue = .inactive
            }
        }
    }
}

#Preview {
    PreviewConatiner {
        PathListView()
    }
}

