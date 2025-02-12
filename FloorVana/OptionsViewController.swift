//
//  OptionsViewController.swift
//  FloorVana
//
//  Created by admin34 on 14/11/24.
//

import UIKit
import ImageIO

class OptionsViewController: UIViewController {
    
    @IBOutlet weak var genButton: UIButton!
    @IBOutlet weak var Upload: UIButton!
    
    
    @IBOutlet weak var gifImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        playGif()
    }
    
    
    private func playGif() {
        
        if let gifURL = Bundle.main.url(forResource: "HomePlay", withExtension: "gif"),
           let gifData = try? Data(contentsOf: gifURL),
           let gifImage = UIImage.gifImageWithData(gifData) {
            gifImageView.image = gifImage
        } else {
            print("Failed to load GIF from bundle")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }


    
    @IBAction func genButton(_ sender: UIButton) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        if let drawVC = mainStoryboard.instantiateViewController(withIdentifier: "drawViewController") as? DrawViewController {
            drawVC.hidesBottomBarWhenPushed = true
            
            if let navigationController = self.navigationController {
                navigationController.pushViewController(drawVC, animated: true)
                
            } else {
                
                print("Error: No Navigation Controller available.")
            }
        }
    }

    @IBAction func Upload(_ sender: UIButton) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                
               
                if let captureVC = mainStoryboard.instantiateViewController(withIdentifier: "capture") as? ImageCaptureViewController {
                    
                    captureVC.modalPresentationStyle = .fullScreen
                    
                    
                    captureVC.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissCaptureVC))
                    
                    
                    let navController = UINavigationController(rootViewController: captureVC)
                    navController.modalPresentationStyle = .fullScreen
                    present(navController, animated: true, completion: nil)
                }
            }

    
    @objc func dismissCaptureVC() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Extension to handle GIFs
extension UIImage {
    static func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        return UIImage.animatedImageWithSource(source)
    }

    static func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        var images = [UIImage]()
        let count = CGImageSourceGetCount(source)
        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: cgImage))
            }
        }
        let duration = 0.05 * Double(count)
        return UIImage.animatedImage(with: images, duration: duration)
    }
    
}
