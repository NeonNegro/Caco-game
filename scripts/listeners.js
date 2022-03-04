const listeners = {
    disableAll : () => {
        HTMLEqual().removeEventListener("click", playerActions.chooseAnswer, true);
        HTMLDifferent().removeEventListener("click", playerActions.chooseAnswer, true);
        HTMLFace().removeEventListener("click", askForSound, true);
        HTMLEqual().removeEventListener("mousedown", buttonPress, true);
        HTMLEqual().removeEventListener("mouseup", buttonPress, true);
        HTMLDifferent().removeEventListener("mousedown", buttonPress, true);
        HTMLDifferent().removeEventListener("mouseup", buttonPress, true);
    },
    enableChoise : () => {
        HTMLFace().removeEventListener("click", askForSound, true);
        HTMLEqual().addEventListener("click", playerActions.chooseAnswer, true);
        HTMLEqual().givenAnswer = possibleAnswers['equal'];
        HTMLDifferent().addEventListener("click", playerActions.chooseAnswer, true);
        HTMLDifferent().givenAnswer = possibleAnswers['different'];
        HTMLEqual().addEventListener("mousedown", buttonPress, true);
        HTMLEqual().addEventListener("mouseup", buttonPress, true);
        HTMLDifferent().addEventListener("mousedown", buttonPress, true);
        HTMLDifferent().addEventListener("mouseup", buttonPress, true);
    },
    enableRequestBip: () => {
        listeners.disableAll();
        HTMLFace().addEventListener("click", askForSound , true);
    },
    enableHelp: () => {
        HTMLBtHelp().addEventListener("click", showHelp, true);
    }
};


function askForSound(){
    playerActions.requestBip();
    facePress();
}

function showHelp(){
    playerActions.requestHelp();
}