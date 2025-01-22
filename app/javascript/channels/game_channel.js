import consumer from "channels/consumer"
import { endGame } from 'channels/utils'
import 'jquery'

window.app = {}
let hrefParts = document.location.href.split("/"),
gameId = hrefParts[5],
playerId = hrefParts[hrefParts.length - 1], 
gameType = hrefParts[3],
gameHelpPath = `channels/${gameType}_game_helpers`;

if (gameId != undefined && hrefParts[4] == "games") {
  window.app.action = consumer.subscriptions.create({ channel: "GameChannel", game_id: gameId }, {
    connected() {
      console.log(`Connected to game: ${gameId}, player: ${playerId}`);
    },

    disconnected() {
      document.getElementById('disconnect-alert').classList.remove('hidden');
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
}
