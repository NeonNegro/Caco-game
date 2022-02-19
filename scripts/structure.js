                
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
    loose : () =>{
        lives.actual--;
        render.lives();
        if(lives.actual < 0 )
            return true;
    },
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