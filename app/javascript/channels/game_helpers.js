
window.app = {}
let hrefParts = document.location.href.split("/"),
gameId = hrefParts[4], // Game param
playerId = hrefParts[hrefParts.length - 1]; // Player id

// CARD FUNCTIONS
function createCardClone(prefix, cardParent, index, card) {
  const cardClone = cardParent.children[1];
  cardClone.id =`${prefix}-card-${index}`;
  cardClone.children[0].innerHTML = card['name'].
    replace(/_/g, ' ').
    replace(/(?: |\b)(\w)/g, function(key, _p1) { return key.toUpperCase() });
  cardClone.children[2].src = `/images/${card['name']}.jpeg` 
  cardClone.setAttribute('data-name', card['name']);
  return cardClone;
};

function createCardPopup(cardParent, card) {
  const cardPopup = cardParent.children[0];
  cardPopup.children[0].src = `/images/${card['name']}.jpeg` 
  cardPopup.innerHTML += `${card['name']} <br/>`;
  card['actions'] && card['actions'].forEach(function (action) {
    Object.keys(action).forEach(function(key) {
      let value = action[key];
      cardPopup.innerHTML += `${key}: ${value}`
    });
    // TODO: if another action add or 
  });
  return cardPopup;
};

export function populateCards(prefix, cards, playerHand=false) {
  let cardTemplate =  document.getElementById('card-template');
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
  // TODO: update inventory if needed???
  ['health', 'move_points', 'attack_points', 'clank', 'skill_points'].forEach(function(stat) {
    document.getElementById(stat).innerHTML = player[stat];
  });
}

export function updatePlayerPosition(player, playerId) {
  var playerPosition = mapTiles.find((tile) => tile.tile === parseInt(player['position']['current_position']));
  gamePlayers[playerId].setOrigin(playerPosition.frontend_data.x, playerPosition.frontend_data.y);
}
