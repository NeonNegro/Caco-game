const assets = {
    passing : './assets/imgs/passando.gif',
    hiting : './assets/imgs/hiting.gif',
    eating: './assets/imgs/eating.gif',
    normal: './assets/imgs/normal.jpg',
}


const animations = {
    rightAnswer: async () =>{
        document.querySelector('.screen-img').src = assets.passing;
        //document.querySelector(".jungle").style.backgroundImage = `url(${assets.passing})`;
        await delay(500);
        new Audio(`./assets/sounds/rightAnswer.wav`).play();
        await delay(1500);
        document.querySelector('.screen-img').src = assets.normal;
    },
    wrongAnswer: async () => {
        document.querySelector('.screen-img').src = assets.hiting;
        //document.querySelector(".jungle").style.backgroundImage = `url(${assets.hiting})`;
        await delay(1200);
        new Audio(`./assets/sounds/wrongAnswer.wav`).play();
        await delay(1800);
        document.querySelector('.screen-img').src = assets.normal;
    },
    endOfPhase: async () =>{
        document.querySelector('.screen-img').src = assets.eating;
        //document.querySelector(".jungle").style.backgroundImage = `url(${assets.eating})`;
        await delay(500);
        new Audio(`./assets/sounds/eating.wav`).play();
        await delay(3300);
        document.querySelector('.screen-img').src = assets.normal;
    }

}