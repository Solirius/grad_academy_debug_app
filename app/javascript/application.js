import "bootstrap"
import "@hotwired/turbo-rails"

// app/javascript/application.js

document.addEventListener('DOMContentLoaded', function() {
    const languageSelect = document.getElementById('languageSelect');
    const languageForm = document.getElementById('languageForm');
  
    if (languageSelect && languageForm) {
      languageSelect.addEventListener('change', function() {
        // Manually submit the form when the dropdown value changes
        languageForm.submit();
      });
    }
  });
  