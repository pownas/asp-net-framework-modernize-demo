// Site-specific JavaScript

document.addEventListener('DOMContentLoaded', function () {
    // Add any global event listeners or initialization code here

    // Example: Add active class to current navigation link
    const currentLocation = location.pathname;
    const navLinks = document.querySelectorAll('.navbar-nav a');

    navLinks.forEach(link => {
        if (link.getAttribute('href') === currentLocation) {
            link.classList.add('active');
        }
    });
});

// Utility function for form submission
function confirmDelete() {
    return confirm('Are you sure you want to delete this item?');
}
