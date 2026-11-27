
import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="swipe"
export default class extends Controller {
  connect() {
    this.csrfToken = document.querySelector('meta[name="csrf-token"]')?.content;

    this.cardContainer = document.querySelector(".gem-card-wrapper");
    this.rejectBtn = document.querySelector(".gem-action--reject");
    this.likeBtn = document.querySelector(".gem-action--like");

    this.startX = null;
    this.diff = 0;
    this.action = null;
    this.threshold = 120;

    this.isDragging = false;

    this.boundPointerDown = this.cardSelect.bind(this);
    this.boundPointerMove = this.cardMove.bind(this);
    this.boundPointerUp = this.cardDrop.bind(this);

    document.addEventListener("pointerdown", this.boundPointerDown);
    document.addEventListener("pointermove", this.boundPointerMove);
    document.addEventListener("pointerup", this.boundPointerUp);
    document.addEventListener("pointercancel", this.boundPointerUp);
  }

  disconnect() {
    document.removeEventListener("pointerdown", this.boundPointerDown);
    document.removeEventListener("pointermove", this.boundPointerMove);
    document.removeEventListener("pointerup", this.boundPointerUp);
    document.removeEventListener("pointercancel", this.boundPointerUp);
  }

  cardSelect(e) {
    if (!this.cardContainer || !this.cardContainer.contains(e.target)) return;

    this.startX = e.clientX;
    this.diff = 0;
    this.action = null;
    this.isDragging = true;

    this.cardContainer.classList.add("is-dragging");
  }

  cardMove(e) {
    if (!this.isDragging || this.startX === null) return;

    this.diff = e.clientX - this.startX;

    if (this.diff < -this.threshold) {
      this.leftSwipe();
      this.action = "destroy";
    } else if (this.diff > this.threshold) {
      this.rightSwipe();
      this.action = "create";
    } else {
      this.action = null;

      this.cardContainer.style.transform = `translateX(${this.diff}px) rotate(${this.diff * 0.05}deg)`;
      this.cardContainer.style.transition = "none";

      this.rejectBtn?.classList.remove("reject-active");
      this.likeBtn?.classList.remove("like-active");
    }
  }

  async cardDrop() {
    if (!this.isDragging) return;

    this.isDragging = false;
    this.startX = null;

    this.cardContainer.classList.remove("is-dragging");

    this.likeBtn?.classList.remove("like-active");
    this.rejectBtn?.classList.remove("reject-active");

    const action = this.action;
    this.action = null;

    if (action === "create") {
      try {
        await this.createFav();
      } catch (error) {
        console.error("Erreur lors de l'ajout aux favoris :", error);
        this.resetCard();
      }
    } else if (action === "destroy") {
      this.resetCard();
      // Ajouter ici la requête DELETE si nécessaire.
    } else {
      this.resetCard();
    }

    
  }

  rightSwipe() {
    this.cardContainer.style.transform = `translateX(${this.diff}px) rotate(${this.diff * 0.05}deg)`;
    this.cardContainer.style.transition = "none";

    this.rejectBtn?.classList.remove("reject-active");
    this.likeBtn?.classList.add("like-active");
  }

  leftSwipe() {
    this.cardContainer.style.transform = `translateX(${this.diff}px) rotate(${this.diff * 0.05}deg)`;
    this.cardContainer.style.transition = "none";

    this.rejectBtn?.classList.add("reject-active");
    this.likeBtn?.classList.remove("like-active");
  }

  resetCard() {
    this.cardContainer.style.transition = "transform 0.3s ease";
    this.cardContainer.style.transform = "translateX(0) rotate(0deg)";
  }


async createFav() {
  const response = await fetch("/favs", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "X-CSRF-Token": this.csrfToken
    },
    body: JSON.stringify({
      message_id: this.cardContainer.dataset.id
    })
  });

  const data = await response.json();

  if (!response.ok) {
    throw new Error(data.errors?.join(", ") || "Erreur lors de l'ajout du favori");
  }

  window.location.href = data.redirect_url;
}

}
