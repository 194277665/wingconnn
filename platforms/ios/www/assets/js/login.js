var app = {
  // Application Constructor
  initialize: function() {
    document.addEventListener('deviceready', this.onDeviceReady.bind(this), false);
    document.addEventListener("offline", this.onOffline.bind(this), false);
  },
  onDeviceReady: function() {
    document.addEventListener("backbutton", function(){
      exitConfirm();
    });
  },
  onOffline: function() {
    window.plugins.toast.show(':( 网络已断开，请重新开启您的网络',2000,'center');
  }
};
app.initialize();

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
//websocket监听
// var aas_backend_host = 'http://10.10.12.158:8000';
// var aas_websocket_host = 'ws://10.10.12.158:8001';
var aas_backend_host = 'http://shell.wingconn.net/aasservice';
var aas_websocket_host = 'ws://shell.wingconn.net:8002';
var ws;
var ThemeableBrowser;
//检测sessionindex
function checkSessionIndex() {
  var sessionIndex = localStorage.getItem('sessionIndex');
  $.getJSON(aas_backend_host+'/api/common/checkSessionindex',{sessionIndex: sessionIndex},function (data) {
    if(data.response) {
      window.location.href = 'app.html';
    }else{
      navigator.splashscreen.hide();
    }
  })
}
//打开地址
function loadUrl(url){
  var target = "_blank";
  var options = {
    statusbar: {
      color: '#000000'
    },
    toolbar: {
      height: 44,
      color: '#0f8ee8'
    },
    title: {
      color: '#ffffff',
      showPageTitle: true
    },
    backButton: {
      wwwImage: 'img/back.png',
      wwwImagePressed: 'img/back.png',
      wwwImageDensity: 2,
      align: 'left',
      event: 'backPressed'
    },
    forwardButton: {
      wwwImage: 'img/forward.png',
      wwwImagePressed: 'img/forward.png',
      wwwImageDensity: 2,
      align: 'left',
      event: 'forwardPressed'
    },
    closeButton: {
      wwwImage: 'img/close.png',
      wwwImagePressed: 'img/close.png',
      wwwImageDensity: 2,
      align: 'right',
      event: 'closePressed'
    },
    backButtonCanClose: true
  };
  ThemeableBrowser = cordova.ThemeableBrowser.open(url, target, options).addEventListener('exit',function(){
    checkSessionIndex();
  }).addEventListener(cordova.ThemeableBrowser.EVT_ERR, function(e) {
    window.plugins.toast.showShortCenter(e.message);
  });
}
//初始化websocket
function initWebsoket() {
  if(!window.WebSocket){
    window.plugins.toast.showShortCenter('This browser is not support websocket!');
  }
  var wsurl = aas_websocket_host + "/?id="+ device.uuid;

  ws=new WebSocket(wsurl);
  //监听消息
  ws.onmessage = function(event) {
    processdata(event.data);
  };
  // 打开WebSocket
  ws.onclose = function(event) {
    //WebSocket Status:: Socket Closed
  };
  // 打开WebSocket
  ws.onopen = function(event) {
    var loginurl = aas_backend_host + '/login/sso?uuid=' + device.uuid;
    loadUrl(loginurl);
  };
  ws.onerror =function(){
    window.plugins.toast.showShortCenter('websocket error!');
  };
}
//处理websocket 数据
function processdata(data){
  var jsonData = JSON.parse(data);
  if(jsonData.path =='login' && jsonData.relayState == device.uuid){
    localStorage.setItem('sessionIndex', jsonData.sessionIndex);
    localStorage.setItem('userid', jsonData.userid);
    localStorage.setItem('ssoId', jsonData.ssoId);
    localStorage.setItem('mobile', jsonData.mobile);
    localStorage.setItem('logdate', jsonData.logdate);
    window.plugins.toast.show('登录成功 :)',500,'center');
    window.location.href = 'app.html';
  }else{
    ThemeableBrowser.close();
    window.plugins.toast.showShortCenter('登录失败，请重试 :(');
  }
}