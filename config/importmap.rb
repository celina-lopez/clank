# Pin npm packages by running ./bin/importmap

pin 'application', preload: true
pin '@rails/actioncable', to: 'https://ga.jspm.io/npm:@rails/actioncable@7.0.3-1/app/assets/javascripts/actioncable.esm.js'
pin_all_from 'app/javascript/channels', under: 'channels'
pin_all_from 'app/javascript/game', under: 'game'
pin 'trix'
# pin 'actioncable', to: '/assets/actioncable.esm.js'
pin 'jquery', to: 'https://ga.jspm.io/npm:jquery@3.6.0/dist/jquery.js', preload: true
pin 'toastr', to: 'https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js'
