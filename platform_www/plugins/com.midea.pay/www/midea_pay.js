cordova.define("com.midea.pay.MideaPay", function(require, exports, module) {
var exec = require('cordova/exec');

module.exports = {

    payment: function(payInfo, success, error) {
        exec(success, error, "MideaPay", "payment", [payInfo]);
    },

    wechatpay: function (tokenId, totalFee, success, error) {
        exec(success, error, "MideaPay", "wechatPay", [tokenId, totalFee]);
    }
};

});
