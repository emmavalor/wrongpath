console.log("chat_controller connected")

const chatbox = document.querySelector("#messages")
const button = document.querySelector("#btn-send-chat")
const input_container = document.querySelector("#message_content")

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));


function ajouterMessage_user(texte) {
  const template_user = document.getElementById('user_message');
  const chatContainer = document.getElementById('messages'); // À adapter avec ton conteneur


  const clone = template_user.content.cloneNode(true);
  console.log(clone);

  clone.querySelector('.message-user p').textContent = texte;
  console.log(clone.querySelector('.message-user p'));

  chatContainer.appendChild(clone);
}

function ajouterMessage_assistant(texte) {
  const template_assistant = document.getElementById('assistant_message');
  const chatContainer = document.getElementById('messages'); // À adapter avec ton conteneur

  const clone = template_assistant.content.cloneNode(true);
  clone.querySelector('.message-assistant p').textContent = texte;

  chatContainer.appendChild(clone);
}

async function lancerSequenceMessages() {
  // 1er message affiché immédiatement
  ajouterMessage_user(input_container.value);
  await sleep(200);
  input_container.value = "";
  // Attente de 2 secondes --> 2ème message
  await sleep(1300);
  ajouterMessage_assistant("Très bon choix ! Voyons voir ce qu'on nous cache...");

  // Attente de 2 secondes --> 3ème message
  await sleep(2000);
  ajouterMessage_assistant('Ouverture des archives secrètes.');

  // Attente de 2 secondes --> 4ème message
  await sleep(2000);
  ajouterMessage_assistant('%%#+//%%@$******###');

  // Attente de 2 secondes --> 5ème message
  await sleep(2000);
  ajouterMessage_assistant('обход авторизации');

  await sleep(3000);
  ajouterMessage_assistant('Deleting system32')

  await sleep(3000);
  ajouterMessage_assistant('Retrieving credit card details')

  await sleep(2000);
  ajouterMessage_assistant('Voilà une anecdote intéressante !')

  await sleep(1000);
  ajouterMessage_assistant('Ah non... Omg... pas ça. Nouvellle recherche')

  await sleep(4000);
  ajouterMessage_assistant("Ah, voilà !");
}


button.addEventListener("click", (event) => {
  event.preventDefault
  console.log("button clicked")
  console.log(input_container.value);
  lancerSequenceMessages();
});
