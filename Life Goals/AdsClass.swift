//
//  adsClass.swift
//  Life Goals
//
//  Created by Hieu Vo on 3/20/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import Firebase

class AdsClass : NSObject, GADBannerViewDelegate, GADInterstitialDelegate {
    var adUnitID : String
    
    init(_ adUnitID : String){
        self.adUnitID = adUnitID
    }
    
    func getBannerView(_ maxY : CGFloat, rootViewController : UIViewController) -> GADBannerView {
        let bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView.delegate = self
        bannerView.adUnitID = adUnitID
        bannerView.rootViewController = rootViewController
        bannerView.clipsToBounds = true
        let request = GADRequest()
       // request.testDevices = [ kGADSimulatorID, "6b51d512acddcf480db24ff78d558102", "cb1c8343476bbbee38f702399185600f" ]; // Simulator
        bannerView.load(request)
        bannerView.frame = CGRect(x: 0, y: maxY, width: bannerView.frame.width, height: bannerView.frame.height)
        return bannerView
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        bannerView.isHidden = true
        print("loi banner : \(error.localizedDescription)")
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.isHidden = false
        print("adds received")
    }
    
    func loadInterstitial() -> GADInterstitial {
        
        let interstitial = GADInterstitial(adUnitID: adUnitID)
        interstitial.delegate = self
        let request = GADRequest()
        // Request test ads on devices you specify. Your test device ID is printed to the console when
        // an ad request is made.
       // request.testDevices = [ kGADSimulatorID, "6b51d512acddcf480db24ff78d558102", "cb1c8343476bbbee38f702399185600f"]
        interstitial.load(request)
        return interstitial
        
    }
    // MARK: - GADInterstitialDelegate
    
    func interstitialDidFailToReceiveAdWithError(_ interstitial: GADInterstitial,
                                                 error: GADRequestError) {
        print("\(#function): \(error.localizedDescription)")
    }
    
    func interstitialDidDismissScreen(_ interstitial: GADInterstitial) {
        _ = UINavigationController().popViewController(animated: true)
        print("bi loi")
    }


}
