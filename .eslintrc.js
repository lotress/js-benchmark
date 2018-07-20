module.exports = {
    "env": {
        "node": true,
        "commonjs": true,
        "es6": true
    },
    "parserOptions": {
        "ecmaVersion": 9
    },
    "extends": "eslint:recommended",
    "rules": {
        "indent": [
            "error",
            2
        ],
        "linebreak-style": [
            "error",
            "windows"
        ],
        "quotes": [
            "error",
            "single"
        ],
        "semi": [
            "error",
            "never"
        ],
        "no-console": "off"
    }
};