const descriptionArray = ['ending', 'market', 'depths', 'health', 'crystal_cave'];
const itemableArray = ['artifact', 'major_item', 'minor_item', 'monkey'];

const Game = {};
const HtmlActions = {};
const Utils = {};

Game.createDescriptionForTile = function(tileData) {
  let description = `Tile Info: ${tileData.tile}\n`;
  tileData.tags && tileData.tags.forEach((tag) => {
    if (itemableArray.includes(tag)) {
      description += `${tileData.items.length} ${tag.replace(/_/g, ' ')}(s)\n`;
    } else if (descriptionArray.includes(tag)) { 
      description += Utils.displayName(tag) + '\n';
    }
  });
  return description;
}

HtmlActions.tabActions = function () {
  const buttons = document.querySelectorAll('.tab');
  const panels = document.querySelectorAll('.panel');
  buttons.forEach(button => {
    button.addEventListener('click', function () {
      const targetPanel = document.querySelector(button.getAttribute('data-target'));
      panels.forEach(function(panel) { panel.classList.add('hidden') });
      buttons.forEach(function(btn) {
        btn.classList.remove('border-b-2', 'border-b-primary');
      });

      targetPanel.classList.remove('hidden');
      button.classList.add('border-b-2', 'border-b-primary');
    });
  });
};

HtmlActions.toggleHiddenInfoCard = function(element) {
  let infoBox = document.getElementById('infobox');
  let parentElm = element.parentElement,
      hiddenInfoCard = parentElm.querySelector('.hidden_info_card');
  infoBox.innerHTML = hiddenInfoCard.innerHTML;
  document.querySelectorAll('.infoselector').forEach(function(card) {
    card.classList.add('invisible');
  });
  parentElm.querySelector('.infoselector').classList.remove('invisible');
};

Utils.displayName = function (name) {
  return name.
    replace(/_/g, ' ').
    replace(/(?: |\b)(\w)/g, function(key, _p1) { return key.toUpperCase() });
}

HtmlActions.addCardTriggers = function() {
  document.querySelectorAll(".trigger-button").forEach(function (button) {
    button.addEventListener("click", function() {
      this.parentElement.querySelector('.modal-card').classList.remove('hidden');
    });
  });

  document.querySelectorAll('.closeButton').forEach(function(button) {
    button.addEventListener('click', function() {
      console.log(this.parentElement.parentElement)
      this.parentElement.parentElement.classList.add('hidden');
    });
  });

  document.querySelectorAll('.modal-card').forEach(function (button) {
    button.addEventListener('click', function (e) {
      if (e.target.classList.contains('modal-card')) {
        e.target.classList.add('hidden');
      }
    });
  });
}

HtmlActions.addHoverToStats = function () {
  document.querySelectorAll('.hover-parent').forEach((card) => {
    card.addEventListener('mouseover', (e) => {
      card.querySelector('.child').classList.remove('invisible');
    });
    card.addEventListener('mouseout', (e) => {
      card.querySelector('.child').classList.add('invisible');
    });
  });
};

window.HtmlActions = HtmlActions;
window.Game = Game;
window.Utils = Utils;
