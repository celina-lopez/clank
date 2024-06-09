import consumer from "channels/consumer"
import {
  populateCards,
  updateStats,
  updatePlayerPosition,
  updateInventory,
  addRewards,
  updateLogs
} from "channels/game_helpers"

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

    updateStats(player);
    updateInventory(player);
    updatePlayerPosition(player, playerId);
    addRewards(player);
    populateCards('player', player['deck']['active'], true);

    populateCards('active', data['deck']['active']);
    populateCards('marketplace', data['marketplace']);

    addListeningFunctionsToCards();
    updateLogs(data['last_log']);
  }
});
