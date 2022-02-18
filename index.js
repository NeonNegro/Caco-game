const cycles = ['500', '1000', '2000'];

const levels = [
    {
        durIEEs : ['D200E500','D200E450','D200E400'],
    },
    {
        durIEEs : ['D150E400','D150E350','d150e300'],
    },
    {
        durIEEs : ['d100e300','d100e250','d100e200'],
    },
    {
        durIEEs : ['D80E200','D80E150','D80E100'],
    },
    {
        durIEEs : ['D60E100','D60E80','D60E60', 'D60E40', 'D60E20'],
    },
    {
        durIEEs : ['D40E100','D40E80','D40E60', 'D40E40', 'D40E20'],
    }
];

let lifes = 3;

const phase_1 = {
    answers: [1,0,0,1],
}
const phase_2 = {
    answers: [0,1,2,3],
}
const phase_3 = {
    answers: [0,1,2,3,4,5,6,7],
}


document.querySelector('.face').addEventListener("click", example, true);


document.querySelector('.equal').addEventListener("mousedown", (e) => {pressButton(e,'down')}, true);
document.querySelector('.equal').addEventListener("mouseup", (e) =>{pressButton(e,'up')}, true);
document.querySelector('.different').addEventListener("mousedown", (e) => {pressButton(e,'down')}, true);
document.querySelector('.different').addEventListener("mouseup", (e) =>{pressButton(e,'up')}, true);


async function example(){
    //new Audio(`/assets/sounds/F${cycles[0]}${levels[0].durIEEs[0]}AA.wav`).play();
    console.log('tocando!');
    await delay(1000);
    simulateClick('.equal');
    await delay(1000);
    //new Audio(`/assets/sounds/F${cycles[0]}${levels[0].durIEEs[0]}AG.wav`).play();
    console.log('tocando!');
    await delay(1000);
    simulateClick('.different');
}




function pressButton(e, direct){
   const children = e.currentTarget.children;
    
     for(let i=0; i<children.length; i++)
        if(direct === 'down') 
            children[i].classList.add('pressed');
        else
            setTimeout(()=>{children[i].classList.remove('pressed')}, 200);
}


function beginCycle(){
    
}