//
//  MapViewModel.swift
//  SwiftDeveloperBlog
//
//  Created by Andrei Maksimovich
//

import SwiftUI
import MapLibre
import MapKit

@Observable
class MapViewModel: NSObject, MLNMapViewDelegate {
    
    private static let logTag = "[MapViewModel]"
    private var logId: String
    private var mlnMapView: MLNMapView?
    
    private(set) var customMapPaths: [String: CustomMapPath] = [:]
    
    init(logId: String) {
        self.logId = logId
        super.init()
    }
    
    private func log(_ items: Any...) {
        debugPrint("\(Self.logTag): \(logId)", items)
    }
    
    func mapView(_: MLNMapView, didFinishLoading style: MLNStyle) {
        log("mapView did finish loading style")
    }
    
    func setup(_ mlnMapView: MLNMapView) {
        self.mlnMapView = mlnMapView
        mlnMapView.delegate = self
        
        mlnMapView.showsUserLocation = true
        mlnMapView.showsHeading = true
        mlnMapView.showsUserHeadingIndicator = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Self.handleMapTap))
        mlnMapView.addGestureRecognizer(gestureRecognizer)
    }
    
    func setCenter(location: CLLocationCoordinate2D, zoomLevel: Double, animated: Bool) {
        guard let mlnMapView else { return }
        mlnMapView.setCenter(location, zoomLevel: zoomLevel, animated: animated)
    }
    
    @objc func handleMapTap(_ gesture: UITapGestureRecognizer) {
        guard let mapView = gesture.view as? MLNMapView else { return }
        
        // Convert touch location to map view coordinates
        let touchPoint = gesture.location(in: mapView)
        
        // Define a small bounding box for the tap (around 10x10 points)
        let touchSize: CGFloat = 10.0
        let touchRect = CGRect(x: touchPoint.x - touchSize/2,
                               y: touchPoint.y - touchSize/2,
                               width: touchSize, height: touchSize)
        
        // Query the map for rendered features in this area
        let features = mapView.visibleFeatures(in: touchRect, styleLayerIdentifiers: nil)
        
        for feature in features {
            print(feature.self, feature.attributes)
        }
    }
    
    func addPath(id: String, color: UIColor) {
        guard let mapView = mlnMapView else { return }
        do {
            guard let style = mapView.style else {
                throw MapViewError.mapViewNotReady
            }
            guard let pathJsonFilePath = MapAssets.pathPath(id) else {
                throw MapViewError.pathNotExist
            }
            
            let customMapPath = CustomMapPath(id: id)
            
            guard customMapPaths[id] == nil else {
                throw MapViewError.pathAlreadyExist
            }
            
            let data = try Data(contentsOf: URL(fileURLWithPath: pathJsonFilePath))
            let shape = try MLNShape(data: data, encoding: String.Encoding.utf8.rawValue)
            let source = MLNShapeSource(identifier: "path-source.\(id)", shape: shape, options: nil)
            style.addSource(source)
            
            let layer = MLNLineStyleLayer(identifier: "path-layer.\(id)", source: source)
            layer.lineColor = NSExpression(forConstantValue: color)
            layer.lineWidth = NSExpression(forConstantValue: 3.0)
    
            customMapPaths[id] = customMapPath
            style.addLayer(layer)
        } catch {
            print(error)
        }
    }
    
    struct CustomMapPath {
        var id: String
        var sourceId: String
        var layerId: String
        
        init(id: String) {
            self.id = id
            self.sourceId = "path-source.\(id)"
            self.layerId = "path-layer.\(id)"
        }
    }
    
    enum MapViewError: Error {
        case mapViewNotReady
        case pathNotExist
        case pathAlreadyExist
    }
}
