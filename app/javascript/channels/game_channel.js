import consumer from "channels/consumer"
import { updatePlayerData, updateGameData, addError } from "channels/game_helpers"

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
    // TODO: game over state
    if (data['error']) {
      // TODO: remove error after some time
      addError(data['error']);
      return;
    }
    let player = data['players'][playerId];
    console.log(`player ${playerId}`, player) 

    updatePlayerData(player, playerId, data);
    updateGameData(data);
  }
});
