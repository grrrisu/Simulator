module.exports = {
  entry: './client',
  output: {
    path: './public',
    filename: 'client.js'
  },
  module: {
    loaders: [
      {
        test:   /\.js/,
        loader: 'babel',
        include: __dirname + '/client',
      }
    ],
  }
}
