/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
var app = {
    // Application Constructor
    initialize: function() {
        document.addEventListener('deviceready', this.onDeviceReady.bind(this), false);
    },
    onDeviceReady: function() {
        navigator.splashscreen.hide();
        var parentElement = document.getElementById('deviceready');
        var listeningElement = parentElement.querySelector('.listening');
        var receivedElement = parentElement.querySelector('.received');

        listeningElement.setAttribute('style', 'display:none;');
        receivedElement.setAttribute('style', 'display:block;');
        document.addEventListener("backbutton", function(){
            navigator.app.exitApp();
        });
    }
};

app.initialize();

function dialogAlert() {
    navigator.notification.alert(
        'You are the winner!',  // message
        alertDismissed,         // callback
        'Game Over',            // title
        'Done'                  // buttonName
    );
}
function alertDismissed(buttonIndex) {
    alert('You selected button ' + buttonIndex);
}

function dialogConfirm() {
    navigator.notification.confirm(
        'You are the winner!', // message
        alertDismissed,            // callback to invoke with index of button pressed
        'Game Over',           // title
        ['Restart','Exit']     // buttonLabels
    );
}
function dialogPrompt() {
    navigator.notification.prompt(
        'Please enter your name',  // message
        onPrompt,                  // callback to invoke
        'Registration',            // title
        ['Ok','Exit'],             // buttonLabels
        'Jane Doe'                 // defaultText
    );
}

function onPrompt(results) {
    alert("You selected button number " + results.buttonIndex + " and entered " + results.input1);
}

function getDevice() {
    var string = "平台："+device.platform+' 模式'+device.model+' uuid:'+device.uuid+' 版本：'+device.version+' 厂商：'+device.manufacturer+' 序列号：'+device.serial+' isirtual：'+device.isVirtual;
    alert(string);
}
function setStorage() {
    var storage = window.localStorage;
    storage.setItem('device_uuid', device.uuid);
    alert(storage.getItem('device_uuid'));
}

function getStorage() {
    alert("sessionIndex: "+window.localStorage.getItem('sessionIndex'));
}