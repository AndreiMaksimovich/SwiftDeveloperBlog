//
//  ContentView.swift
//  OfflineMaps
//
//  Created by Andrei Maksimovich
//

import SwiftUI

struct RootView: View {
    
    @State var permissionManager: AppPermissionManager = .shared
    
    var body: some View {
        
        TabView {
            
            Tab("Liberty", systemImage: "map.fill") {
                MapView(
                    model: .init(logId: "Liberty"),
                    mapStyleJson: {
                        mapStyleOSMLiberty(sourceUrl: MapAssets.pathMap("kutaisi-openstreetmap"))
                    })
            }
            
            Tab("Shortbread", systemImage: "map") {
                MapView(
                    model: .init(logId: "Shortbread"),
                    mapStyleJson: {
                        return mapStyleShortbreadColourful(sourceUrl: MapAssets.pathMap("kutaisi-shortbread"))
                    })
            }
            
        }
        .ignoresSafeArea(.all)
        
        
    }
}

#Preview {
    RootView()
}
