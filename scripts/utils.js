
function delay(time) {
    return new Promise(resolve => setTimeout(resolve, time));
}

async function simulateClick(element){
    document.querySelector(element).dispatchEvent(new MouseEvent('mousedown'));
    document.querySelector(element).dispatchEvent(new MouseEvent('mouseup'));
}