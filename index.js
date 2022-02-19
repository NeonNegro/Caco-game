

//const attempts = [];
// const initial_values = {
    //     totalAttempts : 12,
    //     totalduIEEs: 3,
    //     totalCycles : 3,
    //     totalLevels: 6
    // }
    
    //12 tentativas pra cada durIEE, 12 * 3 
    // AÍ MUDA A FASE
    // depois das 3 fases, folta pra primeira, com um novo nivel
    //
    //ciclo é a última coisa a mudar, e são 3 ciclos
    // const phase_1 = {
        //     answers: [1,0,0,1],
        // }
        // const phase_2 = {
            //     answers: [0,1,2,3],
            // }
            // const phase_3 = {
                //     answers: [0,1,2,3,4,5,6,7],
                // }
                
                
                let expectedAnswer = '';
                
const cycles = {
    TOTAL: 3,
    '500': 1,
    '1000': 2,
    '2000': 3,
    actual: '500',
    getActual: () => {return cycles.actual},
    next: () => {
        let act = cycles[cycles.actual] + 1;
        if (act > cycles.TOTAL)
            act = 1;
        cycles.actual = Object.keys(cycles).find(key => cycles[key] === act);
        return (act === 0) ? 'end' : undefined
    }
};
const lives = {
    TOTAL : 3,
    actual : 3,
    getActual : () => {return lives.actual},
    gain : () =>{(lives.actual < lives.TOTAL) && lives.actual++ },
    loose : () =>{(lives.actual >= 0) && lives.actual-- },
};
const attempts = {
    TOTAL : 12,
    actual : 1,
    getActual: () => {return attempts.actual},
    next: () => { 
        if(attempts.actual === attempts.TOTAL){
            attempts.actual = 1
            return 'end'
        }
        else
            attempts.actual++
    },
};
const phases = {
    TOTAL : 4,
    "Example" : 1,
    "EqOrDiff" : 2,
    "Get2Notes" : 3,
    "Get3Notes": 4,
    actual : 'Example',
    getActual :  () => {return phases[phases.actual]},
    next: () => {
        let act = phases[phases.actual] + 1;
        if (act > phases.TOTAL)
            act = 1;
        phases.actual = Object.keys(phases).find(key => phases[key] === act);
        return (act === 1) ? 'end' : undefined
    },
};
 const levels = {
     TOTAL : 6,
     actual: 1,
     getActual: () => {return levels.actual},
     next: () => { 
        if(levels.actual === levels.TOTAL){
            levels.actual = 1
            return 'end'
        }
        else
            levels.actual++
    },
 };
const durIEEs = {
    getActual : () => {return durIEEs.list[durIEEs.actualLevel()-1].levelList[durIEEs.actualIndex]},
    actualIndex: 0,
    actualLevel : levels.getActual,
    list: 
    [
        {level: 1, levelList: ['D200E500','D200E450','D200E400'],},    
        {level: 2, levelList: ['D150E400','D150E350','d150e300'],},   
        {level: 3, levelList: ['d100e300','d100e250','d100e200'],},  
        {level: 4, levelList: ['D80E200','D80E150','D80E100'],},    
        {level: 5, levelList: ['D60E100','D60E80','D60E60', 'D60E40', 'D60E20'],},    
        {level: 6, levelList: ['D40E100','D40E80','D40E60', 'D40E40', 'D40E20'],},    
    ],
    next: () =>{
        const lv = durIEEs.actualLevel();
        const levelList = durIEEs.list[lv-1].levelList;
        const index = durIEEs.actualIndex;
        if(index === (levelList.length-1)) {
            durIEEs.actualIndex = 0;
            return 'end'
        }
        else
            durIEEs.actualIndex = index + 1;
    }   
};

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
        if(progress.attempt.next() === 'end')
            if(progress.durIEE.next() === 'end')
                if(progress.phase.next() === 'end')
                    if(progress.level.next() === 'end')
                        if(progress.cycle.next() === 'end'){
                            console.log('jogoAcabou');
                            //finishGame();
                        }
    }
}
const possibleAnswers = {
    "different" : 0,
    "equal" : 1,
}

function nextRound()

function action(){
    if (progress.get().phase === phases["Example"]){
        phases.next();
        return showExample();
    }
    
    const sound = generateSound().play();
    
    document.querySelector('.face').removeEventListener("click", action, true);
}


function chooseAnswer(givenAnswer){
    const isRight = (givenAnswer === expectedAnswer);

    if(isRight)
        showRightAnswerAnimation();
    else
        showWrongAnswerAnimation();
}







document.querySelector('.face').addEventListener("click", action, true);

document.querySelector('.equal').addEventListener("click", (e) => {chooseAnswer(possibleAnswers['equal'])}, true);
document.querySelector('.equal').addEventListener("mousedown", (e) => {buttonPress(e,'down')}, true);
document.querySelector('.equal').addEventListener("mouseup", (e) =>{buttonPress(e,'up')}, true);
document.querySelector('.different  ').addEventListener("click", (e) => {chooseAnswer(possibleAnswers['different'])}, true);
document.querySelector('.different').addEventListener("mousedown", (e) => {buttonPress(e,'down')}, true);
document.querySelector('.different').addEventListener("mouseup", (e) =>{buttonPress(e,'up')}, true);


async function showExample(){
    new Audio(`/assets/sounds/bips/F${cycles[0]}${levels.list[0].durIEEs[0]}AA.wav`).play();
    await delay(1500);
    simulateClick('.equal');
    await delay(1500);
    new Audio(`/assets/sounds/bips/F${cycles[0]}${levels.list[0].durIEEs[0]}AG.wav`).play();
    await delay(1500);
    simulateClick('.different');
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

    return new Audio(`/assets/sounds/bips/F${cycles[cycle]}${levels[level].durIEEs[duIEE]}${notes}.wav`);
}



function buttonPress(e, direct){
   const children = e.currentTarget.children;
    
     for(let i=0; i<children.length; i++)
        if(direct === 'down') 
            children[i].classList.add('pressed');
        else
            setTimeout(()=>{children[i].classList.remove('pressed')}, 400);
}


function beginCycle(){
    
}