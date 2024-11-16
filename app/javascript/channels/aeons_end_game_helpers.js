import 'jquery'
import { createCard } from './card_helpers'
import { updateBanner } from './utils'

// CARD FUNCTIONS
const rewardParent = document.getElementById('rewards-parent').content,
      rewardTemplate = document.getElementById('rewards-option').content,
      trashOptionOne = document.getElementById('trash-option-1').content,
      trashOptionTwo = document.getElementById('trash-option-2').content,
      rewardContainer = document.getElementById('rewards-id'),
      statTemplate = document.getElementById('stat-template').content,
      healthStatTemplate = document.getElementById('health-stat').content,
      endTurnElm = document.getElementById('end_turn_button'),
      statKeys = ['attack_points', 'turn_order', 'skill_points', 'slots'];


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
    statKeys.forEach(function(stat) {
      if (player[stat] > 0) {
        let statClone = document.importNode(statTemplate, true),
            statParent = statClone.children[0],
            actionElm = document.getElementById('template-' + stat),
            actionTemplate = document.importNode(actionElm.content, true).children[0];
        statParent.children[0].appendChild(actionTemplate);
        statParent.children[1].innerHTML = Utils.displayName(stat);
        statParent.children[2].innerHTML = player[stat]; 
        playerStatContainer.appendChild(statClone);
      }
    });
    let healthStatClone = document.importNode(healthStatTemplate, true),
    statParent = healthStatClone.children[0].children[0],
    heart = statParent.children[0].querySelector('rect'),
    heartStat = statParent.children[1],
    heightStat = (player.health / 10) * 100;
    heart.setAttribute('height', `${heightStat}%`);
    heart.setAttribute('y', `${100 - heightStat}%`);
    heartStat.innerHTML = player.health;
    playerStatContainer.appendChild(healthStatClone);
  });
  let playerStatContainer = document.getElementById(`player-stats-${game.current_player_index}`),
  statClone = document.importNode(statTemplate, true),
      gameStatParent = statClone.children[0],
      actionElm = document.getElementById('template-gravehold'),
      actionTemplate = document.importNode(actionElm.content, true).children[0];
  gameStatParent.children[0].appendChild(actionTemplate);
  gameStatParent.children[1].innerHTML = Utils.displayName('gravehold');
  gameStatParent.children[2].innerHTML = game['gravehold']; 
  playerStatContainer.appendChild(statClone);
  let monsterstatClone = document.importNode(statTemplate, true),
      monstergameStatParent = monsterstatClone.children[0],
      monsteractionElm = document.getElementById('template-monster'),
      monsteractionTemplate = document.importNode(monsteractionElm.content, true).children[0];
  monstergameStatParent.children[0].appendChild(monsteractionTemplate);
  monstergameStatParent.children[1].innerHTML = Utils.displayName('monster');
  monstergameStatParent.children[2].innerHTML = game['monster']['health']; 
  playerStatContainer.appendChild(monsterstatClone);
}

function updateBreaches(player) {
  Object.keys(player.breaches).forEach(function(breachNum) {
    let breachElm = document.getElementById(`breach-${breachNum}`);
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
