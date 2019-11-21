//
//  TravelLocationsMapVC.swift
//  You Decide
//
//  Created by Abdullah Bandan on 01/03/1441 AH.
//  Copyright © 1441 AbdullahBandan. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class TravelLocationsMapVC: UIViewController {
    @IBOutlet var mapvView: MKMapView!
    var fetchedResultsController:NSFetchedResultsController<Pin>!
    var deletePinsFlag = false
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Pin> = Pin.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "lat", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: "Pin")
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mapvView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        setupFetchedResultsController()
        zomeAndRegaion(mapView: mapvView, lastRegion: true)
        prepare()
     }
    
    @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .ended {
            return
        }
        if sender.state == .began
          {
                let touchPoint = sender.location(in: mapvView)
                let touchCoordinate = mapvView.convert(touchPoint, toCoordinateFrom: mapvView)
            let annotation = Pin(context: DataController.shared.viewContext)
            annotation.lat = touchCoordinate.latitude.magnitude
            annotation.lon = touchCoordinate.longitude.magnitude

                try? DataController.shared.viewContext.save()
                mapvView.addAnnotation(annotation)
        }
    }
    
    @IBAction func deletePin(_ sender: Any) {
        if deletePinsFlag{
            deleteButtonTapped()
        }else{
        let alertVC = self.showFailure(title: "Delete Pins", message: "Tab Pins to Delete", withOption: true)
        alertVC.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.destructive, handler: { action in
            self.deleteButtonTapped()
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
               self.present(alertVC, animated: true, completion: nil)
    }
    }
    func deleteButtonTapped(){
        if deletePinsFlag {
            deletePinsFlag = false
            let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deletePin)) //Use a selector
            deleteButton.tintColor = UIColor.systemBlue
            navigationItem.rightBarButtonItem = deleteButton
        }else{
            deletePinsFlag = true
            let deleteButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(deletePin)) //Use a selector
            deleteButton.tintColor = UIColor.systemRed
            navigationItem.rightBarButtonItem = deleteButton
        }
    }
}

// MARK: - MKMapViewDelegate
extension TravelLocationsMapVC: MKMapViewDelegate{
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PinTapped"{
            let PhotoAlbumVC = segue.destination as! TabBatViewController
            PhotoAlbumVC.pin = (sender as! Pin)
        }
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let pin = view.annotation as? Pin else {
            return
        }
        if(deletePinsFlag){
            DataController.shared.viewContext.delete(pin)
            try? DataController.shared.viewContext.save()
        }else{
            
        performSegue(withIdentifier: "PinTapped", sender: pin)
        }
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        zomeAndRegaion(mapView: mapvView, lastRegion: false)
    }
    
    func prepare(){
        let  locations = fetchedResultsController.fetchedObjects!
        self.mapvView.addAnnotations(locations)
    }
    
    func zomeAndRegaion(mapView: MKMapView,lastRegion: Bool) {
        if(lastRegion){
            let centerLat = UserDefaults.standard.double(forKey: "centerLat")
            let centerLon = UserDefaults.standard.double(forKey: "centerLon")
            let spanLat = UserDefaults.standard.double(forKey: "spanLat")
            let spanLon = UserDefaults.standard.double(forKey: "spanLon")
            let center = CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon)
            let span = MKCoordinateSpan(latitudeDelta: spanLat, longitudeDelta: spanLon)
            let region = MKCoordinateRegion(center: center, span: span)
            self.mapvView.setRegion(region, animated: true)


        }else{
        UserDefaults.standard.set(mapView.centerCoordinate.latitude.magnitude, forKey: "centerLat")
        UserDefaults.standard.set(mapView.centerCoordinate.longitude.magnitude, forKey: "centerLon")
        UserDefaults.standard.set(mapView.region.span.latitudeDelta.magnitude, forKey: "spanLat")
        UserDefaults.standard.set(mapView.region.span.longitudeDelta.magnitude, forKey: "spanLon")
        }
    }
}

extension TravelLocationsMapVC:NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard let pin = anObject as? Pin else {
            return
        }
        switch type {
        case .insert:
            mapvView.addAnnotation(pin)
            break
        case .delete:
            mapvView.removeAnnotation(pin)
            break
        default:
            break
        }
    }
}
