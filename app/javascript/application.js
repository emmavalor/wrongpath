// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
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
  startX = e.clientX;
  cardContainer.classList.add("is-dragging");
  console.log(startX);
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
  }
  else if (diff > threshold) {
    cardContainer.style.transform = `translateX(${diff}px)
                                     rotate(${diff * 0.05}deg)`;
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
  cardContainer.classList.remove("is-dragging");
  cardContainer.style.transform = "rotate(0deg)";
});

document.addEventListener("click", (event) => {
  const expandedContent = event.target.closest(".favs-expanded-content");

  if (!expandedContent) return;

  // Ne pas fermer quand on utilise un lien,
  // un bouton ou le composant Wikipédia.
  if (event.target.closest("a, button, input, summary, details")) return;

  const card = expandedContent.closest(".favs-wallet-details");

  if (card && card.open) {
    card.open = false;
  }
});

// ==========================================
// FAVS - CLOSE CARD ON CONTENT CLICK
// ==========================================

document.addEventListener("click", (event) => {
  const expandedContent = event.target.closest(".favs-expanded-content");

  if (!expandedContent) return;

  if (event.target.closest("a, button, input, summary, select, textarea, label")) {
    return;
  }

  if (event.target.closest(".wiki-details")) {
    return;
  }

  const card = expandedContent.closest(".favs-wallet-details");

  if (card && card.open) {
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

    // Deuxième clic : soumission normale du formulaire
    return;
  }

  // Annuler si clic ailleurs
  document.querySelectorAll(".fav-delete.is-confirming").forEach((button) => {
    button.classList.remove("is-confirming");
    button.setAttribute("aria-label", "Supprimer ce favori");
  });
});
