import consumer from "channels/consumer"
import { endGame } from './utils'
import 'jquery'

window.app = {}
let hrefParts = document.location.href.split("/"),
gameId = hrefParts[5], // Game param
playerId = hrefParts[hrefParts.length - 1], // Player id
gameType = hrefParts[3], // Game type
gameHelpPath;
if (gameType === 'clank') {
  gameHelpPath = "channels/clank_game_helpers";
} else if (gameType === 'aeons_end') {
  gameHelpPath = "channels/aeons_end_game_helpers";
}

window.app.action = consumer.subscriptions.create({ channel: "GameChannel", game_id: gameId }, {
  connected() {
    console.log(`Connected to game: ${gameId}, player: ${playerId}`);
  },

  disconnected() {
    alert('Disconnected from game, please refresh!');
  },

  received(data) {
    if (data['error']) {
      if (data['error'] === 'Not current player' && data['current_player_index'] != Number(playerId)) {
        toastr.error(data['error']);
      }
      if (data['error'] != 'Not current player' && data['current_player_index'] === Number(playerId)) {
        toastr.error(data['error']);
      }
      return
    }
 if (data['end_game']) {
      endGame(data);
      return;
    }
    import(gameHelpPath).then(({ updatePlayerData, updateGameData }) => {
      let player = data['players'][playerId];
      updatePlayerData(player, playerId, data);
      updateGameData(data);
    }).catch(error => {
      console.error("Error loading game helpers:", error);
    });
  }
});
