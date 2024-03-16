# Pin npm packages by running ./bin/importmap

pin 'application', preload: true
pin '@rails/actioncable', to: 'https://ga.jspm.io/npm:@rails/actioncable@7.0.3-1/app/assets/javascripts/actioncable.esm.js'
pin_all_from 'app/javascript/channels', under: 'channels'
pin 'trix'
pin 'actioncable', to: '/assets/actioncable.js'
