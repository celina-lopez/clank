import 'jquery'

const playerBannerElm = document.getElementById('player-banner'),
      statTemplate = document.getElementById('stat-template');

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

export function updateStat(playerStatContainer, name, value) {
  const clone = document.importNode(statTemplate.content, true),
      parent = clone.children[0],
      actionElm = document.getElementById('template-' + name),
      actionTemplate = document.importNode(actionElm.content, true).children[0];
  parent.children[0].appendChild(actionTemplate);
  parent.children[1].innerHTML = Utils.displayName(name);
  parent.children[2].innerHTML = value;
  playerStatContainer.appendChild(clone);
}
