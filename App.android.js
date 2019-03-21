/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
    AppRegistry,
    FlatList,
    StyleSheet,
    Text,
    Linking,
    NativeModules,
    DeviceEventEmitter,
    TouchableHighlight,
    View,
    PermissionsAndroid
} from 'react-native';


const Notificare = NativeModules.NotificareReactNativeAndroid;

export default class App extends Component {

    constructor(props){
        super(props);
        this.state = {
            dataSource: []
        };
        this._reloadInbox();
    }

    componentWillMount() {

        console.log("componentWillMount");

        Notificare.mount();

        Linking.getInitialURL().then((url) => {
            if (url) {
                console.log('Initial url is: ' + url);
            }
        }).catch(err => console.error('An error occurred', err));

        Linking.addEventListener('url', this._handleOpenURL);

        DeviceEventEmitter.addListener('ready', (data) => {
            console.log(data);
            Notificare.enableNotifications();
        });

        DeviceEventEmitter.addListener('didClickURL', (data) => {
            console.log(data);
        });

        DeviceEventEmitter.addListener('didReceiveDeviceToken',(data) => {
            console.log(data);

            Notificare.registerDevice(data.device, null, null, (error, data) => {
                if (!error) {
                    Notificare.fetchTags((error, data) => {
                        if (!error) {
                            console.log(data);
                            Notificare.addTags(["react-native"], (error, data) => {
                                if (!error) {
                                    console.log(data);
                                }
                            });
                        }
                    });
                    (async function() {
                        try {
                            let granted = await PermissionsAndroid.request(PermissionsAndroid.PERMISSIONS.ACCESS_FINE_LOCATION, {
                                'title': 'Location Permission',
                                'message': 'We need your location so we can send you relevant push notifications'
                            });
                            if (granted) {
                                Notificare.enableLocationUpdates()
                            }
                        } catch (err) {
                            console.warn(err)
                        }
                    }());
                }
            });
        });

        DeviceEventEmitter.addListener('notificationOpened',(data) => {
            console.log(data);
            Notificare.openNotification(data.notification);
        });

        DeviceEventEmitter.addListener('notificationReceived',(data) => {
            console.log(data);
            this._reloadInbox();
        });

    }

    componentWillUnmount() {
        console.log('componentWillUnmount');
        Notificare.unmount();
        Linking.removeEventListener('url', this._handleOpenURL);
        DeviceEventEmitter.removeAllListeners();
    }

    _handleOpenURL(event) {
        console.log("Deeplink URL: " + event.url);
    }

    _reloadInbox() {
        Notificare.fetchInbox(null, 0, 100, (error, data) => {
            if (!error) {
                console.log(data);
                this.setState({
                    dataSource : data.inbox
                });
            }
        });
    }

    render() {
        return (
            <View style={styles.view}>
                <FlatList
                    data={this.state.dataSource}
                    renderItem={this.renderRow}
                    keyExtractor={(item, index) => index.toString()}
                />
            </View>
        );
    }

    renderRow ({item}) {
        return (
            <TouchableHighlight>
                <View>
                    <View style={styles.row}>
                        <Text style={styles.text}>
                            {item.message}
                        </Text>
                        <Text style={styles.text}>
                            {item.time}
                        </Text>
                    </View>
                </View>
            </TouchableHighlight>
        );
    }
}

const styles = StyleSheet.create({
    view: {flex: 1, paddingTop: 22},
    row: {
        flexDirection: 'row',
        justifyContent: 'center',
        paddingTop: 20,
        paddingBottom: 20,
        paddingLeft: 10,
        paddingRight: 5,
        backgroundColor: '#F6F6F6'
    },
    text: {
        flex: 1,
        fontSize: 12,
    }
});
