'use strict';

const electron = require('electron');
// Module to control application life.
const app = electron.app;
// Module to create native browser window.
const BrowserWindow = electron.BrowserWindow;
const path = require('path');

// var screenshot = require('electron-screenshot-service')

// Keep a global reference of the window object, if you don't, the window will
// be closed automatically when the JavaScript object is garbage collected.
let mainWindow;

require('electron-reload')(__dirname);

require('./main/capture');

function createWindow() {
  // Create the browser window.
  mainWindow = new BrowserWindow({
    width: 768,
    height: 1024
  });
  // mainWindow = new BrowserWindow({width: 1024, height: 768});

  // and load the index.html of the app.
  mainWindow.loadURL('file://' + __dirname + '/index.html');

  // Open the DevTools.
  mainWindow.webContents.openDevTools();

  // Emitted when the window is closed.
  mainWindow.on('closed', function () {
    // Dereference the window object, usually you would store windows
    // in an array if your app supports multi windows, this is the time
    // when you should delete the corresponding element.
    mainWindow = null;
  });
}

function registerProtocol() {
  var protocol = electron.protocol;
  protocol.registerFileProtocol('nvcapture', function (request, callback) {
    var url = request.url.substr(7);
    console.log(request.url);
    // callback({
    //   path: path.normalize(__dirname + '/' + url)
    // });
  }, function (error) {
    if (error) {
      console.error('Failed to register protocol')
    }
  });
}

// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
app.on('ready', function () {
  registerProtocol();
  createWindow();
});

// Quit when all windows are closed.
app.on('window-all-closed', function () {
  // On OS X it is common for applications and their menu bar
  // to stay active until the user quits explicitly with Cmd + Q
  app.quit();
  // if (process.platform !== 'darwin') {
  //   app.quit();
  // }
});

app.on('open-url', function(event) {
  // app.quit();
  console.log('open-url detected');
  console.log(event);
});

app.on('activate', function () {
  // On OS X it's common to re-create a window in the app when the
  // dock icon is clicked and there are no other windows open.
  if (mainWindow === null) {
    createWindow();
  }
});