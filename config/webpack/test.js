process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')

import { DirectUpload } from "activestorage"
module.exports = environment.toWebpackConfig()
