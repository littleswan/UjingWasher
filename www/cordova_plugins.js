cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
    {
        "id": "com.littleswan.scan.qrcode.QRCodePlugin",
        "file": "plugins/com.littleswan.scan.qrcode/www/QRCodePlugin.js",
        "pluginId": "com.littleswan.scan.qrcode",
        "clobbers": [
            "com.littleswan.scan.qrcode"
        ]
    }
];
module.exports.metadata = 
// TOP OF METADATA
{
    "com.littleswan.scan.qrcode": "1.0.9",
    "cordova-plugin-whitelist": "1.3.2"
};
// BOTTOM OF METADATA
});