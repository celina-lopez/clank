import 'jquery'

// CARD FUNCTIONS
const cardTemplate = document.getElementById('card-template')?.content,
      rewardParent = document.getElementById('rewards-parent')?.content,
      rewardTemplate = document.getElementById('rewards-option')?.content,
      trashOptionOne = document.getElementById('trash-option-1')?.content,
      trashOptionTwo = document.getElementById('trash-option-2')?.content,
      circleTemplate = document.getElementById('circle-template')?.content,
      rewardContainer = document.getElementById('rewards-id'),
      statTemplate = document.getElementById('stat-template')?.content,
      healthStatTemplate = document.getElementById('health-stat')?.content,
      playerBannerElm = document.getElementById('player-banner'),
      endTurnElm = document.getElementById('end_turn_button'),
      statKeys = ['attack_points', 'move_points', 'skill_points', 'clank', 'coins'];


function createCardClone(cardClone, card, playerHand=false) {
  let image = cardClone.querySelector('figure').children[0];
  image.src = `/images/${card['name']}.png`;
  image.alt = card['name'];
  if (playerHand) {
    cardClone.dataset.type = card['name'];
  } else {
    cardClone.dataset.type = 'buy_card';
    cardClone.dataset.name = card['name'];
  }
  let container = cardClone.children[1];
  container.querySelector('.card_name').innerHTML = Utils.displayName(card['name'])
  let actionParentElm = container.querySelector('.card_actions_parent');
  if (card['actions']) addPopUpActions(card['actions'], actionParentElm)
  if (card['action']) addPopUpActions(card['action'], actionParentElm)
  if (card['conditions']) {
    card['conditions'].forEach(function(condition) {
      if (condition['type'] == 'can_buy'){
        actionParentElm.innerHTML += "<div>Can ONLY "
        actionParentElm.innerHTML += card['health'] ? 'attack' : 'buy'
        actionParentElm.innerHTML += ` in ${Utils.displayName(condition['is_in'])}</div>`
      }
    });
  } 
  if (card.description) {
   actionParentElm.innerHTML += `<div>${card.description}</div>`;
  }
  ['cost', 'health'].forEach(function(key) {
    if (card[key]) {
      let div = document.createElement('div');
      div.classList.add(`bg-${key == 'cost' ? 'sky' : 'red'}-600`, 'px-1', 'rounded-br', 'text-white', 'absolute', 'bottom-0', 'right-0');
      div.innerHTML = card[key];
      container.appendChild(div);
    }
  });
  return cardClone;
};

function addActionElm(parent, action, key){
  let actionElm = document.getElementById('template-' + key);
  if (!!actionElm) {
    let actionTemplate = document.importNode(actionElm.content, true).children[0];
    parent.appendChild(actionTemplate);
  }
  let value = action[key],
      label = Utils.displayName(key.replace(/_points|_options/g, '')),
      description = `${value} ${label}`; 
  if (Number.isInteger(value) && value > 0) description = `+${value} ${label}`;
  if (typeof(value) == 'object') description = `${label} ${Object.keys(value)[0]}`;
  parent.innerHTML += `${description}<br/>`;
}

function addPopUpActions(actions, actionParentElm){
  for (let i = 0; i < actions.length; i++) {
    let action = actions[i];
    Object.keys(action).forEach(function(key) {
      addActionElm(actionParentElm, action, key)
    });
    if (i < actions.length - 1) actionParentElm.innerHTML += '<div>or</div>';
  }
}

function createCard(card, playerHand=false){
  let clone = document.importNode(cardTemplate, true),
      cardParent = clone.children[0];
  createCardClone(cardParent.children[0], card, playerHand);
  createCardClone(cardParent.children[1].children[0], card, playerHand);
  return cardParent; 
}

function createCircle(card) {
  let circleClone = document.importNode(circleTemplate, true),
      circleParent = circleClone.children[0],
      itemParent = circleParent.children[0],
      popUp = circleParent.children[1].children[0];
  itemParent.dataset.name = card['name'];
  itemParent.dataset.type = 'redeem_inventory_item'; 
  itemParent.innerHTML = `<img src='/images/${card['name'].replace(/greater_/g, '')}.png' class="rounded-full w-[50px]"/>`
  createCardClone(popUp, card);
  return circleParent;
}

function populateCards(prefix, cards, playerHand=false) {
  document.getElementById(`${prefix}-cards`).innerHTML = ""
  let index = 0;
  cards.forEach(function(card) { 
    let cardParent = createCard(card, playerHand)
    document.querySelector(`#${prefix}-cards`).appendChild(cardParent);
    index += 1;
  })
};

