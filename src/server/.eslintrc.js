const config = require("../../.eslintrc.base")

const newConfig = structuredClone(config)

newConfig.env.node = true
newConfig.parserOptions.project = ["./tsconfig.json"]
newConfig.parserOptions.tsconfigRootDir = __dirname

module.exports = newConfig