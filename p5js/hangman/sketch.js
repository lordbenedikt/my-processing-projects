var germanWords = ["Affe", "Giraffe", "Elefant", "Tiger", "Lokomotive", "Krankenhaus", "Taxi", "Pizza", "Furz", "Streich",
                    "Bart", "Diskussion", "Traum", "Schminken", "Strand", "Igel", "Chirurg", "Facebook", "Verstopfung", "Autounfall", "Verbrecher",
                    "Präsident", "Petze", "Schluckauf", "Detektiv", "Keks", "Scherz", "Perücke", "Schwarzes Schaf", "Flugzeug", "Baby", "Sonnenschein", "Stepptanz",
                    "Windel", "Lotto", "Zehennagel", "Toilette", "Krater", "Dosenöffner", "Skulptur", "Armdrücken", "Magie", "Clown", "Meerjungfrau", "Fette Katze",
                    "Milchmann", "Rockband", "Safari", "Alufolie", "Glasauge", "Ufo", "Donut", "Brainfreeze", "Schlafwandeln", "Chemiker", "Ketchup", "Moonwalk",
                    "Einbrecher", "Nasenhaare", "Spion", "Pirat", "Mundgeruch", "Höhlenmensch", "Das Weiße Haus", "Sensenmann", "Winnie Puh", "Karl der Große"];
var englishWords = ["castle", "princess", "refrigerator", "chair", "supermarket", "dinosaur", "turtle", "chicken", "pencil", "orange", "branch", "alligator",
                    "jellyfish", "bridge", "bone", "grapes", "cloud", "snail", "football"];

var schonGeraten = [];
var fehler = 0;
var gameOver = false;
var wortErraten = false;
var keyboard = false;
var woerter = [];
var language = "english";
var translation = [];
var wort;
var buchstaben = [];
var wordsPositive = [];
var wordIndex = 0;
var timer = 10;

function restart() {
  fehler = 0;
  gameOver = false;
  wortErraten = false;
  arrayClear(schonGeraten);
  schonGeraten.push(' ');
  if(woerter === undefined) {
    return;
  }
  wordIndex = floor(random(woerter.length));
  wort = woerter[wordIndex];
  console.log("word list: " + woerter);
  buchstaben = [];
  for (let i = 0; i<wort.length; i++) {
    buchstaben[i] = wort.charAt(i).toUpperCase();
  }
}

function setup() {
  $.get('words_positive.txt', function(data) {
   let content = data.split(":");
   wordsPositive = content[0].split("\n");
   translation = content[1].split("\n");
   console.log(wordsPositive);
   console.log(translation);
  }, 'text');
	
  createCanvas(1000, 600);
}

function keyTyped() {
  if (document.activeElement === wordInput) return;
  if (keyCode==ENTER) {
    restart();
    return;
  }
  if(wortErraten || gameOver) {
    return;
  }
  let falsch = true;
  for (let i = 0; i<buchstaben.length; i++) {
    if (buchstaben[i]==key.toUpperCase()) {
      schonGeraten.push(key.toUpperCase());
      falsch = false;
    }
  }
  if (falsch) {
    fehler += 1;
    if (fehler>=11) {
      gameOver = true;
    }
  }
}

function draw() {
  if(timer==0) {
	setEnglishWords();
	restart();
	timer = -1;
  } else {
	timer--;
  }
  if(woerter.length === 0) {
    background(255);
    document.body.style.backgroundColor = "white";
    textSize(100);
    textAlign(CENTER, CENTER);
    fill(0);
    strokeWeight(2);
    text("No Words!" ,width/2, height/2);
    return;
  }
  if (gameOver) {
    background(0);
	document.body.style.backgroundColor = "black";
	if(language=="english") {
		fill(255);
		textAlign(LEFT,CENTER);
		text(translation[wordIndex], 100, 50);
	}
  } else if (wortErraten) {
    background(100, 255, 100);
	document.body.style.backgroundColor = "#64FF64";
	if(language=="english") {
		fill(0);
		textAlign(LEFT,CENTER);
		text(translation[wordIndex], 100, 50);
	}  
  } else {
    background(255);
    document.body.style.backgroundColor = "white";
  }
  fill(0);
  strokeWeight(0);
  textSize(80);
  for (let i = 0; i<buchstaben.length; i++) {
    if (buchstaben[i]!=' ') {
      if (gameOver) {
        fill(100);
      } else {
        fill(0);
      }
      text('_', 100 + i*50, 110);
    }
  }
  let erraten = true;
  for (let i = 0; i<buchstaben.length; i++) {
    textSize(40);
    if (schonGeraten.includes(buchstaben[i])) {
      if (gameOver) {
        fill(200);
      } else {
        fill(0);
      }
      text(buchstaben[i], 100 + i*50, 100);
    } else {
      erraten = false;
      if (gameOver) {
        fill(255, 0, 0);
        text(buchstaben[i], 100 + i*50, 100);
      }
    }
  }
  if(erraten) {
    wortErraten = true;
  }
  zeichneGalgenmaennchen();
}

