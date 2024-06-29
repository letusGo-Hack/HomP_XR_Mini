//
//  ImmersiveView.swift
//  HomeP_XR_Mini_Vision
//
//  Created by Bummo Koo on 6/29/24.
//

import SwiftUI
import RealityKit
import ARKit

struct ImmersiveView: View {
    private let boxWidth: Float = 2
    private let boxHeight: Float = 0.015
    private let boxDepth: Float = 1

    var body: some View {
        RealityView { content, attachments in
            let anchor = AnchorEntity(.plane(.horizontal,
                                             classification: .table,
                                             minimumBounds: [0.3, 0.3]))
            content.add(anchor)
            
            let smallestDimension = min(boxWidth, boxHeight, boxDepth)
            let cornerRadius: Float = smallestDimension / 2
            
            let planeMesh = MeshResource.generateBox(width: boxWidth, height: boxHeight, depth: boxDepth, cornerRadius: cornerRadius)
            let planeMaterial = SimpleMaterial(color: .systemGray6, roughness: 0.8, isMetallic: false)
            let planeEntity = ModelEntity(mesh: planeMesh, materials: [planeMaterial])
            planeEntity.position = [0, 0, 0]
            
            anchor.addChild(planeEntity)
            
            if let photoAlbum = attachments.entity(for: "photoAlbum") {
                photoAlbum.position = [0.6, 0.3, -0.4]
                planeEntity.addChild(photoAlbum)
            }
            
            if let calendarEvents = attachments.entity(for: "calendarEvents") {
                calendarEvents.position = [-0.6, 0.3, -0.4]
                planeEntity.addChild(calendarEvents)
            }
            
            if let car = try? await Entity(named: "model_s") {
                car.position = [-0.65, 0.015, 0.3]
//                let rotationAngle: Float = .pi / 4  // 45 degrees in radians
//                car.transform.rotation = simd_quatf(angle: rotationAngle, axis: [1, 0, 0])
                planeEntity.addChild(car)
            }
            
            if let room = try? await Entity(named: "Room") {
                room.position = [0.65, 0.015, 0.3]
                room.scale = [0.03, 0.03, 0.03]
//                let rotationAngle: Float = .pi / 2  // 90 degrees in radians
//                room.transform.rotation = simd_quatf(angle: rotationAngle, axis: [0, 1, 0])  // Y-axis rotation
                planeEntity.addChild(room)
            }
        } update: { content, attachments in
            // Update the RealityKit content when SwiftUI state changes
        } placeholder: {
            Text("Loading")
        } attachments: {
            Attachment(id: "sample") {
                List {
                    ForEach(1..<10) { index in
                        Text("Item \(index)")
                    }
                }
                .padding()
                .glassBackgroundEffect()
                .frame(maxWidth: 320, maxHeight: 480)
            }
            
            Attachment(id: "photoAlbum") {
                ImagePickerView(viewModel: ImagePickerViewModel())
            }
            
            Attachment(id: "calendarEvents") {
                CalendarEventListView()
            }
        }
    }
}

#Preview {
    ImmersiveView()
}
