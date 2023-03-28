//
//  CameraViewController.swift
//  Instagram
//
//  Created by Anıl Bürcü on 22.03.2023.
//
import AVFoundation
import UIKit

class CameraViewController: UIViewController {

    
    private var output = AVCapturePhotoOutput()
    private var captureSession:AVCaptureSession?
    private let previewLayer = AVCaptureVideoPreviewLayer()
    
    private let cameraView = UIView()
    
    private let shutterButton:UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.label.cgColor
        button.backgroundColor = nil
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .secondarySystemBackground
        title = "Take Photo"
        view.addSubview(cameraView)
        view.addSubview(shutterButton)
        setUpNavBar()
        checkCameraPermission()
        shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
        
  
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = true
        if let session = captureSession, !session.isRunning {
            session.startRunning()
        }
    }
    override func viewDidDisappear(_ animated: Bool) { // camera sekmesinden çıkınca hala arkaplanda çalışıyor, onu engellemek için didDisappear içinde kapattık ve DidAppear'da kontrol ettik.
        super.viewDidDisappear(animated)
        captureSession?.stopRunning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraView.frame = view.bounds
        previewLayer.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: view.width,
            height: view.width
        )
        
        let buttonSize:CGFloat = view.width/5
        
        shutterButton.frame = CGRect(x: (view.width-buttonSize)/2, y: view.safeAreaInsets.top + view.width + 100, width: buttonSize, height: buttonSize)
        shutterButton.layer.cornerRadius = buttonSize/2
       
    }
    
    @objc private func didTapTakePhoto(){
        output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
    
    private func checkCameraPermission(){
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video){
            
        case .notDetermined:
            // request
            AVCaptureDevice.requestAccess(for: .video) { [weak self]granted in
                guard granted else {
                    return
                }
                DispatchQueue.main.async {
                    self?.setUpCamera()
                }
            }
        case .authorized:
            setUpCamera()
        case .restricted, .denied:
            break
  
        @unknown default:
            break
        }
        
        
    }
    
    private func setUpCamera() {
        let captureSession = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                }
            }
            catch {
                print(error)
            }

            if captureSession.canAddOutput(output) {
                captureSession.addOutput(output)
            }

            // Layer
            previewLayer.session = captureSession
            previewLayer.videoGravity = .resizeAspectFill
            cameraView.layer.addSublayer(previewLayer)

            captureSession.startRunning()
        }
    }
    
    @objc private func didTapClose(){
        tabBarController?.selectedIndex = 0
        tabBarController?.tabBar.isHidden = false
    }
    
    private func setUpNavBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose))
        
       
    }
    


}

extension CameraViewController:AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation(),let image = UIImage(data: data) else {
            return
        }
        captureSession?.stopRunning()
        
        guard let resizedImage = image.sd_resizedImage(with: CGSize(width: 640, height: 640), scaleMode: .aspectFill) else {return} // Filtre uygulayınca fotoğrafın dönmesini engellemek için
        
        let vc = PostEditViewController(image: resizedImage)
        
        if #available(iOS 14.0, *) {
            vc.navigationItem.backButtonDisplayMode = .minimal
        }
        
        navigationController?.pushViewController(vc, animated: false)
    }
}
