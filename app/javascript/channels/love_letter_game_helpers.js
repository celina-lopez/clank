import 'jquery'
import { createCard, createCardClone } from 'channels/card_helpers'
import { updateBanner, updateLogs } from 'channels/utils'

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
      },
      circleTemplate = document.getElementById('circle-template').content;


function populateCards(prefix, cards, playerHand=false) {
  let container = document.getElementById(`${prefix}-cards`)
  container.innerHTML = ""
  cards.forEach(function(card) { 
    let cardParent = createCard(card, playerHand)
    container.appendChild(cardParent);
  });
};

function createCircle(card) {
  let circleClone = document.importNode(circleTemplate, true),
      circleParent = circleClone.children[0],
      itemParent = circleParent.children[0],
      popUp = circleParent.children[1].children[0];
  itemParent.innerHTML = `<img src='/images/${card['name']}.png' class="rounded-full w-[50px]"/>`
  createCardClone(popUp, card);
  return circleParent;
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
    let discardedContainer = document.getElementById(`${player.index}-discarded-cards`)
    let discardedLabel = document.getElementById(`discarded-label-${player.index}`)
    discardedLabel.classList.remove('hidden')
    discardedContainer.innerHTML = ''
    player.deck.discarded.forEach(function(item) {
      let itemElement = createCircle(item);
      let itemParent = document.createElement('div')
      itemParent.classList.add('w-6')
      itemParent.appendChild(itemElement)
      discardedContainer.appendChild(itemParent)
    });
  });
}

function renderFavorTokens(game, player) {
  let favorTokens = '<div>'
  for (let i = 0; i < player.victory_points; i++) {
    favorTokens += '<i class="text-red-600 fa-solid fa-heart ml-1"></i>'
  }
  for (let i = 0; i < (favor_tokens_needed[game.players.length] - player.victory_points); i++) {
    favorTokens += '<i class="text-slate-300 fa-solid fa-heart ml-1"></i>'
  }
  favorTokens += '</div>'
  return favorTokens
}

function exposeRewards(game, player) {
  Object.keys(rewardToStat).forEach(function(reward_name) {
    let element = document.getElementById(reward_name);
    if (player[rewardToStat[reward_name]] > 0) {
      element.classList.remove('hidden');
      let activePlayers = 0;
      let activePlayerIndex = null;
      game.players.forEach(function(p) {
        if (p.removed_from_round) {
          const element = document.getElementById(`${reward_name}-${p.index}`)
          if (element) {
            element.classList.add('hidden');
          }
        } else {
          activePlayers++;
          activePlayerIndex = p.index;
        }
      })
      if (activePlayers === 1 && reward_name === 'choose_player_to_guess') {
        document.getElementById('player_to_guess').value = activePlayerIndex;
        let classes = ['border-2', 'border-sky-500', 'rounded-lg', 'p-2']
        document.getElementById(`player_to_guess-${activePlayerIndex}`).classList.add(...classes)
      }
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
    let profileTemplate = document.getElementById(`profile-${player['revealed_card_to_player']['index']}`)
    container.appendChild(profileTemplate)
    container.innerHTML += '<div id="revealed_card-cards"></div>';
    populateCards('revealed_card', [player['revealed_card_to_player']['card']]);
  } else {
    document.getElementById('revealed_card').classList.add('hidden');
  }
}
// GAME FUNCTIONS

export function updateGameData(data) {
  updateStats(data);
  HtmlActions.addHoverCardFunctions()
  updateLogs(data['latest_logs']);
}
