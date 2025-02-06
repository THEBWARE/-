(async () => {
    const targetUrl = "https://github.com/Alveroalexandro56/-/new/main"; // Change this to the website you want to fetch
    const proxyUrl = "https://corsproxy.io/?key=5c0a0b40&url="; // Your API key included

    try {
        const response = await fetch(proxyUrl + encodeURIComponent(targetUrl));
        if (!response.ok) throw new Error(`Error: ${response.status}`);
        
        const html = await response.text();
        console.log("Fetched HTML:", html);
    } catch (error) {
        console.error("Failed to fetch:", error);
    }
})();