function zeichneGalgenmaennchen() {
  if (wortErraten) {
    strokeWeight(5);
    stroke(0);
    fill(0);
    circle(width/2, 325, 50);
    line(width/2, 350, width/2, 410);
    line(width/2, 360, width/2-70, 330);
    line(width/2, 360, width/2+70, 330);
    line(width/2, 410, width/2-30, 500);
    line(width/2, 410, width/2+30, 500);
    noStroke();
    fill(200);
    circle(width/2-8,320,8);
    circle(width/2+8,320,8);
    arc(width/2,330,20,20,0,PI);
  } else {
    if (gameOver) {
      fill(200);
      stroke(255);
      strokeWeight(5);
    } else {
      fill(0);
      stroke(0);
      strokeWeight(5);
    }

    // Galgen
    if (fehler>=1) {
      line(100, 500, 300, 500);
    }
    if (fehler>=2) {
      line(200, 500, 200, 200);
    }
    if (fehler>=3) {
      line(200, 200, 500, 200);
    }
    if (fehler>=4) {
      line(200, 250, 250, 200);
    }
    if (fehler>=5) {
      line(500, 200, 500, 250);
    }

    // Strichmaennchen
    if (gameOver) {
      stroke(200);
    }
    if (fehler>=6) {
      circle(500, 275, 50);
    }
    if (fehler>=7) {
      line(500, 300, 500, 360);
    }
    if (fehler>=8) {
      line(500, 300, 470, 370);
    }
    if (fehler>=9) {
      line(500, 300, 530, 370);
    }
    if (fehler>=10) {
      line(500, 360, 470, 450);
    }
    if (fehler>=11) {
      line(500, 360, 530, 450);
    }
    if (gameOver) {
      stroke(0);
      strokeWeight(2);
      line(485, 270, 497, 280);
      line(485, 280, 497, 270);
      line(503, 270, 515, 280);
      line(503, 280, 515, 270);
    }
  }
}

function arrayRemove(arr, val) {
  let i = arr.indexOf(val);
  if(i != -1) {
    arr.splice(i, 1);
  }
}

function arrayClear(arr) {
  arr.splice(0, arr.length);
}

// Get the input field
var wordInput = document.getElementById("wordInput");

// Execute a function when the user releases a key on the keyboard
wordInput.addEventListener("keyup", function(event) {
  // Number 13 is the "Enter" key on the keyboard
  if (event.keyCode === 13) {
    // Cancel the default action, if needed
    event.preventDefault();
    // Trigger the button element with a click
    document.getElementById("submitBtn").click();
  }
});

function submit() {
    wordInput.value = wordInput.value.trim();
    if(wordInput.value !== "") {
        let storedWords = localStorage.getItem("words");
        if (storedWords === null) {
            storedWords = ""
        }
        if(!storedWords.split(",").includes(wordInput.value)) {
            localStorage.setItem("words", storedWords + wordInput.value + ",");
        }
    }
    wordInput.value = "";
    setOwnWords();
}

function clearWords() {
    localStorage.clear("words");
	language = "empty";
    setOwnWords();
}

function setEnglishWords() {
    arrayClear(woerter);
    woerter = [...wordsPositive];
	console.log(woerter);
	language = "english";
    restart();
}

function setGermanWords() {
    arrayClear(woerter);
    woerter = [...germanWords];
	language = "german";
    restart();
}

function setOwnWords() {
    arrayClear(woerter);
    let ownWords = localStorage.getItem("words");
    if(ownWords) {
        wordsToBeAdded = ownWords.split(",");
        arrayRemove(wordsToBeAdded, "");
        woerter = wordsToBeAdded;
    }
	language = "ownWords";
    restart();
}