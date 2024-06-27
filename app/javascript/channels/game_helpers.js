
// CARD FUNCTIONS
const cardTemplate = document.getElementById('card-template').content,
      rewardParent = document.getElementById('rewards-parent').content,
      rewardTemplate = document.getElementById('rewards-option').content,
      trashOptionOne = document.getElementById('trash-option-1').content,
      trashOptionTwo = document.getElementById('trash-option-2').content,
      endButtonString = '<button class="btn" onclick="executeAction(this)" data-type="end_turn">End Turn</button>',
      circleTemplate = document.getElementById('circle-template').content,
      rewardContainer = document.getElementById('rewards-id'),
      marketplaceParent = document.getElementById('marketplace-id'),
      gameContainer = document.getElementById('game-container'),
      playerStatContainer = document.getElementById('player-stats'),
      statTemplate = document.getElementById('stat-template').content,
      statKeys = ['attack_points', 'move_points', 'teleport_points', 'skill_points', 'clank', 'health', 'coins'];


function displayName(name) {
  return name.
    replace(/_/g, ' ').
    replace(/(?: |\b)(\w)/g, function(key, _p1) { return key.toUpperCase() });
}

function createCardClone(cardClone, card) {
  let image = cardClone.querySelector('figure').children[0];
  image.src = `/images/${card['name']}.jpeg`;
  image.alt = card['name'];
  let container = cardClone.children[1];
  container.querySelector('.card_name').innerHTML = displayName(card['name'])
  let actionParentElm = container.querySelector('.card_actions_parent');
  if (card['actions']?.length == 1) {
    Object.keys(card['actions'][0]).forEach(function(key) {
      let actionElm = document.getElementById('template-' + key);
      if (!!actionElm) {
        let actionTemplate = document.importNode(actionElm.content, true);
        actionParentElm.appendChild(actionTemplate.children[0]);
        actionParentElm.innerHTML += card['actions'][0][key]; 
      }
    });
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
  let value = action[key];
  if (Number.isInteger(value) && value > 0) value = `+${value}`;
  parent.innerHTML += `${value} ${displayName(key.split('_points')[0])}<br/>`;
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

function createCardPopup(cardParent, card) {
  const cardPopup = cardParent.children[0],
        image = cardPopup.querySelector('figure').children[0],
        cardBody = cardPopup.querySelector('.card-body');
  cardBody.querySelector('h3').innerHTML = displayName(card['name'])
  image.src = `/images/${card['name']}.jpeg` 
  image.alt = card['name'];
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
  return cardParent.querySelector('.hidden_info_card')
                   .children[0]
                   .querySelector('.card-body')
                   .querySelector('.card-actions')
                   .children[0];
};

function createCard(card){
  let clone = document.importNode(cardTemplate, true),
      cardParent = clone.children[0];
  createCardClone(cardParent.children[0], card);
  createCardPopup(cardParent.children[2], card);
  return cardParent; 
}

function createCircle(card) {
  let circleClone = document.importNode(circleTemplate, true),
      circleParent = circleClone.children[0],
      itemParent = circleParent.children[1],
      popUp = circleParent.children[2].children[0];
  itemParent.dataset.name = card['name'];
  itemParent.dataset.type = 'redeem_inventory_item'; 
  itemParent.innerHTML = `<img src='/images/${card['name'].replace(/greater_/g, '')}.jpg' class="rounded-full w-[70px]"/>`
  popUp.children[1].innerHTML = displayName(card['name']);
  popUp.children[2].src = `/images/${card['name'].replace(/greater_/g, '')}.jpg`;
  popUp.children[3].innerHTML = ''
  if (card['action']) addPopUpActions(card['action'], popUp.children[3]);
  if (card['victory_points']) addActionElm(popUp.children[3], card, 'victory_points')
  if (card['description']) popUp.children[4].innerHTML = card['description']
  return circleParent;
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
      cardButton.innerHTML = 'play';
    } else {
      cardButton.dataset.type = 'buy_card';
      cardButton.dataset.name = card['name'];
      cardButton.innerHTML = card['health'] ? 'attack' : 'buy';
    }
    document.querySelector(`#${prefix}-cards`).appendChild(cardParent);
    index += 1;
  })
};

// PLAYER FUNCTIONS
function updateStats(player) {
  playerStatContainer.innerHTML = '';
  statKeys.forEach(function(stat) {
    if (player[stat] > 0) {
      let statClone = document.importNode(statTemplate, true),
          statParent = statClone.children[0],
          actionElm = document.getElementById('template-' + stat),
          actionTemplate = document.importNode(actionElm.content, true).children[0];
      statParent.children[0].appendChild(actionTemplate);
      statParent.children[1].innerHTML = displayName(stat);
      statParent.children[2].innerHTML = player[stat]; 
      playerStatContainer.appendChild(statClone);
    }
  });
}

function updateInventory(player) {
  if (player['inventory']) {
    let inventory = document.getElementById('inventory-id').children[1];
    inventory.innerHTML = "";
    inventory.classList.remove('hidden');
    player['inventory'].forEach(function(item) {
      let itemElement = createCircle(item);
      inventory.appendChild(itemElement);
    });
  }
}

function addRewards(player) {
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
          } else if (label == 'spend_seven_for_two_secret_tomes') {
            label = 'Spend 7 coins for 2 secret tome this turn';
          } else if (['health', 'coins', 'attack_points', 'move_points'].includes(label)) {  
            label = `Gain ${rewardOptionData[rewardOptionKeys[k]]} ${displayName(label.split('_points')[0])}`;
          } else {
            label = displayName(label)
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
  document.getElementById('play_all_cards_button').classList.add('hidden');
}

function addMarketplace(items) {
  marketplaceParent.children[0].classList.remove('hidden');
  marketplaceParent.children[1].innerHTML = '';
  items.forEach(function(item) {
    let itemElement = createCircle(item);
    marketplaceParent.children[1].appendChild(itemElement);
  });
}

export function updatePlayerData(player, playerId, data) {
  updateStats(player);
  updateInventory(player);
  updatePlayerPosition(player, playerId); 
  addRewards(player);
  addTrashOptions(player);
  replaceCard(player, data['deck']['active']);
  populateCards('player', player['deck']['active'], true);
  if (player['deck']['active'].length == 0) {
    addEndTurnButton()
  } else {
    document.getElementById('play_all_cards_button').classList.remove('hidden');
  }
  document.getElementById('infobox').innerHTML = '';
}
// GAME FUNCTIONS

export function updateGameData(data) {
  populateCards('active', data['deck']['active']);
  populateCards('marketplace', data['marketplace']);
  addMarketplace(data['marketplace_items']);
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
  switch(history['type']) {
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
    return `Player ${history['player_index']} used ${displayName(history['type'])} card`
  }
}

export function addError(err) {
  let errElm = document.getElementById('alert-popup')
  errElm.classList.remove('hidden');
  errElm.children[1].innerHTML = err;
}

export function endGame(data){
  gameContainer.innerHTML = '<h1>Game over!</h1>';
  data['players'].sort((a, b) => a['victory_points'] - b['victory_points']).forEach(function(player, index) {
    let playerElm = document.createElement('div');
    playerElm.innerHTML = `Player ${index}: ${player['victory_points']} victory points`;
    if (index == 0) playerElm.innerHTML += ' (Winner)';
    gameContainer.appendChild(playerElm);
  })
}
