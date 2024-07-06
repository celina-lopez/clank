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
};

HtmlActions.addHoverCardFunctions = function() {
  document.querySelectorAll('.mini_card').forEach((card) => {
    card.children[0].addEventListener('mouseenter', function () {
      card.querySelector('.hidden_info_card').classList.remove('opacity-0');
      card.querySelector('.hidden_info_card').classList.add('opacity-100');
      card.querySelector('.hidden_info_card').classList.add('delay-500');
      card.querySelector('.hidden_info_card').classList.add('z-10');
    });
    card.children[0].addEventListener('mouseleave', function () {
      card.querySelector('.hidden_info_card').classList.add('opacity-0');
      card.querySelector('.hidden_info_card').classList.remove('opacity-100');
      card.querySelector('.hidden_info_card').classList.remove('delay-500');
      setTimeout(() => {
        if (card.querySelector('.hidden_info_card').classList.contains('opacity-0')) {
          card.querySelector('.hidden_info_card').classList.remove('z-10');
        }
      }, 300);
    });
  });
};

Utils.displayName = function (name) {
  return name.
    replace(/_/g, ' ').
    replace(/(?: |\b)(\w)/g, function(key, _p1) { return key.toUpperCase() });
}

window.HtmlActions = HtmlActions;
window.Game = Game;
window.Utils = Utils;
