window.addEventListener('load', function() {
  console.log("Hello");
  var button = document.getElementById('btn_calculate');
  button.addEventListener('click', function() {
    var speed = document.getElementById('speed');
    speed = speed.value;
    var distance = document.getElementById('distance');
    distance = distance.value;
    var time = document.getElementById('time');
    time = time.value;
    console.log(speed, distance, time);
    var result;
    if ((checkUsage(speed)) && (checkUsage(distance))) {
      result = calculateTime(speed, distance);
    } else if ((checkUsage(speed)) && (checkUsage(time))) {
      result = calculateDistance(speed, time);
    } else if ((checkUsage(distance)) && (checkUsage(time))) {
      result = calculateSpeed(distance, time);
    } else {
      alert("Please enter two values!");
    }
    button.innerText = result;
  });

});

function checkUsage(x) {
  console.log("Checking usage");
  if (x) {
    return true;
  }
}

function calculateTime(s, d) {
  return ((d / s).toFixed(2)).toString() + 's';
}

function calculateSpeed(d, t) {
  return ((d / t).toFixed(2)).toString() + 'm/s';
}

function calculateDistance(s, t) {
  return ((s * t).toFixed(2)).toString() + 'm';
}
