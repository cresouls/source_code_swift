//
//  JDetailVC.swift
//  JoboyService
//
//  Created by Sreejith Ajithkumar on 25/07/19.
//  Copyright © 2019 Sreejith Ajithkumar. All rights reserved.
//

import UIKit
import MapKit

class JDetailVC: UIViewController, NibLoadable {

    @IBOutlet weak var jobsImageView: RoundedImageView! {
        didSet {
            jobsImageView.image = Images.dpPlaceholder
        }
    }
    
    @IBOutlet weak var reqIdLabel: UILabel! {
        didSet {
            reqIdLabel.textColor = Theme.c1
            reqIdLabel.font = Font.h6
        }
    }
    
    @IBOutlet weak var customerNameLabel: UILabel! {
        didSet {
            customerNameLabel.textColor = Theme.c1
            customerNameLabel.font = Font.h7
        }
    }
    
    @IBOutlet weak var serviceNameLabel: UILabel! {
        didSet {
            serviceNameLabel.textColor = Theme.c1
            serviceNameLabel.font = Font.h7
        }
    }
    
    @IBOutlet weak var reqTimeLabel: UILabel! {
        didSet {
            reqTimeLabel.textColor = Theme.c1
            reqTimeLabel.font = Font.h7
        }
    }
    
    @IBOutlet weak var paymentModeLabel: UILabel! {
        didSet {
            paymentModeLabel.textColor = Theme.c1
            paymentModeLabel.font = Font.h7
        }
    }
    
    @IBOutlet weak var issueLabel: UILabel! {
        didSet {
            issueLabel.textColor = Theme.c1
            issueLabel.font = Font.h8
        }
    }
    
    @IBOutlet weak var addressCaptionLabel: UILabel! {
        didSet {
            addressCaptionLabel.textColor = Theme.c1
            addressCaptionLabel.font = Font.h8
        }
    }
    
    @IBOutlet weak var addressLabel: UILabel! {
        didSet {
            addressLabel.textColor = Theme.c1
            addressLabel.font = Font.h7
        }
    }
    
    @IBOutlet weak var callCustomerButton: UIButton! {
        didSet {
            callCustomerButton.titleLabel?.textColor = Theme.c1
            callCustomerButton.titleLabel?.font = Font.h9
            callCustomerButton.imageView?.tintColor = Theme.c1
            
            callCustomerButton.isHidden = true
        }
    }
    
    @IBOutlet weak var statusLabel: UILabel! {
        didSet {
            statusLabel.textColor = Theme.c8
            statusLabel.font = Font.h6
            
            statusLabel.isHidden = true
        }
    }
    
    @IBOutlet weak var startButton: RoundedButton! {
        didSet {
            startButton.backgroundColor = Theme.c10
            startButton.titleLabel?.textColor = Theme.c2
            startButton.titleLabel?.font = Font.h12
            
            startButton.isHidden = true
        }
    }
    
    @IBOutlet weak var pauseButton: RoundedButton! {
        didSet {
            pauseButton.backgroundColor = Theme.c7
            pauseButton.titleLabel?.textColor = Theme.c2
            pauseButton.titleLabel?.font = Font.h12
            
            pauseButton.isHidden = true
        }
    }
    
    @IBOutlet weak var resumeButton: RoundedButton! {
        didSet {
            resumeButton.backgroundColor = Theme.c7
            resumeButton.titleLabel?.textColor = Theme.c2
            resumeButton.titleLabel?.font = Font.h12
            
            resumeButton.isHidden = true
        }
    }
    
    @IBOutlet weak var stopButton: RoundedButton! {
        didSet {
            stopButton.backgroundColor = Theme.c8
            stopButton.titleLabel?.textColor = Theme.c2
            stopButton.titleLabel?.font = Font.h12
            
            stopButton.isHidden = true
        }
    }
    
    @IBOutlet weak var uploadBeforeImageButton: RoundedButton! {
        didSet {
            uploadBeforeImageButton.backgroundColor = Theme.c7
            uploadBeforeImageButton.titleLabel?.textColor = Theme.c1
            uploadBeforeImageButton.titleLabel?.font = Font.h12
            
            uploadBeforeImageButton.isHidden = true
        }
    }
    
    @IBOutlet weak var uploadAfterImageButton: RoundedButton! {
        didSet {
            uploadAfterImageButton.backgroundColor = Theme.c7
            uploadAfterImageButton.titleLabel?.textColor = Theme.c1
            uploadAfterImageButton.titleLabel?.font = Font.h12
            
            uploadAfterImageButton.isHidden = true
        }
    }
    
    @IBOutlet weak var inspectionButton: RoundedButton! {
        didSet {
            inspectionButton.backgroundColor = Theme.c7
            inspectionButton.titleLabel?.textColor = Theme.c1
            inspectionButton.titleLabel?.font = Font.h12
            
            inspectionButton.isHidden = true
        }
    }
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    //MARK: - Properties
    var vm: JDetailVM?
    private lazy var hud = Hud(color: Theme.c7)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addMenuPopDismissButton()
        bindViewModel()
        
        vm?.callback = { [unowned self] (state) in
            switch state.action {
            case .none:
                print("none")
            case .onCall:
                self.hud.start()
            case .onSuccess(_):
                self.hud.stop()
            case .onFailed(let message):
                self.hud.stop()
                self.showAlert("Error", message: message)
            case .other(let message):
                self.hud.stop()
                self.showAutoDismissAlert(nil, message: message)
            }
        }
        
