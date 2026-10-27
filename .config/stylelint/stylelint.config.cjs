// Global Stylelint fallback. A project config in the file's directory
// (or a parent) is used instead. Rules and plugins come from the
// lint-rules skill.
const path = require("path")
const os = require("os")

const createConfig = require(path.join(
  os.homedir(),
  ".agents/skills/lint-rules/rules/css/create-config.cjs",
))

module.exports = createConfig()
