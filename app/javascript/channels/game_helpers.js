
// CARD FUNCTIONS
function createCardClone(prefix, cardParent, index, card) {
  const walkingIcon = document.getElementById('walking-icon'),
        shieldIcon = document.getElementById('shield-icon');
  const cardClone = cardParent.children[1];
  cardClone.id =`${prefix}-card-${index}`;
  cardClone.children[0].innerHTML = card['name'].
    replace(/_/g, ' ').
    replace(/(?: |\b)(\w)/g, function(key, _p1) { return key.toUpperCase() });
  if (card['actions']?.length == 1) {
    Object.keys(card['actions'][0]).forEach(function(key) {
      if (key == 'move_points') {
        for (let i = 0; i < card['actions'][0][key]; i++) {
          cardClone.children[1].appendChild(document.importNode(walkingIcon.content, true));
        }
      }
      if (key == 'attack_points') {
        for (let i = 0; i < card['actions'][0][key]; i++) {
          cardClone.children[1].appendChild(document.importNode(shieldIcon.content, true));
        }
      }
    });
  }
  cardClone.children[2].src = `/images/${card['name']}.jpeg` 
  if (card['cost']) {
    let costIndicator = document.createElement('div');
    costIndicator.classList.add('bg-sky-600', 'px-1', 'rounded', 'text-white', 'absolute', 'bottom-0', 'right-0');
    costIndicator.innerHTML = card['cost'];
    cardClone.appendChild(costIndicator);
  }
  cardClone.setAttribute('data-name', card['name']);
  return cardClone;
};

function createCardPopup(cardParent, card) {
  const cardPopup = cardParent.children[0];
  cardPopup.children[0].innerHTML = card['name'].
    replace(/_/g, ' ').
    replace(/(?: |\b)(\w)/g, function(key, _p1) { return key.toUpperCase() });

  cardPopup.children[1].src = `/images/${card['name']}.jpeg` 
  cardPopup.innerHTML += `${card['name']} <br/>`;
  if (card['actions']) {
    for (let i = 0; i < card['actions'].length; i++) {
      let action = card['actions'][i];
      Object.keys(action).forEach(function(key) {
        let value = action[key];
        cardPopup.innerHTML += `<div>- ${key}: ${value}</div>`
      });
      if (i < card['actions'].length - 1) cardPopup.innerHTML += '<div>or</div>';
    }
  }
  if (card['acquire']) {
    cardPopup.innerHTML += `<div>On Acquire:</div>`
    for (let i = 0; i < card['acquire'].length; i++) {
      let action = card['acquire'][i];
      Object.keys(action).forEach(function(key) {
        let value = action[key];
        cardPopup.innerHTML += `<div>- ${key}: ${value}</div>`
      });
      if (i < card['acquire'].length - 1) cardPopup.innerHTML += '<div>or</div>';
    }
  }
  if (card['cost']) {
    cardPopup.innerHTML += `<div>Skill points: ${card['cost']} </div>`;
  }
  if (card['health']) {
    cardPopup.innerHTML += `<div>Health: ${card['health']} </div>`;
  }
  return cardPopup;
};

export function populateCards(prefix, cards, playerHand=false) {
  let cardTemplate = document.getElementById('card-template');
  document.getElementById(`${prefix}-cards`).innerHTML = ""
  let index = 0;
  cards.forEach(function(card) { 
    let clone = document.importNode(cardTemplate.content, true),
      cardParent = clone.children[0],
      cardClone = createCardClone(prefix, cardParent, index, card);
    if (playerHand) cardClone.setAttribute('onclick', 'executeCard(this)');
    createCardPopup(cardParent, card)
    document.querySelector(`#${prefix}-cards`).appendChild(cardParent);
    index += 1;
  })
};

// PLAYER FUNCTIONS
export function updateStats(player) {
  ['health', 'move_points', 'attack_points', 'clank', 'skill_points'].forEach(function(stat) {
    document.getElementById(stat).innerHTML = player[stat];
  });
}

export function updateInventory(player) {
  if (player['inventory']) {
    let inventory = document.getElementById('inventory-id');
    inventory.innerHTML = "";
    inventory.classList.remove('hidden');
    player['inventory'].forEach(function(item) {
      let itemElement = document.createElement('img'),
          inventoryName = item['name'].replace(/greater_/g, '');
      itemElement.src = '/images/' + inventoryName + '.jpg';
      itemElement.width = 70;
      itemElement.classList.add('rounded-full');
      inventory.appendChild(itemElement);
    });
  }
}

export function addRewards(player) {
  if (player['rewards'].length > 0) {
    let rewardParent = document.getElementById('rewards-parent').content,
        rewardTemplate = document.getElementById('rewards-option').content;
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
            label = `Gain ${rewardOptionData[rewardOptionKeys[k]]} ${label}`;
          } else {
            label = label.replace(/_/g, ' ');
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

export function updatePlayerPosition(player, playerId) {
  var playerPosition = mapTiles.find((tile) => tile.tile === parseInt(player['position']['current_position']));
  gamePlayers[playerId].setOrigin(playerPosition.frontend_data.x, playerPosition.frontend_data.y);
}

// GAME FUNCTIONS

export function updateLogs(history) {
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
