// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"
// import "swipe"


const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
const cardContainer = document.querySelector('.gem-card-wrapper');
const rejectBtn = document.querySelector('.gem-action--reject');
const likeBtn = document.querySelector('.gem-action--like');

let startX;
let diff = 0;
let action;

const threshold = 120;

const create_fav = () => {
  fetch("/favs", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Accept": "text/html",
        "X-CSRF-Token": csrfToken
      },
      body: JSON.stringify({
        message_id: cardContainer.dataset.id
      })
    })
      .then(response => {
        if (!response.ok) {
          throw new Error(`Erreur HTTP : ${response.status}`);
        }
        return response.json();
      })
      .then(data => {
        console.log(data.message);
      })
      .catch(error => console.error("Erreur :", error));
}

document.addEventListener("pointerdown", (e) => {
  startX = e.clientX;
  cardContainer.classList.add("is-dragging");
});

document.addEventListener("pointermove", (e) => {
  if (startX === undefined) return;

  diff = e.clientX - startX;

  if (diff < -threshold) {
    cardContainer.style.transform = `translateX(${diff}px)
                                     rotate(${diff * 0.05}deg)`;
    cardContainer.style.transition = "all 0.2s ease";
    rejectBtn.classList.add("reject-active");
    likeBtn.classList.remove("like-active");
    action = "destroy"
  }
  else if (diff > threshold) {
    cardContainer.style.transform = `translateX(${diff}px)
                                     rotate(${diff * 0.05}deg)`;
    cardContainer.style.transition = "all 0.2s ease";
    rejectBtn.classList.remove("reject-active");
    likeBtn.classList.add("like-active");
    action = "create"
  }
  else {
    cardContainer.style.transform = "rotate(0deg)";
    cardContainer.style.transition = "all 0.2s ease";
    rejectBtn.classList.remove("reject-active");
    likeBtn.classList.remove("like-active");
  }
});

document.addEventListener("pointerup", () => {
  startX = undefined;
  cardContainer.classList.remove("is-dragging");
  likeBtn.classList.remove("like-active");
  rejectBtn.classList.remove("reject-active");
  cardContainer.style.transform = "rotate(0deg)";
  if (action === "create") {
    console.log("ici");
    create_fav();
  }
});
