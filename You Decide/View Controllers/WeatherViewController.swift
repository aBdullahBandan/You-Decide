//
//  WeatherViewController.swift
//  You Decide
//
//  Created by Abdullah Bandan on 20/03/1441 AH.
//  Copyright © 1441 AbdullahBandan. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import SwiftSky

// MARK: - WeatherViewController
class WeatherViewController: UIViewController {
    
    @IBOutlet var time: UILabel!
    @IBOutlet var temperature: UILabel!
    @IBOutlet var todatySumary: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var weather: UILabel!
    @IBOutlet var weatherIcon: UIImageView!
    var pin: Pin! {
        if let tabController = tabBarController as? TabBatViewController {
            return tabController.pin
        }
        return nil
    }
    var fetchedResultsController:NSFetchedResultsController<Weather>!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupFetchedResultsController()
        getWeather()
    }
    

    
    func getWeather() {
        if pin.weathers?.count == 0  {
            LoadingActivityIndicator(true, view: view, collectionView: nil, tag: 5)
        WeatherClient.getWhether(lat: pin.coordinate.latitude.magnitude, lon: pin.coordinate.longitude.magnitude, completion: handleGetWeatherResponse)
        }else{
            checkToday()
        }
    }
    
    func handleGetWeatherResponse(responess: Forecast?,  error: Error?) {
        
        if error != nil{
                LoadingActivityIndicator(false, view: view, collectionView: nil, tag: 5)
            _ = showFailure(title: "Error", message: error!.localizedDescription, withOption: false)
        } else {
        saveWeather(forecast: responess!, pin: pin)
        }
    }
    
    @IBAction func reloadWeather(_ sender: Any) {
        deleteAll()
        getWeather()
    }
    func setToday( weather: Weather?, day: DataPoint?){
        if(weather != nil){
            self.temperature.text = weather!.temp! + " C"
            self.time.text = weather?.time
            self.todatySumary.text = weather?.weatherSumary
            let image = weather?.weatherIcon
            self.weather.text = image
            self.weatherIcon.image = UIImage(named: image!)!
        }else if(day != nil){
            self.temperature.text = (day?.temperature?.max?.value.toString())! + " C"
            self.time.text = day?.time.toString()
            self.todatySumary.text = day?.summary
            let image = day?.icon
            self.weather.text = image
            self.weatherIcon.image = UIImage(named: image!)!
        }
        }
    
    func saveWeather(forecast: Forecast, pin: Pin){
        for day in forecast.days?.points ?? []{
        if day.time.toString() == Date().toString()  {
            setToday( weather: nil, day: day)
            LoadingActivityIndicator(false, view: view, collectionView: nil, tag: 5)

        }
        let weather = Weather(context: DataController.shared.viewContext)
        weather.time = day.time.toString()
        weather.temp = day.temperature?.max?.value.toString()
        weather.weatherSumary = day.summary
        weather.weatherIcon = day.icon
        weather.pin = pin
        try? DataController.shared.viewContext.save()
        }
    }
    func checkToday(){
        for day in fetchedResultsController.fetchedObjects!{
            if day.time == Date().toString()  {
                if( day.today){
                    setToday(weather: day, day: nil)
                } else {
                    deleteAll()
                    LoadingActivityIndicator(true, view: view, collectionView: nil, tag: 5)
                    WeatherClient.getWhether(lat: pin.coordinate.latitude.magnitude, lon: pin.coordinate.longitude.magnitude, completion: handleGetWeatherResponse)
                }
            }
        }
    }
    
    func deleteAll() {
            if let weatherToDelete = fetchedResultsController.fetchedObjects{
                for weather in weatherToDelete {
                    DataController.shared.viewContext.delete(weather)
                }
                try? DataController.shared.viewContext.save()
            }
    }
    
    func convertDateFormaterToWeekDay( date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let weekDay = dateFormatter.string(from: date.toDate()!)
        return weekDay

    }
    
    
}

// MARK: - UITableViewDataSource,UITableViewDelegate
extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Next Week"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell")!
        let weather = fetchedResultsController.object(at: indexPath)
        cell.textLabel!.text = convertDateFormaterToWeekDay(date: weather.time!) + " : " + weather.time!
        cell.detailTextLabel?.text = weather.temp! + " C, " + weather.weatherSumary!
        cell.imageView?.image = UIImage(named: weather.weatherIcon!)!
        return cell
    }
    
}

// MARK: - NSFetchedResultsControllerDelegate
extension WeatherViewController:NSFetchedResultsControllerDelegate {
    
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Weather> = Weather.fetchRequest()
        let predicate = NSPredicate(format: "pin == %@", pin)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "time", ascending: true)
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
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
         default:
            break
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}
