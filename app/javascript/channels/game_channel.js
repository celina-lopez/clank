import consumer from "./consumer"

consumer.subscriptions.create("GameChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("Connected to the chat room!");
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
    console.log("Disconnected from the chat room!");
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log("Received:", data);
  },

  send(data) {
    // Send data to the server
    this.perform('receive', data);
  }
});

