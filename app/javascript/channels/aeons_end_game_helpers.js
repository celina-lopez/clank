import 'jquery'
import { createCard } from './card_helpers'
import { updateBanner, updateStat } from './utils'
import { updateStatsForPlayer, updateHealthStat } from './player_helpers'

// CARD FUNCTIONS
const rewardParent = document.getElementById('rewards-parent').content,
      rewardTemplate = document.getElementById('rewards-option').content,
      trashOptionOne = document.getElementById('trash-option-1').content,
      trashOptionTwo = document.getElementById('trash-option-2').content,
      rewardContainer = document.getElementById('rewards-id'),
      endTurnElm = document.getElementById('end_turn_button'),
      healthMax = 10,
      statKeys = ['attack_points', 'skill_points'];


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
    playerStatContainer.innerHTML = '';
    updateStatsForPlayer(playerStatContainer, player, statKeys, -1);
    updateStat(playerStatContainer, 'slots', `${player['slots']} / 4`); // TODO: add max slots
    updateHealthStat(playerStatContainer, player, healthMax);
    updateStat(playerStatContainer, 'turn_order', game['current_player_index']);
    updateStat(playerStatContainer, 'gravehold', game['gravehold']);
    updateStat(playerStatContainer, 'monster', game['monster']['health']);
  });
}

function updateBreaches(player) {
  Object.keys(player.breaches).forEach(function(breachNum) {
    let breachElm = document.getElementById(`breach-${breachNum}`);
    if (!breachElm || !player.breaches[breachNum]['item']) { return }
    breachElm.style.backgroundImage = `url('/images/${player.breaches[breachNum]['item']['name']}.png')`;
  })
}


function addRewards(player) {
  if (!player['rewards']) { return }
  rewardContainer.innerHTML = '';
  if (player['rewards'].length > 0) {
    rewardContainer.classList.remove('hidden');
    for (let i = 0; i < player['rewards'].length; i++) {
      let rewardClone = document.importNode(rewardParent, true),
          reward = player['rewards'][i];
      for (let j = 0; j < reward.length; j++) {
        let rewardOption = document.importNode(rewardTemplate, true),
            rewardOptionData = reward[j],
            rewardOptionKeys = Object.keys(rewardOptionData),
            innerText = '';
        for (let k = 0; k < rewardOptionKeys.length; k++) {
          let label = rewardOptionKeys[k];
          if (label == 'discard_number') {
            label = `Discard ${rewardOptionData[rewardOptionKeys[k]]} card(s)`;
          } else if (['health', 'coins', 'attack_points', 'move_points'].includes(label)) {  
            label = `Gain ${rewardOptionData[rewardOptionKeys[k]]} ${Utils.displayName(label.split('_points')[0])}`;
          } else {
            label = Utils.displayName(label)
          }
          innerText += label + '<br/>';
        }
        rewardOption.children[0].innerHTML += innerText
        rewardOption.children[0].setAttribute('data-name', `${i},${j}`);
        rewardClone.children[1].appendChild(rewardOption);
      }
      rewardContainer.appendChild(rewardClone);
    }
  } else {
    rewardContainer.classList.add('hidden');
  }
}


function addTrashOptions(player) {
  if (!player['trash_options']) { return }
  document.getElementById("trash-options-id").innerHTML = '';
  if (player['trash_options'].length > 0) {
    document.getElementById("trash-options-id").classList.remove('hidden');
    for (let i = 0; i < player['trash_options'].length; i++) {
      let trash = player['trash_options'][i];
      if (trash instanceof Object) {
        let trashClone = document.importNode(trashOptionOne, true);
        trashClone.children[1].dataset.name = `${Object.keys(player['trash_options'][i])[0]},active`
        trashClone.children[2].dataset.name = `${Object.keys(player['trash_options'][i])[0]},discarded`
        document.getElementById("trash-options-id").appendChild(trashClone);
      } else {
        let trashClone = document.importNode(trashOptionTwo, true);
        ['active', 'discarded'].forEach(function(type) {
          player['deck'][type].forEach(function(card) {
            let cardParent = createCard(card);
            cardParent.children[0].dataset.type  = 'trash';
            cardParent.children[0].dataset.name = `${card['name']},${type}`;
            trashClone.querySelector(`#${type}-trash-cards`).appendChild(cardParent);
          })
        })
        document.getElementById("trash-options-id").appendChild(trashClone);
      }
    }
  } else {
    document.getElementById("trash-options-id").classList.add('hidden');
  }
}

function addEndTurnButton(isCurrentPlayer) {
  if (!isCurrentPlayer) {
    endTurnElm.classList?.add('hidden');
    return
  }
  endTurnElm.classList?.remove('hidden');
}

export function updatePlayerData(player, playerId, data) {
  // TODO: clean up this later 
  addEndTurnButton(data['current_player_index'] == playerId)
  addRewards(player);
  addTrashOptions(player);
  populateCards('player', player['deck']['active'], true);
  updateBreaches(player);
  updateBanner(data, playerId)
}
// GAME FUNCTIONS

export function updateGameData(data) {
  // TODO: fix inventory images 
  updateStats(data);
  HtmlActions.addHoverCardFunctions()
  // updateLogs(data['latest_logs']);
  // TODO: fix game logs
}
