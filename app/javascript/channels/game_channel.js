import consumer from "channels/consumer"

window.app = {}
let gameId = document.location.href.split("/")[4] // Game param
// let playerId = document.location.href.split("/")[-1] // Player id

window.app.action = consumer.subscriptions.create({ channel: "GameChannel", game_id: gameId }, {
  connected() {
    console.log(`Hello ${gameId}`);
  },

  disconnected() {
    console.log("disconnected")
  },

  received(data) {
    console.log(data)
    document.querySelector("#messages").innerHTML += `<p>${data.message}</p>`;
  }
});
