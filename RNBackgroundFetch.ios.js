const { React, NativeEventEmitter} = require('react-native')
const { RNBackgroundFetch } = require('react-native').NativeModules


class Api extends NativeEventEmitter {
  constructor() {
    super(RNBackgroundFetch)
  }

  addEventListener(type, handler) {
    this.addListener(type, handler)
  }

  done(result) {
    RNBackgroundFetch.done(result)
  }
}

module.exports = new Api()
