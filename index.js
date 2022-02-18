const cycles = ['500', '1000', '2000'];

const levels = [
    {
        durIEEs : ['d200e500','d200e450','d200e400'],
    },
    {
        durIEEs : ['d150e400','d150e350','d150e300'],
    },
    {
        durIEEs : ['d100e300','d100e250','d100e200'],
    },
    {
        durIEEs : ['d80e200','d80e150','d80e100'],
    },
    {
        durIEEs : ['d60e100','d60e80','d60e60', 'd60e40', 'd60e20'],
    },
    {
        durIEEs : ['d40e100','d40e80','d40e60', 'd40e40', 'd40e20'],
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


document.querySelector('.equal').addEventListener("click", example, true);


document.querySelector('.equal').addEventListener("mousedown", (e) => {pressButton(e,'down')}, true);
document.querySelector('.equal').addEventListener("mouseup", (e) =>{pressButton(e,'up')}, true);
document.querySelector('.different').addEventListener("mousedown", (e) => {pressButton(e,'down')}, true);
document.querySelector('.different').addEventListener("mouseup", (e) =>{pressButton(e,'up')}, true);


async function example(){
    new Audio(`./assets/sounds/F${cycles[0]}${levels[0].durIEEs[0]}aa.wav`).play();
    await delay(2000);
    new Audio(`./assets/sounds/F${cycles[0]}${levels[0].durIEEs[0]}ag.wav`).play();
}



function delay(time) {
    return new Promise(resolve => setTimeout(resolve, time));
  }



function pressButton(e, direct){
   const children = e.currentTarget.children;
    
     for(let i=0; i<children.length; i++)
        if(direct === 'down') 
            children[i].classList.add('pressed');
        else{
            children[i].classList.remove('pressed');
        }
}