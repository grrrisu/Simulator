module.exports = {
  entry: {
    monitor: './monitor',
    game_of_life: './game_of_life'
  },
  output: {
    path: './public',
    filename: '[name].js'
  },
  module: {
    loaders: [
      {
        test:   /\.js/,
        loader: 'babel',
        include: [
          __dirname + '/monitor',
          __dirname + '/game_of_life'
        ]
      }
    ]
  }
}
