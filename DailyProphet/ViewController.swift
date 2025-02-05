import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController {

    lazy var sceneView: ARSCNView = {
        let arView = ARSCNView()
        arView.translatesAutoresizingMaskIntoConstraints = false
        arView.delegate = self
        return arView
    }() // This will be the ARSCNView that displays the AR content.

    let videoNode = SKVideoNode(fileNamed: Constants.videoName)

    // Constants for configuration and media files
    private enum Constants {
        static let imageToRecognizeFolder: String = "ImagesToRecognize"  // Folder containing reference images to track
        static let videoName: String = "HarryPotter.mp4"
        static let maximumNumberOfTrackedImages: Int = 1  // Maximum number of images to track at once
        static let videoSceneHeight: Int = 360  // Height for the video scene
        static let videoSceneWidth: Int = 640  // Width for the video scene
    }

    // This method is called when the view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // This method is called when the view is about to appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activeARWorldTracking()  // Starts AR world tracking with image recognition
    }

    private func setup() {
        view.addSubview(sceneView)
        NSLayoutConstraint.activate([
            sceneView.topAnchor.constraint(equalTo: view.topAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    // This method is called when the view is about to disappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        pauseARWorldTracking()  // Pauses AR session tracking
    }
}

// MARK: - ViewController Private functions
extension ViewController {

    // Starts AR session with image recognition
    private func activeARWorldTracking() {
        let configuration = ARWorldTrackingConfiguration()  // Creates a new world tracking configuration

        // Loads reference images from the specified folder in the app bundle
        if let imagesToTrack = ARReferenceImage.referenceImages(
            inGroupNamed: Constants.imageToRecognizeFolder,
            bundle: nil
        ) {
            configuration.detectionImages = imagesToTrack  // Sets the images to be tracked by ARKit
            configuration.maximumNumberOfTrackedImages = Constants.maximumNumberOfTrackedImages  // Limits the number of images being tracked
        }

        sceneView.session.run(configuration)  // Starts the AR session with the configured settings
    }

    // Pauses the AR session
    private func pauseARWorldTracking() {
        sceneView.session.pause()  // Pauses the AR session when the view disappears
    }
}

// MARK: - ARSCNViewDelegate
extension ViewController: ARSCNViewDelegate {

    // This delegate method is called whenever a new anchor is added to the AR session
    func renderer(
        _ renderer: SCNSceneRenderer,
        nodeFor anchor: ARAnchor
    ) -> SCNNode? {
        // Checks if the anchor is an image anchor (meaning it's a recognized image)
        guard
            let imageAnchor = anchor as? ARImageAnchor,
            let videoScene = videoScene()  // Calls videoScene to get the SKScene for the video
        else {
            return nil  // If it's not an image anchor, return nil (nothing to do)
        }

        // Creates a plane node to display the video
        let plane = SCNPlane(
            width: imageAnchor.referenceImage.physicalSize.width,  // Width of the plane based on the real image's size
            height: imageAnchor.referenceImage.physicalSize.height  // Height of the plane based on the real image's size
        )
        plane.firstMaterial?.diffuse.contents = videoScene  // Sets the video scene as the material for the plane

        // Create a node for the plane and rotate it so it faces the camera
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi / 2  // Rotates the plane by 90 degrees to face the camera

        let node = SCNNode()  // Create a new node to hold the plane node
        node.addChildNode(planeNode)  // Adds the plane node to the new node

        return node  // Returns the node to be displayed in the AR scene
    }

    func renderer(_ renderer: any SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard
            let imageAnchor = anchor as? ARImageAnchor,
            !imageAnchor.isTracked
        else {
            videoNode.play()
            return
        }
        videoNode.pause()
    }

    // This function creates a video scene to display on the AR image
    private func videoScene() -> SKScene? {

        // Creates a new SKScene to hold the video
        let videoScene = SKScene(
            size: CGSize(
                width: Constants.videoSceneWidth,  // Width of the video scene
                height: Constants.videoSceneHeight  // Height of the video scene
            )
        )

        // Positions the video in the center of the scene
        videoNode.position = CGPoint(
            x: videoScene.size.width / 2,
            y: videoScene.size.height / 2
        )
        videoNode.yScale = -1.0  // Flips the video vertically to match AR coordinate system
        videoScene.addChild(videoNode)  // Adds the video node to the scene

        return videoScene  // Returns the created video scene
    }
}
