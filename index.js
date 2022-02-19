const cycles = ['500', '1000', '2000'];  // SO MUDA DEPOIS DE UM BOM TEMPO...


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
    
    
const possibleAnswers = {
    "different" : 0,
    "equal" : 1,
}

const phasesList = {
    "Example" : 0,
    "EqOrDiff" : 1,
    "Get2Notes" : 2,
    "Get3Notes": 3,
    actual : 'Example',
    getActual :  () => {return phasesList[phasesList.actual]},
    next: () => {
        let act = phasesList[phasesList.actual] + 1;
        if (act === Object.keys(phasesList).length) 
            act = 0;
        phasesList.actual = Object.keys(phasesList).find(key => phasesList[key] === act);
    },
}

const levels = [
    { durIEEs : ['D200E500','D200E450','D200E400'] },
    { durIEEs : ['D150E400','D150E350','d150e300'] },
    { durIEEs : ['d100e300','d100e250','d100e200'] },
    { durIEEs : ['D80E200','D80E150','D80E100'] },
    { durIEEs : ['D60E100','D60E80','D60E60', 'D60E40', 'D60E20'] },
    { durIEEs : ['D40E100','D40E80','D40E60', 'D40E40', 'D40E20'] },
];
 
const progress = {
    cycle : 0,
    level : 0,
    phase : phasesList.getActual,
    duIEE : 0,
    attempt : 0,
    lifes: 3,
}


function action(){
    if (progress.phase() === phasesList["Example"]){
        phasesList.next();
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
    new Audio(`/assets/sounds/bips/F${cycles[0]}${levels[0].durIEEs[0]}AA.wav`).play();
    await delay(1500);
    simulateClick('.equal');
    await delay(1500);
    new Audio(`/assets/sounds/bips/F${cycles[0]}${levels[0].durIEEs[0]}AG.wav`).play();
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