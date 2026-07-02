//
//  MapView.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich
//

import SwiftUI
import MapLibre
import MapKit

struct MapView: UIViewRepresentable {
    
    @State var model: MapViewModel
    var mapStyleJson: () -> String
    
    func makeUIView(context: Context) -> MLNMapView {
        let mapView = MLNMapView(frame: .zero, styleJSON: mapStyleJson())
        model.setup(mapView)
    
        model.setCenter(location: CLLocationCoordinate2D(latitude: 42.27047765858147, longitude: 42.699130660683764), zoomLevel: 13, animated: false)
                
        for path in [["001.Gelati-Motsameda", UIColor.systemOrange], ["002.SatapliaForest", UIColor.systemBlue ], ["003.Sataplia-Kutaisi", UIColor.systemPink]] {
            model.addPath(id: path[0] as! String, color: path[1] as! UIColor)
        }
        
        return mapView
    }
        
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject {}

    func updateUIView(_: MLNMapView, context: Context) {}
}



