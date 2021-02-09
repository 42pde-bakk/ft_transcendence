process.env.NODE_ENV = process.env.NODE_ENV || 'production'

const environment = require('./environment')

import { DirectUpload } from "activestorage"
module.exports = environment.toWebpackConfig()
