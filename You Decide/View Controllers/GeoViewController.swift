//
//  GeoViewController.swift
//  You Decide
//
//  Created by Abdullah Bandan on 24/03/1441 AH.
//  Copyright © 1441 AbdullahBandan. All rights reserved.
//

import UIKit
import CoreData

class GeoViewController: UIViewController {

    @IBOutlet var continentLabel: UILabel!
        @IBOutlet var countryLabel: UILabel!
        @IBOutlet var countryCodeLabel: UILabel!
        @IBOutlet var addressLabel: UILabel!
        @IBOutlet var timezoneNameLabel: UILabel!
        @IBOutlet var timezoneCodeLabel: UILabel!
        @IBOutlet var currencyNameLabel: UILabel!
        @IBOutlet var currencyCodeLabel: UILabel!
        @IBOutlet var callingcodeLabel: UILabel!

    var pin: Pin! {
        if let tabController = tabBarController as? TabBatViewController {
            return tabController.pin
        }
        return nil
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupFetchedResultsController()
        getGeoData()
    }
    
    var fetchedResultsController:NSFetchedResultsController<Geo>!
    
        func getGeoData() {
            if  pin.geos == nil{
                let lat = String(pin.coordinate.latitude.magnitude)
                let lon = String(pin.coordinate.longitude.magnitude)
                LoadingActivityIndicator(true, view: view, collectionView: nil, tag: 2)

                OpenCageClient.getGeoData(lat: lat, lon: lon, completion: handleGetGeoDataResponse)
            } else{
                setGeoData()
            }
            
        }
    func handleGetGeoDataResponse(data: OpenCageRespones?,error: Error? ) {
            
        if error != nil{
            LoadingActivityIndicator(false, view: view, collectionView: nil, tag: 2)
            _ = showFailure(title: "Error", message: error!.localizedDescription, withOption: false)
                }
                guard let data = data else {
                LoadingActivityIndicator(false, view: view, collectionView: nil, tag: 2)
                    return }
        prepareGeoData(data: data)

    }
    
    func prepareGeoData(data: OpenCageRespones){
        let geo = Geo(context: DataController.shared.viewContext)
        geo.continent = data.results?.first?.components?.continent ?? "No data"
        geo.country = data.results?.first?.components?.country ?? "No data"
        geo.contryCode = data.results?.first?.components?.countryCode ?? "No data"
        geo.address = data.results?.first?.formatted ?? "No data"
        geo.timeZoneName = data.results?.first?.annotations?.timezone?.name ?? "No data"
        geo.timeZoneCode = data.results?.first?.annotations?.timezone?.short_name ?? "No data"
        geo.currencyName = data.results?.first?.annotations?.currency?.name ?? "No data"
        geo.currencyCode = data.results?.first?.annotations?.currency?.iso_code ?? "No data"
        geo.callingCode = String(data.results?.first?.annotations?.callingcode ?? 0) 
        geo.pin = pin
        try? DataController.shared.viewContext.save()
    }
    func setGeoData()  {
        let geo = fetchedResultsController.fetchedObjects?.first
        continentLabel.text = geo?.continent
        countryLabel.text = geo?.country
        countryCodeLabel.text = geo?.contryCode
        addressLabel.text = geo?.address
        timezoneNameLabel.text = geo?.timeZoneName
        timezoneCodeLabel.text = geo?.timeZoneCode
        currencyNameLabel.text = geo?.currencyName
        currencyCodeLabel.text = geo?.currencyCode
        callingcodeLabel.text = geo?.callingCode
        LoadingActivityIndicator(false, view: view, collectionView: nil, tag: 2)
    }

}

// MARK: - NSFetchedResultsControllerDelegate
extension GeoViewController:NSFetchedResultsControllerDelegate {
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Geo> = Geo.fetchRequest()
        let predicate = NSPredicate(format: "pin == %@", pin)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "country", ascending: true)
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

        switch type {
        case .insert:
            setGeoData()
         default:
            break
        }
    }
    
    
}
