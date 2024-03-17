import consumer from "channels/consumer"

window.app = {}
let params = new URLSearchParams(document.location.search);
let gameId = params.get("game_id"); // is the string "Jonathan"

window.app.action = consumer.subscriptions.create({ channel: "GameChannel", game_id: gameId }, {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log(`Hello ${gameId}`);
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log(data)
    document.querySelector("#messages").innerHTML += `<p>${data.message}</p>`;
  }
});
