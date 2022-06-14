//
//  FLNativeViewFactory.swift
//  Runner
//
//  Created by Rustam Bakytov on 14/6/22.
//

import Foundation
import Flutter
import UIKit
import PayBoxSdk

class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    private var channel: FlutterMethodChannel

    
    init(messenger: FlutterBinaryMessenger, channel : FlutterMethodChannel) {
        self.messenger = messenger
        self.channel = channel
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FLNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger,
            channel: channel)
    }
}

class FLNativeView: NSObject, FlutterPlatformView {
    private var _view: UIView
    private var channel : FlutterMethodChannel
    
    lazy var paymentView : PaymentView! = {
        let screenSize: CGRect = UIScreen.main.bounds
        paymentView = PaymentView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        paymentView.autoresizesSubviews = true
        paymentView.translatesAutoresizingMaskIntoConstraints = false
        
        return paymentView
    }()
    
    lazy var sdk : PayboxSdkProtocol = {
        let sdk = PayboxSdk.initialize(merchantId: 544319, secretKey: "F9IEaYAFo6JhJS9M")
    
        sdk.setPaymentView(paymentView: paymentView)
        sdk.config().setPaymentSystem(paymentSystem: PaymentSystem.NONE)
        sdk.config().testMode(enabled: true)
        sdk.config().setCurrencyCode(code: "KZT")
        sdk.config().recurringMode(enabled: false)
        sdk.config().setLanguage(language: Language.ru)
        sdk.config().setFrameRequired(isRequired: true)
        return sdk
    }()
        
   
    
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?,
        channel: FlutterMethodChannel
    ) {
        _view = UIView()
        self.channel = channel
        super.init()
        // iOS views can be created here
        createNativeView(view: _view)
    }

    func view() -> UIView {
        return _view
    }

    func createNativeView(view _view: UIView){
        _view.backgroundColor = UIColor.blue
        
        paymentView.isHidden = false
        
        self.channel.setMethodCallHandler({
            (call : FlutterMethodCall, result : @escaping FlutterResult) -> Void in
            guard call.method == "setUrl" else {
                result(FlutterMethodNotImplemented)
                return
            }
            self.sdk.createPayment(amount: 200, description: "Test", orderId: nil, userId: "9951000000", extraParams: nil) {
                payment, error in {}()
            }
        })
        
        
        _view.addSubview(paymentView)
    }
}
