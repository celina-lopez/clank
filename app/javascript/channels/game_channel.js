import consumer from "channels/consumer"

window.app = {}
let hrefParts = document.location.href.split("/"),
gameId = hrefParts[4], // Game param
playerId = hrefParts[hrefParts.length - 1]; // Player id

window.app.action = consumer.subscriptions.create({ channel: "GameChannel", game_id: gameId }, {
  connected() {
    console.log(`Connected to game: ${gameId}, player: ${playerId}`);
  },

  disconnected() {
    console.log("disconnected!")
  },

  received(data) {
    let player = data['players'][playerId];
    console.log(`player ${playerId}`, player) 
    let cardTemplate =  document.getElementById('card-template');
    // TODO: fix populate cards function when i get final cards
    function populateCards(prefix, cards, playerHand=false) {
      document.getElementById(`${prefix}-cards`).innerHTML = ""
      let index = 0;
      cards.forEach(function(card) { 
        let clone= document.importNode(cardTemplate.content, true),
          cardParent = clone.children[0],
          cardPopup = cardParent.children[0],
          cardClone = cardParent.children[1];
        cardClone.id =`${prefix}-card-${index}`;
        cardPopup.children[0].src = `/images/${card['name']}.jpeg` 
        cardClone.children[0].src = `/images/${card['name']}.jpeg` 
        cardClone.setAttribute('data-name', card['name']);
        if (playerHand) cardClone.setAttribute('onclick', 'executeCard(this)');
        cardPopup.innerHTML += `${card['name']} <br/>`;
        console.log(card['actions'])
        card['actions'] && card['actions'].forEach(function (action) {
          Object.keys(action).forEach(function(key) {
            let value = action[key];
            cardPopup.innerHTML += `${key}: ${value}`
          });
          // TODO: if another action add or 
        });
        document.querySelector(`#${prefix}-cards`).appendChild(cardParent);
        index += 1;
      })
    };

    function updateStats(player) {
      // TODO: update inventory if needed???
      ['health', 'move_points', 'attack_points', 'clank', 'skill_points'].forEach(function(stat) {
        document.getElementById(stat).innerHTML = player[stat];
      });
    }
    
    if (playerId == data['current_player_index']) {
      populateCards('player', player['deck']['active'], true);
      updateStats(player);
    }
    populateCards('active', data['deck']['active']);
    populateCards('marketplace', data['marketplace']);

    addListeningFunctionsToCards();
    // move player 
    // TODO: test for current player 
    var playerPosition = mapTiles.find((tile) => tile.tile === parseInt(player['position']['current_position']));
    gamePlayers[playerId].setOrigin(playerPosition.frontend_data.x, playerPosition.frontend_data.y);
  }
});
