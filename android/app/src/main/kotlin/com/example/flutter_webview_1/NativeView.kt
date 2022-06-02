package com.example.flutter_webview_1

import android.content.Context
import android.graphics.Color
import android.view.View
import android.widget.TextView
import money.paybox.payboxsdk.view.PaymentView
import money.paybox.payboxsdk.PayboxSdk
import money.paybox.payboxsdk.config.Language
import money.paybox.payboxsdk.config.PaymentSystem
import io.flutter.plugin.platform.PlatformView
import android.widget.LinearLayout
import money.paybox.payboxsdk.interfaces.WebListener
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import android.util.Log


internal class NativeView(context: Context, id: Int, creationParams: Map<String?, Any?>?, binaryMessenger : BinaryMessenger) : PlatformView {
    
    private var paymentView: PaymentView
    private val sdk by lazy {
        PayboxSdk.initialize(544319, "F9IEaYAFo6JhJS9M")
    }

    override fun getView(): View {
        return paymentView
    }

    override fun dispose() {}

    init {
         paymentView = PaymentView(context)

      
        sdk.setPaymentView(paymentView)
        sdk.config().setPaymentSystem(PaymentSystem.NONE)
        sdk.config().testMode(true)
        sdk.config().setCurrencyCode("KZT")
        sdk.config().recurringMode(false)
        sdk.config().setLanguage(Language.ru)
        sdk.config().setFrameRequired(true)

        paymentView.visibility = View.VISIBLE




        paymentView.listener = object : WebListener {
                        override fun onLoadFinished() {
                            
                        }

                        override fun onLoadStarted() {
                            
                        }
                    }

         MethodChannel(binaryMessenger, "samples.flutter.dev/battery").setMethodCallHandler { call, result ->
      if (call.method == "setUrl") {
        sdk.createPayment(100f, "description", "12345", "123454", null) {
                    payment, error -> Log.e("initPAY", error?.description ?: "")
                
            }
         
      } else {
        result.notImplemented()
      }
    }
    }
}