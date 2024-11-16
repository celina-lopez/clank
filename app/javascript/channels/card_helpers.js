import 'jquery'

// CARD FUNCTIONS
const cardTemplate = document.getElementById('card-template').content;


export function createCardClone(cardClone, card, playerHand=false) {
  let image = cardClone.querySelector('figure').children[0];
  image.src = `/images/${card['name']}.png`;
  image.alt = card['name'];
  if (playerHand) {
    cardClone.dataset.type = card['name'];
  } else {
    cardClone.dataset.type = 'buy_card';
    cardClone.dataset.name = card['name'];
  }
  let container = cardClone.children[1];
  container.querySelector('.card_name').innerHTML = Utils.displayName(card['name'])
  let actionParentElm = container.querySelector('.card_actions_parent');
  if (card['actions']) addPopUpActions(card['actions'], actionParentElm)
  if (card['action']) addPopUpActions(card['action'], actionParentElm)
  if (card['acquire']) {
    actionParentElm.innerHTML += `<div>On Acquire</div>`
    addPopUpActions(card['acquire'], actionParentElm)
  }
  if (card['conditions']) {
    card['conditions'].forEach(function(condition) {
      if (condition['type'] == 'can_buy'){
        actionParentElm.innerHTML += "<div>Can ONLY "
        actionParentElm.innerHTML += card['health'] ? 'attack' : 'buy'
        actionParentElm.innerHTML += ` in ${Utils.displayName(condition['is_in'])}</div>`
      }
    });
  } 
  if (card['victory_points']) {
    addPopUpActions([{'victory_points': card['victory_points']}], actionParentElm)
  }
  if (card.description) {
   actionParentElm.innerHTML += `<div>${card.description}</div>`;
  }
  ['cost', 'health'].forEach(function(key) {
    if (card[key]) {
      let div = document.createElement('div');
      div.classList.add(`bg-${key == 'cost' ? 'sky' : 'red'}-600`, 'px-1', 'rounded-br', 'text-white', 'absolute', 'bottom-0', 'right-0');
      div.innerHTML = card[key];
      container.appendChild(div);
    }
  });
  return cardClone;
};

function addActionElm(parent, action, key){
  let actionElm = document.getElementById('template-' + key);
  if (!!actionElm) {
    let actionTemplate = document.importNode(actionElm.content, true).children[0];
    parent.appendChild(actionTemplate);
  }
  let value = action[key],
      label = Utils.displayName(key.replace(/_points|_options/g, '')),
      description = `${value} ${label}`; 
  if (Number.isInteger(value) && value > 0) description = `+${value} ${label}`;
  if (typeof(value) == 'object') description = `${label} ${Object.keys(value)[0]}`;
  parent.innerHTML += `${description}<br/>`;
}

function addPopUpActions(actions, actionParentElm){
  for (let i = 0; i < actions.length; i++) {
    let action = actions[i];
    Object.keys(action).forEach(function(key) {
      addActionElm(actionParentElm, action, key)
    });
    if (i < actions.length - 1) actionParentElm.innerHTML += '<div>or</div>';
  }
}

export function createCard(card, playerHand=false){
  let clone = document.importNode(cardTemplate, true),
      cardParent = clone.children[0];
  createCardClone(cardParent.children[0], card, playerHand);
  createCardClone(cardParent.children[1].children[0], card, playerHand);
  return cardParent; 
}
