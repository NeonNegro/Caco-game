const animations = {
    passing : '../../assets/imgs/passando.gif',
    hiting : '../../assets/imgs/hiting.gif',
}



async function showRightAnswerAnimation(){
    document.querySelector('.screen-img').src = animations.passing;
    document.querySelector(".jungle").style.backgroundImage = `url(${animations.passing})`;
    await delay(500);
    new Audio(`/assets/sounds/rightAnswer.wav`).play();
}
async function showWrongAnswerAnimation(){
    document.querySelector('.screen-img').src = animations.hiting;
    document.querySelector(".jungle").style.backgroundImage = `url(${animations.hiting})`;
    await delay(1200);
    new Audio(`/assets/sounds/wrongAnswer.wav`).play();
}