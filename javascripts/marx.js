/*
  marx.js
  version : 1.0.1
  authors : Keith Raymond, Marx.js contributor
  license : MIT
  marxjs.com
*/

window.Marx = function(options) {
  var xhr,
    _this = this;
  this._url = "http://marxjs.com";
  xhr = new XMLHttpRequest();
  xhr.open("GET", "" + this._url + "/characters");
  xhr.send(null);
  return xhr.onreadystatechange = function() {
    var DONE, OK;
    DONE = 4;
    OK = 200;
    if (xhr.readyState === DONE) {
      if (xhr.status === OK) {
        console.log(_this);
        _this.marx_json = JSON.parse(xhr.responseText);
        return _this.initialize(options);
      }
    }
  };
};

Marx.prototype.settings = {
  controls: 'standard',
  position: 'bottom-right',
  form: "",
  ipsum: 3,
  max_ipsum: 10,
  onload: false
};

Marx.prototype.initialize = function(options) {
  return console.log('what!!!');
};