        vm?.getOrderDetails()
        
    }
    
    @IBAction func roundedButtonActions(_ sender: RoundedButton) {
        if sender == uploadBeforeImageButton {
            self.showImagePicker(isEditable: true)
        } else if sender == uploadAfterImageButton {
            self.showImagePicker(isEditable: true)
        } else if sender == startButton {
            vm?.startWork()
        } else if sender == pauseButton {
            vm?.pauseWork()
        } else if sender == resumeButton {
            vm?.resumeWork()
        } else if sender == stopButton {
            //vm?.stopWork()
            let popUp = EnterAmountPopUp(self)
            popUp.show(animated: true)
        } else if sender == inspectionButton {
            vm?.sendToInspect()
        }
    }
    
    @IBAction func buttonActions(_ sender: UIButton) {
        if sender == callCustomerButton {
            if let _vm = vm, let phoneNumber = URL(string: "tel://\(_vm.customerCallNo)") {
                UIApplication.shared.open(phoneNumber)
            }
        }
    }
    
}

//MARK: - Functions
extension JDetailVC {
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 5000
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

//MARK: - Bind
extension JDetailVC {
    func bindViewModel() {
        vm?.status.bind = { [unowned self] in
            switch $0 {
            case .opened:
                self.callCustomerButton.isHidden = false
                self.statusLabel.isHidden = true
                self.startButton.isHidden = false
                self.pauseButton.isHidden = true
                self.resumeButton.isHidden = true
                self.stopButton.isHidden = true
                
                if self.vm!.isBeforeImageUploaded.value! {
                    self.uploadBeforeImageButton.isHidden = true
                } else {
                    self.uploadBeforeImageButton.isHidden = false
                }
                self.uploadAfterImageButton.isHidden = true
                self.inspectionButton.isHidden = false
            case .started:
                self.callCustomerButton.isHidden = false
                self.statusLabel.isHidden = true
                self.startButton.isHidden = true
                self.pauseButton.isHidden = false
                self.resumeButton.isHidden = true
                self.stopButton.isHidden = false
                
                if self.vm!.isBeforeImageUploaded.value! {
                    self.uploadBeforeImageButton.isHidden = true
                } else {
                    self.uploadBeforeImageButton.isHidden = false
                }
                self.uploadAfterImageButton.isHidden = true
                self.inspectionButton.isHidden = true
            case .paused:
                self.callCustomerButton.isHidden = false
                self.statusLabel.isHidden = true
                self.startButton.isHidden = true
                self.pauseButton.isHidden = true
                self.resumeButton.isHidden = false
                self.stopButton.isHidden = true
                
                if self.vm!.isBeforeImageUploaded.value! {
                    self.uploadBeforeImageButton.isHidden = true
                } else {
                    self.uploadBeforeImageButton.isHidden = false
                }
                self.uploadAfterImageButton.isHidden = true
                self.inspectionButton.isHidden = true
            case .stopped:
                self.callCustomerButton.isHidden = false
                self.statusLabel.isHidden = false
                self.startButton.isHidden = true
                self.pauseButton.isHidden = true
                self.resumeButton.isHidden = true
                self.stopButton.isHidden = true
                
                self.uploadBeforeImageButton.isHidden = true
                if self.vm!.isAfterImageUploaded.value! {
                    self.uploadAfterImageButton.isHidden = true
                } else {
                    self.uploadAfterImageButton.isHidden = false
                }
                self.inspectionButton.isHidden = true
            case .completed:
                self.callCustomerButton.isHidden = true
                self.statusLabel.isHidden = true
                self.startButton.isHidden = true
                self.pauseButton.isHidden = true
                self.resumeButton.isHidden = true
                self.stopButton.isHidden = true
                
                self.uploadBeforeImageButton.isHidden = true
                self.uploadAfterImageButton.isHidden = true
                self.inspectionButton.isHidden = true
            case .na:
                print("Should not execute")
            }
        }
        
        vm?.isBeforeImageUploaded.bind = { [unowned self] in
            self.uploadBeforeImageButton.isHidden = $0
        }
        
        vm?.isAfterImageUploaded.bind = { [unowned self] in
            self.uploadAfterImageButton.isHidden = $0
        }
        
        //set value to viewcontroller on load
        self.navigationItem.title = vm?.reqId
        
        self.reqIdLabel.text = vm?.reqId
        self.customerNameLabel.text = vm?.customerName
        self.serviceNameLabel.text = vm?.serviceName
        self.reqTimeLabel.text = vm?.reqTime
        self.paymentModeLabel.text = vm?.paymentMode
        self.addressLabel.text = vm?.address
        self.issueLabel.text = vm?.issue
        if let _vm = vm, let _latitude = vm?.latitude, let _longitude = vm?.longitude {
            DispatchQueue.main.async {
                self.centerMapOnLocation(location: CLLocation(latitude: _latitude, longitude: _longitude))
                let serviceLocation = ServiceLocation(title: "Service Point", subtitle: _vm.address, coordinate: CLLocationCoordinate2D(latitude: _latitude, longitude: _longitude))
                self.mapView.addAnnotation(serviceLocation)
            }
        }
    }
}

extension JDetailVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? ServiceLocation else { return nil }
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
}

//MARK: - KeyboardObserver
extension JDetailVC: ImagePickerPresentable {
    func selectedImage(image: UIImage?) {
        guard let _image = image else { return }
        vm?.uploadImage(_image)
    }
}

//MARK: - EnterAmountPopUpDelegate
extension JDetailVC: EnterAmountPopUpDelegate {
    func didEnterAmount(_ enterAmountPopUp: EnterAmountPopUp, amount: String) {
        vm?.stopWork(amount)
    }
}

//MARK: - DefaultAlert
extension JDetailVC: DefaultAlert { }

//MARK: - AutoDismissAlert
extension JDetailVC: AutoDismissAlert { }

class ServiceLocation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}
