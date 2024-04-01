const config = require("../../.eslintrc.base")

const newConfig = structuredClone(config)

newConfig.extends.push("plugin:vue/vue3-recommended")
newConfig.env.browser = true
newConfig.parserOptions.sourceType = "module"
newConfig.parserOptions.project = ["./tsconfig.json"]
newConfig.parserOptions.tsconfigRootDir = __dirname

module.exports = newConfig