const fs = require("fs");

module.exports = {
  devServer: {
    disableHostCheck: true,
    https: {
      key: fs.readFileSync("./tmp/sonub.key"),
      cert: fs.readFileSync("./tmp/sonub.cert")
    },
    host: "vue.sonub.com"
  }
};
