const HTMLLifes = () => {return document.querySelectorAll('.live')};
const HTMLMessageContainer = () => {return document.querySelector('.message')};
const HTMLMessage = () => {return document.querySelector('.message h1')};
const HTMLLMessageBackGround = () => {return document.querySelector('.message-background')};

const render = {
    lives: () => {
        const lastVisibleLife = progress.get().lifes;
        const htmlLifeList = HTMLLifes();
        for(i=htmlLifeList.length; i>lastVisibleLife; i--){
            htmlLifeList[i-1]?.classList.add("lost");
        }
    },
    showMessage: (msg) => {
        HTMLMessage().innerHTML = msg;
        HTMLMessageContainer().classList.remove('hide');
        HTMLLMessageBackGround().classList.remove('hide');
    },
    hideMessage: () => {
        HTMLMessageContainer().classList.add('hide');
        HTMLLMessageBackGround().classList.add('hide');
    },
    gameOver: () => {
        render.showMessage('GAME OVER');
    }

}



