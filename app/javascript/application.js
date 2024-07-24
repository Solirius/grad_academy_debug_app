import "bootstrap"
import "@hotwired/turbo-rails"

function initializeFormSubmission() {
    const languageSelect = document.getElementById('languageSelect');
  
    languageSelect.addEventListener('change', handleLanguageChange);
}

function handleLanguageChange(event) {
    const languageForm = document.getElementById('languageForm');
    if (languageForm) {
        languageForm.submit();
    }
}

document.addEventListener('DOMContentLoaded', initializeFormSubmission);
document.addEventListener('turbolinks:load', initializeFormSubmission); // For Turbolinks
document.addEventListener('turbo:load', initializeFormSubmission); // For Turbo
