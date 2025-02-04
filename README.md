

# The Daily Prophet

This iOS project demonstrates the use of **ARKit** and **SceneKit** to recognize reference images in the real world and overlay a video on top of them in augmented reality. The app uses **ARWorldTracking** and **ARImageTrackingConfiguration** to detect images and play corresponding videos when those images are recognized.

## Features

- **AR Image Recognition**: The app recognizes images from a specified folder (`ImagesToRecognize`).
- **Video Overlay**: When a recognized image is detected, a video is played on an **SCNPlane** that is rendered in the AR scene.
- **SceneKit** & **SpriteKit** Integration: Video is rendered using **SpriteKit's SKVideoNode** on a SceneKit plane in the AR scene.
- **World Tracking**: The app uses **ARWorldTrackingConfiguration** for a stable AR experience that tracks the real world in 3D space.

## Requirements

- **iOS 16.0+**
- **Xcode 16+**
- An iOS device with ARKit support (e.g., iPhone 15 or later)

## Setup

1. Clone the repository:

   ```bash
   git clone https://github.com/Firita/TheDailyProphet.git
   ```

2. Open the project in **Xcode**.

3. Make sure your device is connected, as ARKit requires a real device (simulator doesn't support AR).

4. Add your reference images to the `ImagesToRecognize` group in your Xcode project. Ensure these images are of high quality for better recognition accuracy.

5. Place video files in the project with names corresponding to the reference images (e.g., `image1.mp4`, `image2.mp4`).

6. Build and run the project on your device.

## How it Works

- The app uses **ARReferenceImage** objects to detect specific images in the real world.
- Once a recognized image is detected, a video file associated with that image is played using **SKVideoNode**.
- The video is displayed on a **SCNPlane**, which is rendered at the location of the detected image in the AR world.

## Usage

- Launch the app on a real device.
- Point the device's camera at one of the reference images that you added to the project.
- When the image is recognized, the corresponding video will overlay on top of the image in the AR scene.

## Contributions

Feel free to fork the repository and make improvements. Pull requests are always welcome!

---

### License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Feel free to edit the README as per your specific needs or additional features!
