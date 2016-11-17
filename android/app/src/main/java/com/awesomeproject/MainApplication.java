package com.awesomeproject;

import android.app.Application;

import com.facebook.react.ReactApplication;
import com.facebook.react.ReactNativeHost;
import com.facebook.react.ReactPackage;
import com.facebook.react.shell.MainReactPackage;

import java.util.Arrays;
import java.util.List;

import re.notifica.Notificare;
import re.notifica.reactnative.NotificarePackage;
import re.notifica.reactnative.NotificareReceiver;


public class MainApplication extends Application implements ReactApplication {

    @Override
    public void onCreate() {
        super.onCreate();
        Notificare.shared().setDebugLogging(BuildConfig.DEBUG);
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
