import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  close() {
    this.element.remove();
  }

  closeBackground(event) {
    if (event.target === this.element) {
      this.close();
    }
  }

  stop(event) {
    event.stopPropagation();
  }
}
