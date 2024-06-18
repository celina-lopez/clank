
// CARD FUNCTIONS
const cardTemplate = document.getElementById('card-template').content,
      rewardParent = document.getElementById('rewards-parent').content,
      rewardTemplate = document.getElementById('rewards-option').content,
      trashOptionOne = document.getElementById('trash-option-1').content,
      trashOptionTwo = document.getElementById('trash-option-2').content,
      endButtonString = '<button class="btn" onclick="executeAction(this)" data-type="end_turn">End Turn</button>';


function displayName(name) {
  return name.
    replace(/_/g, ' ').
    replace(/(?: |\b)(\w)/g, function(key, _p1) { return key.toUpperCase() });
}

function createCardClone(cardParent, card) {
  const cardClone = cardParent.children[0];
  cardClone.querySelector('img').src = `/images/${card['name']}.jpeg`
  cardClone.querySelector('.card_name').innerHTML = displayName(card['name'])
  if (card['actions']?.length == 1) {
    Object.keys(card['actions'][0]).forEach(function(key) {
      let actionElm = document.getElementById('template-' + key);
      if (!!actionElm) {
        let actionTemplate = document.importNode(actionElm.content, true);
        cardClone.querySelector('.card_actions_parent').appendChild(actionTemplate.children[0]);
        cardClone.querySelector('.card_actions_parent').innerHTML += card['actions'][0][key]; 
      }
    });
  }

  ['cost', 'health'].forEach(function(key) {
    if (card[key]) {
      let div = document.createElement('div');
      div.classList.add(`bg-${key == 'cost' ? 'sky' : 'red'}-600`, 'px-1', 'rounded-br-sm', 'text-white', 'absolute', 'bottom-0', 'right-0');
      div.innerHTML = card[key];
      cardClone.appendChild(div);
    }
  });
  return cardClone;
};

function addPopUpActions(actions, actionParentElm){
  for (let i = 0; i < actions.length; i++) {
    let action = actions[i];
    Object.keys(action).forEach(function(key) {
      let actionElm = document.getElementById('template-' + key);
      if (!!actionElm) {
        let actionTemplate = document.importNode(actionElm.content, true).children[0];
        actionParentElm.appendChild(actionTemplate);
      }
      let value = action[key];
      if (Number.isInteger(value) && value > 0) value = `+${value}`;
      actionParentElm.innerHTML += `${value} ${displayName(key.split('_points')[0])}<br/>`;
    });
    if (i < actions.length - 1) actionParentElm.innerHTML += '<div>or</div>';
  }
}

function createCardPopup(cardParent, card) {
  const cardPopup = cardParent.children[2];
  cardPopup.querySelector('h3').innerHTML = displayName(card['name'])
  cardPopup.querySelector('img').src = `/images/${card['name']}.jpeg` 
  let actionParentElm = cardPopup.querySelector('.action_parent');
  if (card['actions']) addPopUpActions(card['actions'], actionParentElm)
  if (card['acquire']) {
    actionParentElm.innerHTML += `<div>On Acquire</div><hr/>`
    addPopUpActions(card['acquire'], actionParentElm)
  }
  if (card['cost']) actionParentElm.innerHTML += `<br/>Skill cost: ${card['cost']}`;
  if (card['health']) actionParentElm.innerHTML += `<br/>Health: ${card['health']}`;
  return cardPopup;
};

function findCardButton(cardParent) {
  return cardParent.children[1].children[0];
};

function createCard(card){
  let clone = document.importNode(cardTemplate, true),
      cardParent = clone.children[0];
  createCardClone(cardParent, card);
  createCardPopup(cardParent, card);
  return cardParent; 
}

function populateCards(prefix, cards, playerHand=false) {
  document.getElementById(`${prefix}-cards`).innerHTML = ""
  let index = 0;
  cards.forEach(function(card) { 
    let cardParent = createCard(card)
    cardParent.id =`${prefix}-card-${index}`;
    let cardButton = findCardButton(cardParent);
    if (playerHand) {
      cardButton.dataset.type = card['name'];
      cardButton.innerHTML = 'use';
    } else {
      cardButton.dataset.type = 'buy_card';
      cardButton.dataset.name = card['name'];
      cardButton.innerHTML = 'buy';
    }
    document.querySelector(`#${prefix}-cards`).appendChild(cardParent);
    index += 1;
  })
};

// PLAYER FUNCTIONS
function updateStats(player) {
  ['health', 'move_points', 'attack_points', 'clank', 'skill_points'].forEach(function(stat) {
    document.getElementById(stat).innerHTML = player[stat];
  });
}

function updateInventory(player) {
  if (player['inventory']) {
    let inventory = document.getElementById('inventory-id');
    inventory.innerHTML = "";
    inventory.classList.remove('hidden');
    player['inventory'].forEach(function(item) {
      let itemElement = document.createElement('img'),
          inventoryName = displayName(item['name'].replace(/greater_/g, ''));
      itemElement.src = '/images/' + inventoryName + '.jpg';
      itemElement.width = 70;
      itemElement.classList.add('rounded-full');
      inventory.appendChild(itemElement);
    });
  }
}

