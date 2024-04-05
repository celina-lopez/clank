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
    console.log(`player ${playerId}`, data['players'][playerId]);
    let cardTemplate =  document.getElementById('card-template');
    // TODO: fix populate cards function when i get final cards
    function populateCards(prefix, cards, playerHand=false) {
      document.getElementById(`${prefix}-cards`).innerHTML = ""
      let index = 0;
      cards.forEach(function(card) { 
        let clone= document.importNode(cardTemplate.content, true),
        cardClone = clone.children[0];
        cardClone.id =`${prefix}-card-${index}`;
        cardClone.setAttribute('data-name', card['name']);
        if (playerHand) cardClone.setAttribute('onclick', 'executeCard(this)');
        cardClone.innerHTML = `${card['name']} <br/> ${JSON.stringify(card['actions'])}`;
        document.querySelector(`#${prefix}-cards`).appendChild(cardClone);
        index += 1;
      })
    };
    populateCards('player', player['deck']['active'], true);
    populateCards('active', data['deck']['active']);
    populateCards('marketplace', data['marketplace']);
  }
});
