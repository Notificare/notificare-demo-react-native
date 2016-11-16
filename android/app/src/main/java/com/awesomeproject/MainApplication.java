package com.awesomeproject;

import android.app.Application;
import android.util.Log;

import com.facebook.react.ReactApplication;
import com.facebook.react.ReactInstanceManager;
import com.facebook.react.ReactNativeHost;
import com.facebook.react.ReactPackage;
import com.facebook.react.shell.MainReactPackage;

import re.notifica.Notificare;

import java.util.Arrays;
import java.util.List;

import re.notifica.reactnative.*;


public class MainApplication extends Application implements ReactApplication {

    @Override
    public void onCreate() {
        super.onCreate();
        Notificare.shared().launch(this);
        Notificare.shared().setIntentReceiver(NotificareReceiver.class);
        Notificare.shared().setAllowJavaScript(true);
    }

    private final ReactNativeHost mReactNativeHost = new ReactNativeHost(this) {

        @Override
        protected boolean getUseDeveloperSupport() {
            return BuildConfig.DEBUG;
        }


        protected List<ReactPackage> getPackages() {
            return Arrays.<ReactPackage>asList(
                new MainReactPackage(),
                new NotificarePackage());
        }
    };

    @Override
    public ReactNativeHost getReactNativeHost() {
        return mReactNativeHost;
    }

}
