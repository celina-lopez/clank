import 'jquery'

const playerBannerElm = document.getElementById('player-banner');

export function updateBanner(data, playerId) {
  playerBannerElm.className = `bg-${playerColors[data.current_player_index]}-400 w-100 text-center`
  if (data.current_player_index == playerId) {
    playerBannerElm.children[0].innerHTML = 'Your Turn'
  } else {
    playerBannerElm.children[0].innerHTML = `${data.players[data.current_player_index].name}'s Turn`
  }
}

export function updateLogs(history) {
  for (let i = 0; i < history.length; i++) {
    let logsParent = document.getElementById('logs-parent'),
        log = document.createElement('div');
    log.innerHTML = history[i];
    logsParent.prepend(log);
   toastr.info(history[i]);
  }
}

export function endGame(){
  window.location.reload();
}
