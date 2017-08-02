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
        document.addEventListener("offline", this.onOffline.bind(this), false);
    },
    onDeviceReady: function() {
        document.addEventListener("backbutton", function(){
          var hash = window.location.hash.replace('#/','');
          if(hash =='home' || hash =='appstore' || hash =='message' || hash =='setting'){
            exitConfirm();
          }else{
            navigator.app.backHistory();
          }
        });
        //应用图标加载
        try{
          var elememts = document.querySelectorAll('.loadappimg');
          for(var i= 0; i< elememts.length; i ++){
            elememts[i].addEventListener('load',loadimg(elememts[i]));
          }
        }catch (e){
          alert(JOSN.stringify(e));
        }
    },
    onOffline: function() {
      $toast.show(':( 网络已断开，请重新开启您的网络',1500);
  }
};

function exitConfirmCallback(buttonIndex) {
  if(buttonIndex == 1){
    navigator.app.exitApp();
  }
}

function exitConfirm() {
  navigator.notification.confirm(
    '确定要退出程序吗？',
    exitConfirmCallback,
    '退出提示',
    ['确定','取消']
  );
}

//加载本地图片
function loadimg(imgobj) {
  var appicon = imgobj.getAttribute('appicon');
  var files = new Array();
  files = appicon.split('/');
  var filename = files[files.length -1];
  // alert(filename);
  try {
    window.requestFileSystem(LocalFileSystem.TEMPORARY, 0, function (fs) {
      // alert('打开的文件系统: ' + JSON.stringify(fs));
      fs.root.getDirectory('aasfiles', {create: true}, function (dirEntry) {
        dirEntry.getFile(filename, { create: true, exclusive: false },
          function (fileEntry) {
            // alert('fileEntry : ' + JSON.stringify(fileEntry));
            //读文件
            fileEntry.file(function(file) {
              // alert('file : ' + JSON.stringify(file));
              if(file.size > 0){ //判断文件大小
                imgobj.setAttribute('src',fileEntry.nativeURL);
              }else{
                downloadimage(imgobj,appicon,fileEntry.toURL());
              }
            }, onErrorReadFile);
          }, onErrorCreateFile);
      },onErrorCreateDir);
    }, onErrorLoadFs);
  }catch (e){}
}
//下载图片至本地
function downloadimage(imgobj,appicon,fileURL) {
  var fileTransfer = new FileTransfer();
  fileTransfer.download(
    appicon,
    fileURL,
    function(entry) {
      // alert("download complete: " + JSON.stringify(entry));
      imgobj.setAttribute('src',entry.nativeURL);
    },
    function(error) {
      console.log("download error :" + JSON.stringify(error));
    },
    false,
    {}
  );
}
//读取文件失败响应
function onErrorReadFile(error){
  console.log("文件读取失败 :" + JSON.stringify(error));
}
//读取文件失败响应
function onErrorCreateFile(error){
  console.log("文件夹创建失败 :" + JSON.stringify(error));
}
//读取文件失败响应
function onErrorCreateDir(error){
  console.log("文件夹创建失败 :" + JSON.stringify(error));
}
//FileSystem加载失败回调
function  onErrorLoadFs(error){
  console.log("文件系统加载失败 :" + JSON.stringify(error));
}