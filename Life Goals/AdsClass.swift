//
//  adsClass.swift
//  Life Goals
//
//  Created by Hieu Vo on 3/20/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import Firebase

class AdsClass : NSObject, GADBannerViewDelegate {
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
        request.testDevices = [ kGADSimulatorID, "6b51d512acddcf480db24ff78d558102", "cb1c8343476bbbee38f702399185600f" ]; // Simulator
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

}
