import consumer from "channels/consumer"
import { updatePlayerData, updateGameData, addError, endGame } from "channels/game_helpers"

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
    if (data['error']) {
      // TODO: remove error after some time
      addError(data['error']);
      return;
    }
    if (data['end_game']) {
      endGame(data);
      return;
    }
    let player = data['players'][playerId];
    updatePlayerData(player, playerId, data);
    updateGameData(data);
  }
});
