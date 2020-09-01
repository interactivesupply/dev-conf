// chrome.tabs.onUpdated.addListener(function(tabId, changeInfo, tab) {
//   getURL();

//   }); 

// chrome.tabs.onActivated.addListener(function(activeInfo) {
//   // how to fetch tab url using activeInfo.tabid
//   chrome.tabs.get(activeInfo.tabId, function(tab){


//   getURL();

//      var ip = location.host;
//     //  console.log(ip);
//   });
// }); 
// function  getURL()
// {
//   chrome.tabs.query({'active': true, 'lastFocusedWindow': true}, function (tabs) {
//     var url = tabs[0].url;
//     console.log(url);

//     var div=document.createElement("div"); 
// document.body.appendChild(div); 
// div.innerText="test123";
//     //alert(url);
// });
// }
//   //chrome.tabs.insertCSS(integer tabId, object details, function callback)
$( document ).ready(function() {
  $.ajax({
    url: "https://test.localhost/ping.php?url=" + location.host,
    crossDomain: true,
    dataType: 'json',
    contentType: "application/json;"
  })
    .done(function( data, textStatus, jqXHR ) {
      if(data.ip != undefined)
      {
      var pointedAt = data.ip.indexOf("192.168") > -1 ? "local" : "remote";
        $("body").append("<div class='" + pointedAt + "'>" + pointedAt + "</div>");
        $("body").append("<style>" + 
        ".local{background:blue;position:absolute;top:0;right:0;color:#fff;z-index:1000000;} .remote{background:red;position:absolute;top:0;right:0;color:#fff;z-index:1000000;}" + 
        "</style>");
      }
    }).fail(function(data) {
      console.log(data);
    })
    .always(function(data) {
      console.log(data);
    });
});