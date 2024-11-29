import 'jquery'
import { createCard } from './card_helpers'
import { updateBanner, updateLogs } from './utils'
import { updateStatsForPlayer } from './player_helpers'

// CARD FUNCTIONS
const statKeys = ['favors'];


function populateCards(prefix, cards, playerHand=false) {
  document.getElementById(`${prefix}-cards`).innerHTML = ""
  let index = 0;
  cards.forEach(function(card) { 
    let cardParent = createCard(card, playerHand)
    document.querySelector(`#${prefix}-cards`).appendChild(cardParent);
    index += 1;
  })
};

// PLAYER FUNCTIONS - do love tokens here TODO
function updateStats(game) {
  game.players.forEach(function(player) {
    let playerStatContainer = document.getElementById(`player-stats-${player.index}`);
    playerStatContainer.innerHTML = '';
    updateStatsForPlayer(playerStatContainer, player, statKeys);
  });
}

export function updatePlayerData(player, playerId, data) {
  populateCards('player', player['deck']['active'], true);
  updateBanner(data, playerId)
}
// GAME FUNCTIONS

export function updateGameData(data) {
  // updateStats(data);
  HtmlActions.addHoverCardFunctions()
  updateLogs(data['latest_logs']);
}
