import 'jquery'
import { createCard } from './card_helpers'
import { updateBanner, updateLogs } from './utils'
import { updateStatsForPlayer } from './player_helpers'

// CARD FUNCTIONS
const statKeys = ['victory_points'],
      rewardToStat = {
        trade_card: 'trade_card_points',
        choose_player_to_compare: 'choose_player_to_compare_points',
        choose_player_to_reveal: 'choose_player_to_reveal_card',
        choose_player_to_discard: 'choose_player_to_discard_points',
        choose_player_to_guess: 'choose_player_to_guess_card'
      };


function populateCards(prefix, cards, playerHand=false) {
  document.getElementById(`${prefix}-cards`).innerHTML = ""
  let index = 0;
  cards.forEach(function(card) { 
    let cardParent = createCard(card, playerHand)
    document.querySelector(`#${prefix}-cards`).appendChild(cardParent);
    index += 1;
  })
};

// PLAYER FUNCTIONS 
function updateStats(game) {
  game.players.forEach(function(player) {
    let playerStatContainer = document.getElementById(`player-stats-${player.index}`);
    if (player.removed_from_round) {
      playerStatContainer.children[0].querySelector('img').classList.add('opacity-50')
    } else {
      playerStatContainer.children[0].querySelector('img').classList.remove('opacity-50')
    }
    playerStatContainer.children[0].querySelector('div').innerHTML = player.victory_points || 0
  });
}

function exposeRewards(player) {
  Object.keys(rewardToStat).forEach(function(reward_name) {
    let element = document.getElementById(reward_name);
    if (player[rewardToStat[reward_name]] > 0) {
      element.classList.remove('hidden');
    } else {
      element.classList.add('hidden');
    }
  });
}

function updateCardStatues(game) {
  if (game.data['deck']['discarded'].last) {
    document.getElementById('last_card_played').classList.remove('hidden');
  }
  if (game.data['revealed_card_to_player']) {
    document.getElementById('revealed_card').classList.remove('hidden');
  }
}

export function updatePlayerData(player, playerId, data) {
  populateCards('player', player['deck']['active'], true);
  updateBanner(data, playerId);
  exposeRewards(player);
}
// GAME FUNCTIONS

export function updateGameData(data) {
  updateStats(data);
  updateCardStatues(data);
  HtmlActions.addHoverCardFunctions()
  updateLogs(data['latest_logs']);
}
