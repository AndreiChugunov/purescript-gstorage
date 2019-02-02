const Storage = require("@google-cloud/storage");


exports.createStorage = function (filename) {
    return function() {
        return new Storage({keyFilename: filename});
    };
};

exports._uploadFile = function(errCB, scCB, storage, bucketName, filename) {
    return function () {
        storage.bucket(bucketName).upload(filename, {
            gzip: true,
            metadata: {
                cacheControl: 'public, max-age=31536000',
            },
        })
        .then(function(res) {
            scCB(res)();
        })
        .catch(function(err) {
            errCB(err)();
        });
    }; 
};

// url will no be avaliable in 10 mins.
exports._generateSignedUrl = function (errCB, scCB, storage, bucketName, filename) {
    return function () {
        const options = {
            action: 'read',
            expires: Date.now() + 10 * 60 * 1000,
        };
        const url = storage
        .bucket(bucketName)
        .file(filename)
        .getSignedUrl(options);
        return url.then(function(res) {
            scCB(res)();
        })
        .catch(function(err) {
            errCB(err)();
        });
    };
};

