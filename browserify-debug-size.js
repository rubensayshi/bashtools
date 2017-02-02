#!/home/ruben/.nvm/versions/node/v0.12.10/bin/node

var _ = require('lodash');
var fs = require('fs');
var exec = require("child_process").exec;

var exclude = ['browserify'];

exec("browserify " + process.argv[2] + " --list", function(err, stdout, stderr) {
    var files = stdout.split("\n");

    var moduleSizes = {};

    files.filter(function(f) { return !!f; }).forEach(function(file) {
        var modules = file.match(/node_modules\/(.+?)\//g);

        if (modules) {
            var module = null;
            modules.forEach(function(_module, i) {
                if (module) {
                    return;
                }

                _module = _module.substr(13, _module.length - 14);

                if (exclude.indexOf(_module) === -1 || i === modules.length - 1) {
                    module = _module;
                }
            });
        } else {
            module = "self";
        }

        if (!moduleSizes[module]) {
            moduleSizes[module] = {
                module: module,
                size: 0
            }
        }

        moduleSizes[module]['size'] += fs.statSync(file)['size'];
    });


    console.log(_.sortBy(moduleSizes, 'size'));
    console.log(_.sum(_.map(moduleSizes, function(module) { return module.size; })));
});
