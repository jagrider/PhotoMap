//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationsViewControllerDelegate, MKMapViewDelegate {
  
  
  
  @IBOutlet weak var mapview: MKMapView!
  @IBOutlet weak var cameraButton: UIButton!
  
  var image: UIImage!
  var annotations: [PhotoAnnotation] = []
 
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    cameraButton.imageView?.layer.cornerRadius = (cameraButton.imageView?.frame.size.width)! / 2
//    cameraButton.imageView?.clipsToBounds = true
    
    //one degree of latitude is approximately 111 kilometers (69 miles) at all times.
    let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667),
                                          MKCoordinateSpanMake(0.1, 0.1))
    mapview.setRegion(sfRegion, animated: false)
    mapview.delegate = self
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
    self.navigationController?.popViewController(animated: true)
    let locationCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
    let image = controller.userData as! UIImage
    
    let annotation = PhotoAnnotation()
    annotation.coordinate = locationCoordinate
    annotation.photo = image
    
    annotations.append(annotation)
    mapview.addAnnotation(annotation)
    
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    let reuseID = "myAnnotationView"
    
    var annotationView = mapview.dequeueReusableAnnotationView(withIdentifier: reuseID)
    if (annotationView == nil) {
      annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
      annotationView!.canShowCallout = true
      annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
      
      let detailsButton = UIButton(type: UIButtonType.detailDisclosure)
      annotationView?.rightCalloutAccessoryView = detailsButton
    }
    
    let resizeRenderImageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 45, height: 45)))
    resizeRenderImageView.layer.borderColor = UIColor.white.cgColor
    resizeRenderImageView.layer.borderWidth = 3.0
    resizeRenderImageView.contentMode = UIViewContentMode.scaleAspectFill
    resizeRenderImageView.image = (annotation as? PhotoAnnotation)?.photo
    
    UIGraphicsBeginImageContext(resizeRenderImageView.frame.size)
    resizeRenderImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
    let thumbnail = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
    imageView.image = thumbnail
    annotationView?.image = thumbnail
    
    return annotationView
  }
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    performSegue(withIdentifier: "fullImageSegue", sender: (view.annotation as? PhotoAnnotation)?.photo)
  }
  
  
  // Method to handle camera press
  @IBAction func didPressCamera(_ sender: Any) {
    createImagePicker()
  }
  
  func createImagePicker() {
    let isCameraAvailable = UIImagePickerController.isSourceTypeAvailable(.camera)
    
    // Limit to PhotoLibrary if no camera available
    let sourceType = isCameraAvailable ?
      UIImagePickerControllerSourceType.camera :
      UIImagePickerControllerSourceType.photoLibrary
    
    let vc = UIImagePickerController()
    vc.delegate = self
    vc.sourceType = sourceType
    
    self.present(vc, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
    // Get the image captured by the UIImagePickerController
    if (info[UIImagePickerControllerEditedImage] as? UIImage) != nil {
      image = info[UIImagePickerControllerEditedImage] as! UIImage
    } else {
      image = info[UIImagePickerControllerOriginalImage] as! UIImage
    }
    
    // Dismiss UIImagePickerController to go back to your original view controller
    dismiss(animated: true) {
      self.performSegue(withIdentifier: "tagSegue", sender: self.image)
    }
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    self.tabBarController?.selectedIndex = 0
    dismiss(animated: true, completion: nil)
  }
  
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let locations = segue.destination as? LocationsViewController {
      locations.delegate = self
      locations.userData = sender
    } else if let fullImageVC = segue.destination as? FullImageViewController {
      fullImageVC.image = sender as! UIImage
    }
    
    
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
  }
  
  
}
