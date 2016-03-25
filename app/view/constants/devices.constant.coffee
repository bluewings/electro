'use strict'

angular.module 'electron-app'
.constant 'devices', [
  # {
  #   title: 'Laptop with touch'
  #   type: 'notebook'
  #   screen: [1280, 950]
  #   userAgent: ''
  # }
  {
    title: 'Laptop with HiDPI screen'
    type: 'notebook'
    screen: [1440, 900]
    userAgent: ''
  }
  {
    title: 'Laptop with MDPI screen'
    type: 'notebook'
    screen: [1280, 800]
    userAgent: ''
  }
  {
    title: 'iPhone 4'
    type: 'phone'
    screen: [320, 480]
    userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1'
  }
  {
    title: 'iPhone 5'
    type: 'phone'
    screen: [320, 568]
    userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1'
  }
  {
    title: 'iPhone 6'
    type: 'phone'
    screen: [375, 667]
    userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1'
  }
  {
    title: 'iPhone 6 Plus'
    type: 'phone'
    screen: [414, 736]
    userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1'
  }
  {
    title: 'BlackBerry Z30'
    type: 'phone'
    screen: [360, 640]
    userAgent: 'Mozilla/5.0 (BB10; Touch) AppleWebKit/537.10+ (KHTML, like Gecko) Version/10.0.9.2372 Mobile Safari/537.10+'
  }
  {
    title: 'Nexus 4'
    type: 'phone'
    screen: [384, 640]
    userAgent: 'Mozilla/5.0 (Linux; Android 4.4.2; Nexus 4 Build/KOT49H) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.23 Mobile Safari/537.36'
  }
  {
    title: 'Nexus 5'
    type: 'phone'
    screen: [360, 640]
    userAgent: 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.23 Mobile Safari/537.36'
  }
  {
    title: 'Nexus 5X'
    type: 'phone'
    screen: [411, 731]
    userAgent: 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.23 Mobile Safari/537.36'
  }
  {
    title: 'Nexus 6'
    type: 'phone'
    screen: [412, 732]
    userAgent: 'Mozilla/5.0 (Linux; Android 5.1.1; Nexus 6 Build/LYZ28E) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.23 Mobile Safari/537.36'
  }
  {
    title: 'Nexus 6P'
    type: 'phone'
    screen: [435, 773]
    userAgent: 'Mozilla/5.0 (Linux; Android 5.1.1; Nexus 6 Build/LYZ28E) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.23 Mobile Safari/537.36'
  }
  {
    title: 'LG Optimus L70'
    type: 'phone'
    screen: [384, 640]
    userAgent: 'Mozilla/5.0 (Linux; U; Android 4.4.2; en-us; LGMS323 Build/KOT49I.MS32310c) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/48.0.2564.23 Mobile Safari/537.36'
  }
  {
    title: 'Nokia N9'
    type: 'phone'
    screen: [360, 640]
    userAgent: 'Mozilla/5.0 (MeeGo; NokiaN9) AppleWebKit/534.13 (KHTML, like Gecko) NokiaBrowser/8.5.0 Mobile Safari/534.13'
  }
  {
    title: 'Nokia Lumia 520'
    type: 'phone'
    screen: [320, 533]
    userAgent: 'Mozilla/5.0 (compatible; MSIE 10.0; Windows Phone 8.0; Trident/6.0; IEMobile/10.0; ARM; Touch; NOKIA; Lumia 520)'
  }
  {
    title: 'Galaxy S III'
    type: 'phone'
    screen: [360, 640]
    userAgent: 'Mozilla/5.0 (Linux; U; Android 4.0; en-us; GT-I9300 Build/IMM76D) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30'
  }
  {
    title: 'Galaxy S5'
    type: 'phone'
    screen: [360, 640]
    userAgent: 'Mozilla/5.0 (Linux; Android 5.0; SM-G900P Build/LRX21T) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.23 Mobile Safari/537.36'
  }
  {
    title: 'Kindle Fire HDX'
    type: 'tablet'
    screen: [2560, 1600]
    userAgent: 'Mozilla/5.0 (Linux; U; en-us; KFAPWI Build/JDQ39) AppleWebKit/535.19 (KHTML, like Gecko) Silk/3.13 Safari/535.19 Silk-Accelerated=true'
  }
  {
    title: 'iPad Mini'
    type: 'tablet'
    screen: [1024, 768]
    userAgent: 'Mozilla/5.0 (iPad; CPU OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1'
  }
  {
    title: 'iPad'
    type: 'tablet'
    screen: [1024, 768]
    userAgent: 'Mozilla/5.0 (iPad; CPU OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1'
  }
  {
    title: 'Blackberry PlayBook'
    type: 'tablet'
    screen: [1024, 600]
    userAgent: 'Mozilla/5.0 (PlayBook; U; RIM Tablet OS 2.1.0; en-US) AppleWebKit/536.2+ (KHTML like Gecko) Version/7.2.1.0 Safari/536.2+'
  }
  {
    title: 'Nexus 10'
    type: 'tablet'
    screen: [1280, 800]
    userAgent: 'Mozilla/5.0 (Linux; Android 4.3; Nexus 10 Build/JSS15Q) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.23 Safari/537.36'
  }
  {
    title: 'Nexus 7'
    type: 'tablet'
    screen: [960, 600]
    userAgent: 'Mozilla/5.0 (Linux; Android 4.3; Nexus 7 Build/JSS15Q) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.23 Safari/537.36'
  }
  {
    title: 'Galaxy Note 3'
    type: 'phone'
    screen: [360, 640]
    userAgent: 'Mozilla/5.0 (Linux; U; Android 4.3; en-us; SM-N900T Build/JSS15J) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30'
  }
  {
    title: 'Galaxy Note II'
    type: 'phone'
    screen: [360, 640]
    userAgent: 'Mozilla/5.0 (Linux; U; Android 4.1; en-us; GT-N7100 Build/JRO03C) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30'
  }
]