function distance(x1, y1, x2, y2) {
    var dx = x1 - x2
    var dy = y1 - y2
    return Math.sqrt(dx*dx + dy*dy)
}

function chance(probability){
    return Math.floor(Math.random()*probability) === 0;
}
