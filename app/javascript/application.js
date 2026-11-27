
 // Configure your import map in config/importmap.rb.
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"



 // Configure your import map in config/importmap.rb.
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"
// import "swipe"

const cardContainer = document.querySelector('.gem-card-wrapper');
const rejectBtn = document.querySelector('.gem-action--reject');
const likeBtn = document.querySelector('.gem-action--like');

let startX;
let diff = 0;

const threshold = 120;

document.addEventListener("pointerdown", (e) => {
  if (!cardContainer || !rejectBtn || !likeBtn) return;

  startX = e.clientX;
  cardContainer.classList.add("is-dragging");
  console.log(startX);
});

document.addEventListener("pointermove", (e) => {
  if (startX === undefined || !cardContainer || !rejectBtn || !likeBtn) return;

  diff = e.clientX - startX;

  if (diff < -threshold) {
    cardContainer.style.transform = `translateX(${diff}px) rotate(${diff * 0.05}deg)`;
    cardContainer.style.transition = "all 0.2s ease";
    rejectBtn.classList.add("reject-active");
    likeBtn.classList.remove("like-active");
  }
  else if (diff > threshold) {
    cardContainer.style.transform = `translateX(${diff}px) rotate(${diff * 0.05}deg)`;
    cardContainer.style.transition = "all 0.2s ease";
    rejectBtn.classList.remove("reject-active");
    likeBtn.classList.add("like-active");
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

  if (!cardContainer) return;

  cardContainer.classList.remove("is-dragging");
  cardContainer.style.transform = "rotate(0deg)";
});


// ==========================================
// FAVS - TOGGLE CARD
// ==========================================

document.addEventListener("click", (event) => {
  const toggleButton = event.target.closest(".wallet-toggle");

  if (!toggleButton) return;

  event.preventDefault();
  event.stopPropagation();

  const card = toggleButton.closest(".favs-wallet-details");

  if (card) {
    card.open = false;
  }
});


// ==========================================
// FAVS - ONLY ONE CARD OPEN AT A TIME
// ==========================================

document.addEventListener("toggle", (event) => {
  const openedCard = event.target;

  if (
    !openedCard.matches(".favs-wallet-details") ||
    !openedCard.open
  ) {
    return;
  }

  document.querySelectorAll(".favs-wallet-details[open]").forEach((card) => {
    if (card !== openedCard) {
      card.open = false;
    }
  });
}, true);


// ==========================================
// FAVS - DELETE CONFIRMATION
// ==========================================

document.addEventListener("click", (event) => {
  const deleteButton = event.target.closest(".fav-delete");

  if (deleteButton) {
    if (!deleteButton.classList.contains("is-confirming")) {
      event.preventDefault();

      document.querySelectorAll(".fav-delete.is-confirming").forEach((button) => {
        button.classList.remove("is-confirming");
      });

      deleteButton.classList.add("is-confirming");
      deleteButton.setAttribute("aria-label", "Confirmer la suppression");

      return;
    }

    // Deuxième clic : soumission normale
    return;
  }

  document.querySelectorAll(".fav-delete.is-confirming").forEach((button) => {
    button.classList.remove("is-confirming");
    button.setAttribute("aria-label", "Supprimer ce favori");
  });
});
