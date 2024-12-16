import 'jquery'
import { createCard } from './card_helpers'
import { updateBanner, updateLogs } from './utils'

// PLAYER FUNCTIONS
const rewardToStat = {
        trade_card: 'trade_card_points',
        choose_player_to_compare: 'choose_player_to_compare_points',
        choose_player_to_reveal: 'choose_player_to_reveal_card',
        choose_player_to_discard: 'choose_player_to_discard_points',
        choose_player_to_guess: 'choose_player_to_guess_card'
      },
      favor_tokens_needed = {
        2: 6,
        3: 5,
        4: 4,
        5: 3,
        6: 3
      };


function populateCards(prefix, cards, playerHand=false) {
  let container = document.getElementById(`${prefix}-cards`)
  container.innerHTML = ""
  cards.forEach(function(card) { 
    let cardParent = createCard(card, playerHand)
    container.appendChild(cardParent);
  });
};

function removeFunctionsFromCards(prefix) {
  let children = document.getElementById(`${prefix}-cards`).children
  for (let i = 0; i < children.length; i++) {
    children[i].classList.add('w-6')
    children[i].children[0].onclick = null;
  }
}

function updateStats(game) {
  game.players.forEach(function(player) {
    let playerStatContainer = document.getElementById(`player-stats-${player.index}`);
    if (player.removed_from_round) {
      playerStatContainer.querySelector('img').classList.add('opacity-50')
    } else {
      playerStatContainer.querySelector('img').classList.remove('opacity-50')
    }
    playerStatContainer.children[1].innerHTML = renderFavorTokens(game, player);
    populateCards(`${player.index}-discarded`, player.deck.discarded)
    removeFunctionsFromCards(`${player.index}-discarded`)
  });
}

function renderFavorTokens(game, player) {
  let favorTokens = '<div>'
  for (let i = 0; i < player.victory_points; i++) {
    favorTokens += '<i class="text-red-600 fa-solid fa-heart"></i>'
  }
  for (let i = 0; i < (favor_tokens_needed[game.players.length] - player.victory_points); i++) {
    favorTokens += '<i class="text-slate-300 fa-solid fa-heart"></i>'
  }
  favorTokens += '</div>'
  return favorTokens
}

function exposeRewards(game, player) {
  Object.keys(rewardToStat).forEach(function(reward_name) {
    let element = document.getElementById(reward_name);
    if (player[rewardToStat[reward_name]] > 0) {
      element.classList.remove('hidden');
      game.players.forEach(function(p) {
        if (p.removed_from_round) {
         document.getElementById(`${reward_name}-${p.index}`).classList.add('hidden');
        }
      })
      setTimeout(function() {
        document.getElementById('rewards_modal').showModal();
      }, 100);
    } else {
      element.classList.add('hidden');
      document.getElementById('rewards_modal').close();
    }
  });
}

export function updatePlayerData(player, playerId, data) {
  populateCards('player', player['deck']['active'], true);
  if (player.keep_card_points) {
    let children = document.getElementById(`player-cards`).children
    for (let i = 0; i < children.length; i++) {
      children[i].children[0].dataset.name = children[i].children[0].dataset.type  
      children[i].children[0].dataset.type = 'keep_card'
    }
  }
  updateBanner(data, playerId);
  exposeRewards(data, player);
  if (player.revealed_card_to_player) {
    document.getElementById('revealed_card').classList.remove('hidden');
    const container = document.getElementById('revealed_card-container');
    container.innerHTML = '<img src="/images/profile-' + player['revealed_card_to_player']['index'] + '.png" class="rounded-full border-gray-400 border-2 rounded h-[75px] w-[75px]"/>';
    container.innerHTML += '<div id="revealed_card-cards"></div>';
    populateCards('revealed_card', [player['revealed_card_to_player']['card']], false);
  }
}
// GAME FUNCTIONS

export function updateGameData(data) {
  updateStats(data);
  HtmlActions.addHoverCardFunctions()
  updateLogs(data['latest_logs']);
}
