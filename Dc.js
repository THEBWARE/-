function createInterface() {
    const container = document.createElement('div');
    container.style.position = 'absolute';
    container.style.top = '50%';
    container.style.left = '50%';
    container.style.transform = 'translate(-50%, -50%)';
    container.style.padding = '20px';
    container.style.border = '1px solid #ccc';
    container.style.backgroundColor = '#fff';
    container.style.boxShadow = '0 4px 8px rgba(0, 0, 0, 0.1)';
    container.style.zIndex = '9999';
    container.style.cursor = 'move';

    // Make it draggable
    let offsetX, offsetY, isDragging = false;

    container.addEventListener('mousedown', (e) => {
        isDragging = true;
        offsetX = e.clientX - container.getBoundingClientRect().left;
        offsetY = e.clientY - container.getBoundingClientRect().top;
    });

    document.addEventListener('mousemove', (e) => {
        if (isDragging) {
            container.style.left = `${e.clientX - offsetX}px`;
            container.style.top = `${e.clientY - offsetY}px`;
            container.style.transform = 'none';
        }
    });

    document.addEventListener('mouseup', () => {
        isDragging = false;
    });

    const input = document.createElement('input');
    input.placeholder = 'Enter website URL (e.g., https://example.com)';
    input.style.width = '80%';
    input.style.padding = '10px';
    input.style.marginBottom = '10px';
    input.style.borderRadius = '5px';
    input.style.border = '1px solid #ddd';

    const button = document.createElement('button');
    button.innerText = 'Get HTML Code';
    button.style.padding = '10px 20px';
    button.style.backgroundColor = '#0066cc';
    button.style.color = '#fff';
    button.style.border = 'none';
    button.style.borderRadius = '5px';
    button.style.cursor = 'pointer';

    const message = document.createElement('p');
    message.style.color = 'red';

    const codeDiv = document.createElement('textarea');
    codeDiv.style.marginTop = '20px';
    codeDiv.style.width = '100%';
    codeDiv.style.height = '300px';
    codeDiv.style.border = '1px solid #ddd';
    codeDiv.style.padding = '10px';
    codeDiv.style.backgroundColor = '#f9f9f9';
    codeDiv.style.fontSize = '14px';
    codeDiv.style.resize = 'none';
    codeDiv.readOnly = true;

    const copyButton = document.createElement('button');
    copyButton.innerText = 'Copy to Clipboard';
    copyButton.style.padding = '10px 20px';
    copyButton.style.backgroundColor = '#28a745';
    copyButton.style.color = '#fff';
    copyButton.style.border = 'none';
    copyButton.style.borderRadius = '5px';
    copyButton.style.cursor = 'pointer';
    copyButton.style.marginTop = '10px';

    const disclaimer = document.createElement('p');
    disclaimer.innerText = 'Educational Purposes Only';
    disclaimer.style.color = '#888';
    disclaimer.style.fontSize = '12px';
    disclaimer.style.textAlign = 'center';
    disclaimer.style.marginTop = '10px';

    container.appendChild(input);
    container.appendChild(button);
    container.appendChild(message);
    container.appendChild(codeDiv);
    container.appendChild(copyButton);
    container.appendChild(disclaimer);
    document.body.appendChild(container);

    button.addEventListener('click', async function () {
        const url = input.value;
        if (!url) {
            message.innerText = 'Please enter a URL.';
            return;
        }

        try {
            const response = await fetch(url);
            if (!response.ok) {
                message.innerText = `Failed to fetch the website. Status: ${response.status}`;
                return;
            }

            const html = await response.text();

            if (html.includes("<html")) {
                codeDiv.value = html;
            } else {
                message.innerText = 'The content could not be fetched as HTML.';
            }
        } catch (error) {
            message.innerText = `An error occurred: ${error.message}`;
        }
    });

    copyButton.addEventListener('click', function () {
        codeDiv.select();
        document.execCommand('copy');
        message.innerText = 'HTML code copied to clipboard!';
        message.style.color = 'green';
    });
}

createInterface();
