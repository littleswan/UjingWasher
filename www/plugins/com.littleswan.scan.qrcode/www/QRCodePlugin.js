cordova.define("com.littleswan.scan.qrcode.QRCodePlugin", function(require, exports, module) {
var exec = require('cordova/exec');

var APP_PLUGIN_NAME = 'LittleswanQRCodePlugin';

module.exports = {

    /**
     * 扫码
     * @param connectWifi 是否是配网扫码 不填或0 - 不是 1 - 是
     */
    scanQRCode: function(success, fail, connectWifi) {
        exec(success, fail, APP_PLUGIN_NAME, "scanQRCode", [connectWifi]);
    },

    /**
     * 保存二维码图片
     */
    saveImageDataToLibrary: function(success, fail, canvasId) {
        // successCallback required
        if (typeof success != "function") {
            console.log("LittleswanQRCodePlugin Error: success is not a function");
        } else if (typeof fail != "function") {
            console.log("LittleswanQRCodePlugin Error: fail is not a function");
        } else {
            var canvas = (typeof canvasId === "string") ? document.getElementById(canvasId) : canvasId;
            var imageData = canvas.toDataURL().replace(/data:image\/png;base64,/,'');
            return cordova.exec(success, fail, APP_PLUGIN_NAME, "saveImageDataToLibrary", [imageData]);
        }
    }

};

});