function addRewards(player) {
  if (player['rewards'].length > 0) {
    document.getElementById("rewards-id").innerHTML = '';
    document.getElementById("rewards-id").classList.remove('hidden');
    for (let i = 0; i < player['rewards'].length; i++) {
      let rewardClone = document.importNode(rewardParent, true),
          reward = player['rewards'][i];
      for (let j = 0; j < reward.length; j++) {
        let rewardOption = document.importNode(rewardTemplate, true),
            rewardOptionData = reward[j],
            rewardOptionKeys = Object.keys(rewardOptionData);
        for (let k = 0; k < rewardOptionKeys.length; k++) {
          let label = rewardOptionKeys[k];
          if (label == 'discard_number') {
            label = `Discard ${rewardOptionData[rewardOptionKeys[k]]} card(s)`;
          } else if (label == 'spend_seven_for_two_secret_tomes') {
            label = 'Spend 7 coins for 2 secret tome this turn';
          } else if (['health', 'coins', 'attack_points', 'move_points'].includes(label)) {  
            label = `Gain ${rewardOptionData[rewardOptionKeys[k]]} ${displayName(label.split('_points')[0])}`;
          } else {
            label = displayName(label)
          }
          rewardOption.children[0].innerHTML = label
          rewardOption.children[0].setAttribute('data-name', `${i},${j}`);
          rewardClone.children[1].appendChild(rewardOption);
        }
      }
      document.getElementById("rewards-id").appendChild(rewardClone);
    }
  } else {
    document.getElementById("rewards-id").innerHTML = '';
    document.getElementById("rewards-id").classList.add('hidden');
  }
}

function updatePlayerPosition(player, playerId) {
  var playerPosition = mapTiles.find((tile) => tile.tile === parseInt(player['position']['current_position']));
  gamePlayers[playerId].setOrigin(playerPosition.frontend_data.x, playerPosition.frontend_data.y);
}

function addTrashOptions(player) {
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
            let cardParent = createCard(card),
                button = findCardButton(cardParent);
            button.innerHTML = 'trash';
            button.dataset.type  = 'trash';
            button.dataset.name = `${card['name']},${type}`;
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

function replaceCard(player, cards) {
  document.getElementById("replace-card-id").innerHTML = '';
  if (player['replace_card_points'] > 0) {
    let replaceCardElm = document.getElementById('replace-cards').content,
        replaceClone = document.importNode(replaceCardElm, true);
    document.getElementById("replace-card-id").classList.remove('hidden');
    cards.forEach(function(card) { 
      let cardParent = createCard(card),
          button = findCardButton(cardParent);
      button.innerHTML = 'replace';
      button.dataset.type  = 'replace_card';
      // TODO: fix frontend
      button.dataset.name = card['name'];
      replaceClone.querySelector("#replace-active-cards").appendChild(cardParent);
    })
    document.getElementById("replace-card-id").appendChild(replaceClone);
  } else {
    document.getElementById("replace-card-id").classList.add('hidden');
  }
}

function addEndTurnButton() {
  document.getElementById('player-cards').innerHTML = endButtonString;
}

export function updatePlayerData(player, playerId, data) {
  updateStats(player);
  updateInventory(player);
  updatePlayerPosition(player, playerId); 
  addRewards(player);
  addTrashOptions(player);
  replaceCard(player, data['deck']['active']);
  populateCards('player', player['deck']['active'], true);
  if (player['deck']['active'].length == 0) addEndTurnButton();
}
// GAME FUNCTIONS

export function updateGameData(data) {
  populateCards('active', data['deck']['active']);
  populateCards('marketplace', data['marketplace']);
  addCardTriggers();
  addHoverToStats();
  updateLogs(data['last_log']);
}

function updateLogs(history) {
  let logsParent = document.getElementById('logs-parent'),
      log = document.createElement('div');
  log.innerHTML = logLabel(history);
  logsParent.prepend(log);
}

function logLabel(history) {
  switch(history) {
  case 'move':
    return `Player ${history['player_index']} moved to tile ${history['value']}`
  case 'buy_card':
    return `Player ${history['player_index']} acquired ${history['value'].replace(/_/g, ' ')} card`
  case 'coins':
    return `Player ${history['player_index']} gained ${history['value']} coin(s)`
  case 'end_turn':
    return `Player ${history['player_index']} ended their turn`
  case 'dragon_attack':
    return 'Dragon Attacked!'
  case 'redeemed_reward':
    return `Player ${history['player_index']} redeemed a reward`
  case 'move_points':
    return `Player ${history['player_index']} gained ${history['value']} move point(s)`
  case 'health':
    return `Player ${history['player_index']} gained ${history['value']} health`
  case 'start_game':
    return `Started game with ${history['value']} player(s)`
  default:
    return `Player ${history['player_index']} used ${history['type'].replace(/_/g, ' ')} card`
  }
}

export function addError(err) {
  let errElm = document.getElementById('alert-popup')
  errElm.classList.remove('hidden');
  errElm.children[1].innerHTML = err;
}
