// ==UserScript==
// @name            Generate Timesheets
// @namespace        http://diveintomark.org/projects/greasemonkey/
// @description        un-hide hidden form fields and make them editable
// @include  https://wis.fit.vutbr.cz/FIT/db/hr/person-ep.php*
// @grant none
// ==/UserScript==

//Debug by console.log() in firefox console (ctr-K or in tools for developers)

var lunch_at = getCookie('lunch_at', "13:30")
var rand_shift = getCookie('rand_shift', 60)
var day_starts_at = getCookie('day_starts_at', "09:00")
var lunch_pp = getCookie('lunch_pp', 1)
lunch_duration=30

function mins2time(mins) {
  let h = Math.floor(mins / 60);
  let m = mins % 60;
  h = h < 10 ? '0' + h : h;
  m = m < 10 ? '0' + m : m;
  return `${h}:${m}`;
}

function time2mins(tm) {
  return parseInt(tm)*60+parseInt(tm.substring(3,5));;
}

function update_slider(r, from, to) {
  r.irs.update(cloneInto({from: from, to: to, from_min: 0, from_max: 24*60, to_min: 0, to_max: 24*60}, unsafeWindow));
  unsafeWindow.check_range(r.den, r.pp, r.jqo, from, to);
  //console.log(r.id, r.den, r.pp, r.typ, from, to);
}

function random_offset() {
  return Math.floor(Math.random() * randomness.value - randomness.value/2);

}

function setCookie(cname, cvalue, exdays) {
    var d = new Date();
    d.setTime(d.getTime() + (exdays * 24 * 60 * 60 * 1000));
    var expires = "expires="+d.toUTCString();
    document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
}

function getCookie(cname, default_val) {
    var name = cname + "=";
    var ca = document.cookie.split(';');
    for(var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') {
            c = c.substring(1);
        }
        if (c.indexOf(name) == 0) {
            return c.substring(name.length, c.length);
        }
    }
    return default_val;
}

function generateTimes()
{
  var  irsa =  unsafeWindow.irsa; // irsa[day][slider] are records for each slider
  var balance = []
  
  console.log('irsa:'); console.log(irsa)
  console.log('npp:'); console.log(npp)
  console.log('irsa.length:'); console.log(irsa.length)

  for(var pp = 0; pp < npp; pp ++) balance[pp] = 0;
  var fulfilment_days = [] // remember the last working day for each enployment, when we need to zero the balance
  for (var day = 1; day < irsa.length; day++) for (var r of irsa[day]) {
    if (r.typ == 'W') fulfilment_days[r.pp] = r.den;
  }
  for (var day = 1; day < irsa.length; day++) {
    var from_time = time2mins(start_time.value)+random_offset()
    for(var pp = 0; pp < npp; pp ++) {
      var offset = (fulfilment_days[pp] == day) ? -balance[pp] : random_offset()
      var to_time = from_time+unsafeWindow.whod[pp]+offset
      if (lunch_during.value-1 == pp) to_time += lunch_duration;
      for (var i = 0; i < irsa[day].length; i++) { // find first occurance of employment pp in the day
        var r = irsa[day][i]
        if (r.pp == pp && r.typ == 'W') {
          balance[pp] += offset;
          update_slider(r, from_time, to_time);
          break;                                   // we ignore any other occurances of employment pp in the day
        }
      }
      from_time = to_time;
    }
    for (var i = 0; i < irsa[day].length; i++) { // find the first break for the "lunch_during" employment and set it to lunch time
      var r = irsa[day][i]
      if (r.pp == lunch_during.value-1 && (r.typ == 'O' || r.typ == 'B')) {
        var offset = random_offset()/2;
        update_slider(r, time2mins(lunch_time.value)+offset, time2mins(lunch_time.value)+30+offset)
        break;
      }
    }
  }
  setCookie('lunch_at', lunch_time.value, 1000)
  setCookie('rand_shift', randomness.value, 1000)
  setCookie('day_starts_at', start_time.value, 1000)
  setCookie('lunch_pp', lunch_during.value, 1000)
}


try {
  gui_goes_before  = document.querySelector ("form[name='selyear']").parentNode.parentNode.parentNode.parentNode.parentNode.parentNode;
} catch {
  alert("Timesheets generation script needs to be updated")
  return;
}

npp = unsafeWindow.whod.length; //Highest employment number
//console.log('npp1:'); console.log(unsafeWindow.whod.length)

generate=document.createElement("input");
generate.type="button";

//console.log('npp2:'); console.log(unsafeWindow)
//console.log('npp3:'); console.log(unsafeWindow.whod.length)
npp=1   // HACK: it do not properly fill this variable, so it is fullfiled manually

generate.value="Generate timesheet";
generate.onclick = generateTimes;
start_time=document.createElement("input");
start_time.type="time";
start_time.value=day_starts_at;
lunch_time=document.createElement("input");
lunch_time.type="time";
lunch_time.value=lunch_at;
randomness=document.createElement("input");
randomness.type="number";
randomness.value=rand_shift;
randomness.min=0
randomness.max=120
randomness.style="width:50px"
lunch_during=document.createElement("input");
lunch_during.type="number";
lunch_during.value=lunch_pp;
lunch_during.min=0
lunch_during.max=npp
lunch_during.style="width:30px"

var div  = document.createElement ("div");
div.appendChild(document.createElement("p"));
div.appendChild(generate);
div.appendChild(document.createTextNode('    Start time:'));
div.appendChild(start_time);
div.appendChild(document.createTextNode('    Lunch time:'));
div.appendChild(lunch_time);
div.appendChild(document.createTextNode('    Randomness [mins]:'));
div.appendChild(randomness)
div.appendChild(document.createTextNode('    Lunch during employment:'));
div.appendChild(lunch_during)
div.appendChild(document.createElement("p"));
gui_goes_before.parentNode.insertBefore(div, gui_goes_before);
