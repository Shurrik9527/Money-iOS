
$(function(){
  var scheme = '#videohandler';
  //$(".header").hide();
  var videos = $("#playBtn");
  videos.attr("href",scheme);
  videos.click(function(){
               
               });
  
  
  });


console = new Object();
console.log = function(log) {
    var iframe = document.createElement("IFRAME");
    iframe.setAttribute("src", "ios-log:" + log);
    document.documentElement.appendChild(iframe);
    iframe.parentNode.removeChild(iframe);
    iframe = null;
}
console.debug = console.log;
console.info = console.log;
console.warn = console.log;
console.error = console.log;