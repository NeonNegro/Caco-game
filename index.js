// const initial_values = {
//     totalAttempts : 12,
//     totalduIEEs: (depende do level),
//     totalCycles : 3,
//     totalLevels: 6
// }
// * 12 tentativas pra cada durIEE, 12 * 3 
// * AÍ MUDA A FASE
// * depois das 3 fases, folta pra primeira, com um novo nivel
   
let expectedAnswer = '';
const BIPS_LOCATION = `./assets/sounds/bips/F`;
const HTMLEqual =  () => {return document.querySelector('.equal')};
const HTMLDifferent =  () => {return document.querySelector('.different')};
const HTMLFace = () => {return document.querySelector('.face')};


const progress = {
    get : () => { return( 
        {
            attempt: progress.attempt.getActual(),
            durIEE: progress.durIEE.getActual(),
            phase :progress.phase.getActual(), 
            level :progress.level.getActual(), 
            cycle :progress.cycle.getActual(),
            lifes: progress.lifes.getActual(),
        }
    )},
    cycle : cycles,
    level : levels,
    phase : phases,
    durIEE : durIEEs,
    attempt : attempts,
    lifes: lives,
    mooveOn : () =>{
                if(progress.attempt.next()){
                    if(progress.durIEE.next()){
                        if(progress.phase.next()){
                            if(progress.level.next()){
                                if(progress.cycle.next()){
                                    console.log('jogoAcabou');
                                    //finishGame();
                                }
                            }
                        }
                    }
                }

            // const isEndAttempt = progress.attempt.next();
            //     if(isEndAttempt){
            //         const isEnddurIEE = progress.durIEE.next();
            //         if(isEnddurIEE){
            //             const isEndPhase = progress.phase.next();
            //             animations.endOfPhase();
            //             if(isEndPhase){
            //                 const isEndLevel = progress.level.next();
            //                 if(isEndLevel){
            //                     const isEndCycle = progress.cycle.next();
            //                     if(isEndCycle){
            //                         console.log('jogoAcabou');
            //                         //finishGame();
            //                     }
            //                 }
            //             }
            //         }
            //     }
    }
}
const possibleAnswers = {
    "different" : 0,
    "equal" : 1,
}


const playerActions =  {
    chooseAnswer : (e) => {
        const givenAnswer = e.currentTarget.givenAnswer;

        const isRight = (givenAnswer === expectedAnswer);
    
        if(isRight){
            animations.rightAnswer();
            progress.mooveOn();
        } else {
            animations.wrongAnswer();
            const testGameOver = progress.lifes.loose();

            if(testGameOver === true){
                listeners.disableAll();
                return render.gameOver();
            }
        }
    
        listeners.enableRequestBip();
    },
    requestBip : () => {
        if (progress.get().phase === phases["Example"]){
            progress.phase.next();
            return showExample();
        }
        
        generateSound().play();
        listeners.enableChoise();
    },
}



listeners.enableRequestBip();



async function showExample(){
    listeners.disableAll();
    render.showMessage('Exemplo...');
    new Audio(`${BIPS_LOCATION}${progress.get().cycle}${progress.get().durIEE}AA.wav`).play();
    await delay(1500);
    simulateClick('.equal');
    await delay(1500);
    new Audio(`${BIPS_LOCATION}${progress.get().cycle}${progress.get().durIEE}AG.wav`).play();
    await delay(1500);
    simulateClick('.different');
    listeners.enableRequestBip();
    render.hideMessage();
}

 

function generateSound(){
    const {cycle, level, duIEE} = progress;

    let notes = '';
    for(let i =0; i<2; i++){
        const coinFlip = Math.floor(Math.random() * 2);
        if (coinFlip === 0)
            notes += 'A';
        if (coinFlip === 1)
            notes += 'G';
    }

    expectedAnswer = (notes[0] === notes[1]) ? possibleAnswers['equal'] : possibleAnswers['different'];
    return new Audio(`${BIPS_LOCATION}${progress.get().cycle}${progress.get().durIEE}${notes}.wav`); //return new Audio(`/assets/sounds/bips/F${cycles[cycle]}${levels[level].durIEEs[duIEE]}${notes}.wav`);
}



function buttonPress(e, direct){
    direct = (direct) ? direct : e.type;
    direct = direct.replace('mouse','');
    const children = e.currentTarget ? e.currentTarget.children : e.children;
    for(let i=0; i<children.length; i++)
        if(direct === 'down') 
            children[i].classList.add('pressed');
        else
            setTimeout(()=>{children[i].classList.remove('pressed')}, 400);
}

function facePress(e, direct){
    document.querySelector('.face').classList.add('happy');
    document.querySelector('.face-happy').classList.remove('normal');
    setTimeout(()=>{
        document.querySelector('.face').classList.remove('happy');
        document.querySelector('.face-happy').classList.add('normal');
    }, 750);
}