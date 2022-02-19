
function delay(time) {
    return new Promise(resolve => setTimeout(resolve, time));
}

async function simulateClick(element){
    let e = document.querySelector(element);
    buttonPress(e, 'down');
    e = document.querySelector(element);
    buttonPress(e, 'up');
}