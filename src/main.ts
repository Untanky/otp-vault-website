// Set current year in footer
const y = document.getElementById("year");
if (y) y.textContent = new Date().getFullYear().toString();

// Smoothly open details
document.querySelectorAll("details").forEach((details) => {
  const summary = details.querySelector("summary");
  const content = details.querySelector("div");

  if (!summary || !content) {
    return;
  }

  // Ensure initial state
  content.style.overflow = "hidden";
  if (!details.open) {
    content.style.height = "0px";
  }

  summary.addEventListener("click", (e) => {
    e.preventDefault(); // Stop default toggle

    if (!details.open) {
      // OPENING
      details.open = true; // Manually open
      const startHeight = 0;
      const endHeight = content.scrollHeight;

      content.style.height = startHeight + "px";
      requestAnimationFrame(() => {
        content.style.height = endHeight + "px";
      });

      content.addEventListener(
        "transitionend",
        () => {
          content.style.height = "auto"; // Reset to auto
        },
        { once: true }
      );
    } else {
      // CLOSING
      const startHeight = content.scrollHeight;
      content.style.height = startHeight + "px";

      requestAnimationFrame(() => {
        content.style.height = "0px";
      });

      content.addEventListener(
        "transitionend",
        () => {
          details.open = false; // Close after animation
        },
        { once: true }
      );
    }
  });
});

