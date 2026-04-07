//
//  ContentView.swift
//  04 - HttpClient
//
//  Created by Andrei Maksimovich on 09/04/2026.
//

import SwiftUI

struct DemoView: View {
    @State var model: IDemoViewModel
    
    init(model: IDemoViewModel) {
        self.model = model
    }
    
    init() {
        self.model = DemoViewModel()
    }
    
    @ViewBuilder var contentAlbums: some View {
        List(model.albums!, id: \.id) {album in
            VStack {
                Text(album.title).font(.title3)
            }
        }
    }
    
    @ViewBuilder func contentError(error: Error) -> some View {
        VStack {
            Text(error.localizedDescription).foregroundStyle(.red)
            Button("Retry") {
                model.retry()
            }
        }
    }
        
    var body: some View {
        VStack {
            if model.albums != nil {
                contentAlbums
            }
            switch model.state {
                case .error(let error):
                    contentError(error: error)
                case .ready:
                    Button("Refresh") {
                        model.refresh()
                    }
                case .loadingData:
                    ProgressView().progressViewStyle(.circular)
                default: EmptyView()
            }
        }
        .onAppear {
            model.onAppear()
        }
        .onDisappear {
            model.onDisappear()
        }
    }
}

#Preview("Normal") {
    PreviewConatiner {
        DemoView()
    }
}

#Preview("Fake Network") {
    PreviewConatiner {
        DemoView(model: DemoViewModel(apiClient: instantiateDemoApiMockBasedOnFakeNetworkData()))
    }
}

#Preview("Mock Data") {
    PreviewConatiner {
        DemoView(model: DemoViewModelMock(behaviour: .mockData))
    }
}

#Preview("Error") {
    PreviewConatiner {
        DemoView(model: DemoViewModelMock(behaviour: .errorState))
    }
}

#Preview("Loading") {
    PreviewConatiner {
        DemoView(model: DemoViewModelMock(behaviour: .loadingState))
    }
}
