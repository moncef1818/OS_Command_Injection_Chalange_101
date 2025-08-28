document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('pingForm');
    const output = document.getElementById('output');
    const clearBtn = document.getElementById('clearBtn');

    form.addEventListener('submit', function(e) {
        e.preventDefault();

        const target = document.getElementById('target').value.trim();
        if (!target) {
            alert('Please enter an IP address or hostname');
            return;
        }

        // Show loading state
        output.textContent = 'Executing ping command...\n';
        output.classList.add('loading');

        // Send ping request
        fetch('/ping', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'target=' + encodeURIComponent(target)
        })
        .then(response => response.text())
        .then(data => {
            output.classList.remove('loading');
            output.textContent = data;
        })
        .catch(error => {
            output.classList.remove('loading');
            output.textContent = 'Error: ' + error.message;
        });
    });

    clearBtn.addEventListener('click', function() {
        output.textContent = 'Results will appear here...';
    });
});