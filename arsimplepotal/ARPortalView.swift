//
//  ARPortalView.swift
//  arsimplepotal
//
//  Created by Yasuhito NAGATOMO on 2022/01/20.
//

import SwiftUI
import RealityKit
import ARKit

struct ARPortalView: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        let innerSpaceSize: Float = 3.0 // [meters]
        let innerSpaceMargin: Float = 0.02 // [meters]
        let innerSpaceOcclusion: Float = 0.01 // [meters] for to create a door inside the inner space

        let arView = ARView(frame: .zero)

        // load one of bundled rcprojects as an inner space
        let portalAnchor = try! SpaceUmbrellas.loadScene()   // Portal 1: Umbrellas
        // let portalAnchor = try! SpaceXmas.loadScene()        // Portal 2: Xmas
        // let portalAnchor = try! SpaceNight.loadScene()      // Portal 3: Night

        arView.scene.anchors.append(portalAnchor)

        // make an occlusion box that surrounds the inner space.
        let boxSize: Float = innerSpaceSize + innerSpaceMargin
        let boxMesh = MeshResource.generateBox(size: boxSize)
        let material = OcclusionMaterial()
        let occlusionBox = ModelEntity(mesh: boxMesh, materials: [material])
        occlusionBox.position.y = boxSize / 2
        occlusionBox.position.z = -(innerSpaceMargin + innerSpaceOcclusion) // make door using occlusion
        portalAnchor.addChild(occlusionBox)

        // start the AR session.
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        arView.session.run(config)

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
    }
}

//    struct ARPortalView_Previews: PreviewProvider {
//        static var previews: some View {
//            ARPortalView()
//        }
//    }
