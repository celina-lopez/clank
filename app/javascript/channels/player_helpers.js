import 'jquery'

// CARD FUNCTIONS
const statTemplate = document.getElementById('stat-template'),
      healthStatTemplate = document.getElementById('health-stat');

export function updateStatsForPlayer(playerStatContainer, player, playerStats, minimumThreshold=0) {
  playerStats.forEach(function(stat) {
    if (player[stat] > minimumThreshold) {
      let statClone = document.importNode(statTemplate.content, true),
          statParent = statClone.children[0],
          actionElm = document.getElementById('template-' + stat),
          actionTemplate = document.importNode(actionElm.content, true).children[0];
      statParent.children[0].appendChild(actionTemplate);
      statParent.children[1].innerHTML = Utils.displayName(stat);
      statParent.children[2].innerHTML = player[stat]; 
      playerStatContainer.appendChild(statClone);
    }
  });
}

export function updateHealthStat(playerStatContainer, player, healthMax) {
    let healthStatClone = document.importNode(healthStatTemplate.content, true),
    statParent = healthStatClone.children[0].children[0],
    heart = statParent.children[0].querySelector('rect'),
    heartStat = statParent.children[1],
    heightStat = (player.health / healthMax) * 100;
    heart.setAttribute('height', `${heightStat}%`);
    heart.setAttribute('y', `${100 - heightStat}%`);
    heartStat.innerHTML = player.health;
    playerStatContainer.appendChild(healthStatClone);
}

