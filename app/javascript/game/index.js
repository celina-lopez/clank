var config = {
    type: Phaser.AUTO,
    width: 800,
    height: 600,
    scene: {
        preload: preload,
        create: create
    }
};

var game = new Phaser.Game(config);

function preload() {
    this.load.image('background', 'assets/background.jpg');
    this.load.image('tile', 'assets/tile.png');
    this.load.image('player', 'assets/player.png');
}

function create() {
    this.add.image(0, 0, 'background').setOrigin(0);
    var tiles = this.physics.add.staticGroup();
    for (var i = 0; i < 10; i++) {
        for (var j = 0; j < 10; j++) {
            var tile = tiles.create(i * 80 + 40, j * 60 + 30, 'tile');
        }
    }
    // Add player
    var player = this.physics.add.sprite(40, 30, 'player');
    player.setCollideWorldBounds(true);
}

// Update function
function update() {
    // Handle player movement
    if (cursors.left.isDown) {
        player.setVelocityX(-160);
    } else if (cursors.right.isDown) {
        player.setVelocityX(160);
    } else {
        player.setVelocityX(0);
    }

    if (cursors.up.isDown) {
        player.setVelocityY(-160);
    } else if (cursors.down.isDown) {
        player.setVelocityY(160);
    } else {
        player.setVelocityY(0);
    }
}