// PLAYER FUNCTIONS
function updateStats(game) {
  game.players.forEach(function(player) {
    let playerStatContainer = document.getElementById(`player-stats-${player.index}`);
    playerStatContainer.innerHTML = '';
    statKeys.forEach(function(stat) {
      if (player[stat] > 0) {
        let statClone = document.importNode(statTemplate, true),
            statParent = statClone.children[0],
            actionElm = document.getElementById('template-' + stat),
            actionTemplate = document.importNode(actionElm.content, true).children[0];
        statParent.children[0].appendChild(actionTemplate);
        statParent.children[1].innerHTML = Utils.displayName(stat);
        statParent.children[2].innerHTML = player[stat]; 
        playerStatContainer.appendChild(statClone);
      }
    });
    let healthStatClone = document.importNode(healthStatTemplate, true),
    statParent = healthStatClone.children[0].children[0],
    heart = statParent.children[0].querySelector('rect'),
    heartStat = statParent.children[1],
    heightStat = (player.health / 10) * 100;
    heart.setAttribute('height', `${heightStat}%`);
    heart.setAttribute('y', `${100 - heightStat}%`);
    heartStat.innerHTML = player.health;
    playerStatContainer.appendChild(healthStatClone);
  });
}


function addRewards(player) {
  if (!player['rewards']) { return }
  rewardContainer.innerHTML = '';
  if (player['rewards'].length > 0) {
    rewardContainer.classList.remove('hidden');
    for (let i = 0; i < player['rewards'].length; i++) {
      let rewardClone = document.importNode(rewardParent, true),
          reward = player['rewards'][i];
      for (let j = 0; j < reward.length; j++) {
        let rewardOption = document.importNode(rewardTemplate, true),
            rewardOptionData = reward[j],
            rewardOptionKeys = Object.keys(rewardOptionData),
            innerText = '';
        for (let k = 0; k < rewardOptionKeys.length; k++) {
          let label = rewardOptionKeys[k];
          if (label == 'discard_number') {
            label = `Discard ${rewardOptionData[rewardOptionKeys[k]]} card(s)`;
          } else if (['health', 'coins', 'attack_points', 'move_points'].includes(label)) {  
            label = `Gain ${rewardOptionData[rewardOptionKeys[k]]} ${Utils.displayName(label.split('_points')[0])}`;
          } else {
            label = Utils.displayName(label)
          }
          innerText += label + '<br/>';
        }
        rewardOption.children[0].innerHTML += innerText
        rewardOption.children[0].setAttribute('data-name', `${i},${j}`);
        rewardClone.children[1].appendChild(rewardOption);
      }
      rewardContainer.appendChild(rewardClone);
    }
  } else {
    rewardContainer.classList.add('hidden');
  }
}


function addTrashOptions(player) {
  if (!player['trash_options']) { return }
  document.getElementById("trash-options-id").innerHTML = '';
  if (player['trash_options'].length > 0) {
    document.getElementById("trash-options-id").classList.remove('hidden');
    for (let i = 0; i < player['trash_options'].length; i++) {
      let trash = player['trash_options'][i];
      if (trash instanceof Object) {
        let trashClone = document.importNode(trashOptionOne, true);
        trashClone.children[1].dataset.name = `${Object.keys(player['trash_options'][i])[0]},active`
        trashClone.children[2].dataset.name = `${Object.keys(player['trash_options'][i])[0]},discarded`
        document.getElementById("trash-options-id").appendChild(trashClone);
      } else {
        let trashClone = document.importNode(trashOptionTwo, true);
        ['active', 'discarded'].forEach(function(type) {
          player['deck'][type].forEach(function(card) {
            let cardParent = createCard(card);
            cardParent.children[0].dataset.type  = 'trash';
            cardParent.children[0].dataset.name = `${card['name']},${type}`;
            trashClone.querySelector(`#${type}-trash-cards`).appendChild(cardParent);
          })
        })
        document.getElementById("trash-options-id").appendChild(trashClone);
      }
    }
  } else {
    document.getElementById("trash-options-id").classList.add('hidden');
  }
}

function addEndTurnButton(isCurrentPlayer) {
  if (!isCurrentPlayer) {
    endTurnElm.classList?.add('hidden');
    return
  }
  endTurnElm.classList?.remove('hidden');
}

function updateBanner(data, playerId) {
  playerBannerElm.className = `bg-${playerColors[data.current_player_index]}-400 w-100 text-center`
  if (data.current_player_index == playerId) {
    playerBannerElm.children[0].innerHTML = 'Your Turn'
  } else {
    playerBannerElm.children[0].innerHTML = `${data.players[data.current_player_index].name}'s Turn`
  }
}

export function updatePlayerData(player, playerId, data) {
  // TODO: clean up this later 
  addEndTurnButton(data['current_player_index'] == playerId)
  addRewards(player);
  addTrashOptions(player);
  populateCards('player', player['deck']['active'], true);
  updateBanner(data, playerId)
}
// GAME FUNCTIONS

export function updateGameData(data) {
  // TODO: fix inventory images 
  updateStats(data);
  HtmlActions.addHoverCardFunctions()
  // updateLogs(data['latest_logs']);
  // TODO: fix game logs
}

function updateLogs(history) {
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
