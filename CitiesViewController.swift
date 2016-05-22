//
//  ViewController.swift
//  testTask3
//
//  Created by Краснов Андрей on 21.05.16.
//  Copyright © 2016 Краснов Андрей. All rights reserved.
//

import UIKit
import Alamofire

class CitiesViewController: UICollectionViewController {
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    @IBOutlet var citiesCollection: UICollectionView!
    
    let reuseID = "CityCell"
    let SegueMapViewController = "MapViewController"
    var collectionData = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        mainController = self
        citiesCollection.delaysContentTouches = false
        title = "Список городов"
        self.getInfoFromAPI()
    }
    
    override func viewWillAppear(animated: Bool) {
        citiesCollection.collectionViewLayout.invalidateLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        citiesCollection.collectionViewLayout.invalidateLayout()
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.reuseID, forIndexPath: indexPath) as! CityCell
        cell.backgroundColor = UIColor.whiteColor()
        cell.cityCellLabel.text = collectionData[indexPath.item]["city_name"] as? String
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 70)
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(SegueMapViewController, sender: self)
    }
    
    override func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        UIView.animateWithDuration(0.15, animations: {
            UIView.animateWithDuration(0.15, animations: {
                collectionView.cellForItemAtIndexPath(indexPath)?.backgroundColor = UIColor.lightGrayColor()
            })
        })
    }
    
    override func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        UIView.animateWithDuration(0.15, animations: {
            collectionView.cellForItemAtIndexPath(indexPath)?.backgroundColor = UIColor.whiteColor()
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueMapViewController {
            if let indexPath : NSIndexPath? = citiesCollection.indexPathsForSelectedItems()![0] {
                let destinationViewController = segue.destinationViewController as! MapViewController
                destinationViewController.cityName = collectionData[indexPath!.item]["city_name"] as! String
                destinationViewController.latitude = collectionData[indexPath!.item]["city_latitude"] as! Double
                destinationViewController.longitude = collectionData[indexPath!.item]["city_longitude"] as! Double
                destinationViewController.spnLatitude = collectionData[indexPath!.item]["city_spn_latitude"] as! Double
                destinationViewController.spnLongitude = collectionData[indexPath!.item]["city_spn_longitude"] as! Double
            }
        }
    }
    
    
    
    func getInfoFromAPI() {
        loading.startAnimating()
        dispatch_async(dispatch_get_main_queue(), {
            [unowned self] in
            Alamofire.request(
                .GET,
                "http://beta.taxistock.ru/taxik/api/client/query_cities",
                parameters: nil,
                encoding: .URL)
                .validate()
                .responseJSON { (response) -> Void in
                    guard response.result.isSuccess else {
                        print("Ошибка при запросе данных: \(response.result.error)")
                        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
                        dispatch_after(delay, dispatch_get_main_queue()) {
                            self.getInfoFromAPI()
                        }
                        return
                    }
                    
                    guard let value = response.result.value as? [String: AnyObject],
                        rows = value["cities"] as? NSArray else {
                            print("Ошибка при получении данных")
                            return
                    }
                    self.addData(rows)
                    self.loading.stopAnimating()
            }
        })
    }
    
    func addData(data: NSArray) {
        for eachObject in data {
            self.collectionData.addObject(eachObject)
        }
        self.citiesCollection.reloadData()
    }

}


