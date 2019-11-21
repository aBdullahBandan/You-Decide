//
//  PhotoAlbumVC.swift
//  You Decide
//
//  Created by Abdullah Bandan on 01/03/1441 AH.
//  Copyright © 1441 AbdullahBandan. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData
import SwiftSky

// MARK: - UIViewController
class PhotoAlbumVC: UIViewController {

    @IBOutlet var mapvView: MKMapView!
    @IBOutlet var collectionView: UICollectionView!
        var pin: Pin! {
        if let tabController = tabBarController as? TabBatViewController {
            return tabController.pin
        }
        return nil
    }
    var fetchedResultsController:NSFetchedResultsController<Photo>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        setupFetchedResultsController()
        prepare()
     }
    
    
    @IBAction func reloadPhotos(_ sender: Any) {
        deleteSelectedOrAll(indexPath: nil, flag: "All")
        var page: Int {
            return Int(arc4random_uniform(UInt32(20)) + 1)
               }
        getPhotos(page: String(page))
    }
    
    func deleteSelectedOrAll(indexPath: IndexPath?, flag:String) {
        if(flag == "All"){
            if let photoToDelete = fetchedResultsController.fetchedObjects{
                for photo in photoToDelete {
                    DataController.shared.viewContext.delete(photo)
                }
                try? DataController.shared.viewContext.save()
            }
        }else{
            let photoToDelete = fetchedResultsController.object(at: indexPath!)
            DataController.shared.viewContext.delete(photoToDelete)
            try? DataController.shared.viewContext.save()
    }
    }
}


// MARK: - UICollectionViewDataSource
extension PhotoAlbumVC: UICollectionViewDataSource {
    
    func getPhotos(page:String) {
        if  pin.photos?.count == 0{
            LoadingActivityIndicator(true, view: collectionView, collectionView: collectionView, tag: 9)
            let lat = String(pin.coordinate.latitude.magnitude)
            let lon = String(pin.coordinate.longitude.magnitude)
            FlickrClient.getPhotos(lat: lat, lon: lon, page: page, completion: handleGetPhotosResponse)
        }
        
    }
    func handleGetPhotosResponse(success: Bool,data: [PhotoLocal]?,  error: Error?) {
        
        if error != nil{
                LoadingActivityIndicator(false, view: collectionView!.superview!, collectionView: collectionView, tag: 9)
            _ = showFailure(title: "Error", message: error!.localizedDescription, withOption: false)
        }
               if success {
                guard (data!.count) != 0  else {
                    collectionView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "noimge"))
                    return
                }
                for photoData in data!{
                    let photo = Photo(context: DataController.shared.viewContext)
                    photo.photosUrl  = photoData.url
                    photo.pin = pin
                    try? DataController.shared.viewContext.save()
                }
                LoadingActivityIndicator(false, view: collectionView!.superview!, collectionView: collectionView, tag: 9)
               } else {
                LoadingActivityIndicator(false, view: collectionView!.superview!, collectionView: collectionView, tag: 9)
               }
           }
}


// MARK: - UICollectionViewDelegate
extension PhotoAlbumVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        if cell!.isSelected == true {
            deleteSelectedOrAll(indexPath: indexPath, flag: "")
        }
    }
    

     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = fetchedResultsController.sections?[section].numberOfObjects {
            if count == 0 {
            } else {
                collectionView.backgroundView = nil
            }
        }
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
        
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoAlbumCell", for: indexPath) as! PhotoAlbumCell
            let photo = fetchedResultsController.object(at: indexPath)
            cell.imageView.image =  UIImage(contentsOfFile: photo.photosUrl!)
            cell.imageView.contentMode = UIView.ContentMode.scaleAspectFit
            LoadingActivityIndicator(true, view: cell.imageView,collectionView: nil, tag: 10)
            cell.imageView.downloaded(from: photo.photosUrl!) { (image) in
                self.LoadingActivityIndicator(false, view: cell.imageView,collectionView: nil, tag: 10)
                photo.photos  = image.pngData()
                try? DataController.shared.viewContext.save()
            }
            return cell
    }
}




// MARK: - MKMapViewDelegate
extension PhotoAlbumVC: MKMapViewDelegate{
    func prepare(){
        let center = CLLocationCoordinate2D(latitude: pin.coordinate.latitude, longitude: pin.coordinate.longitude)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                self.mapvView.addAnnotation(pin)
                self.mapvView.setRegion(region, animated: true)
        getPhotos(page: String(1))
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }

}

// MARK: - NSFetchedResultsControllerDelegate
extension PhotoAlbumVC:NSFetchedResultsControllerDelegate {
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "pin == %@", pin)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "photosUrl", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard anObject is Photo else {
            return
        }
        switch type {
        case .insert:
            collectionView.reloadData()
            break
        case .delete:
            collectionView.reloadData()
            break
        default:
            break
        }
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension PhotoAlbumVC: UICollectionViewDelegateFlowLayout {
    
    private var itemsPerRow: CGFloat { return 3 }

    private var sectionInsets: UIEdgeInsets{ return UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0) }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
    return CGSize(width: widthPerItem, height: widthPerItem)
  }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
   
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
      return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
  }
    
}
