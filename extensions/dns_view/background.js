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
    url: location.origin + "?asdf"
  })
    .done(function( data, textStatus, jqXHR ) {

      console.log(jqXHR.getResponseHeader("RemoteAddress"));

  // debugger;
  console.log(data);
      console.log(textStatus);
      console.log(jqXHR);

      // $("body").append("<div class='" + (data.ip.indexOf("192.168" > 0 ? "local" : "remote")) + "'>asdfasdf</div>");
      // $("body").append("<style>" + 
      // ".local{background:blue;} .remote{background:red;}" + 
      // "</style>");
    });




    
});