window.addEventListener('load', function() {
  alert("BOO");
  console.log("Hey");

  var button = document.getElementById('btn_calculate');
  button.addEventListener('click', function() {
    var speed = document.getElementById('speed');
    var distance = document.getElementById('distance');
    var time = document.getElementById('time');

    var result;
    if ((checkUsage(speed)) && (checkUsage(distance))) {
      result = calculateTime(speed, distance);
    } else if ((checkUsage(speed)) && (checkUsage(time))) {
      result = calculateDistance(speed, time);
    } else if ((checkUsage(distance)) && (checkUsage(time))) {
      result = calculateSpeed(distance / time);
    } else {
      alert("Please enter two values!");
    }
    button.innerText = result;
  });

});

function checkUsage(x) {
  if (x) {
    return true;
  }
}

function calculateTime(s, d) {
  return d / s + 's';
}

function calculateSpeed(d, t) {
  return d / t + 'm/s';
}

function calculateDistance(s, t) {
  return s * t + 'm';
}
