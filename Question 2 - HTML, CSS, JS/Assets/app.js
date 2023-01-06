// Call the main function.
main();
// Define the main function.
function main(){
    // Store the HTML drawings of rock, paper and scissor, left facing and right facing.
    const rockSignLeft = '<h>     _______</h><br><h>---\'      ____)</h><br><h>        (_____)</h><br><h>        (_____)</h><br><h>         (____)</h><br><h> ---.__(___)</h>'
    const paperSignLeft = '<h>    _______</h><br><h>---\'     ____)____</h><br><h>               ______)</h><br><h>               _______)</h><br><h>              _______)</h><br><h>---.__________) </h>'
    const scissorsSignLeft = '<h>     _______</h><br><h>---\'      ____)____</h><br><h>                ______)</h><br><h>         __________)</h><br><h>        (____)</h><br><h>---.__(___)</h>'
    const rockSignRight = '<h>  _______</h><br><h> (____      \'---</h><br><h>(_____)      </h><br><h>(_____)      </h><br><h> (____)      </h><br><h>  (___)__.---</h>'
    const paperSignRight = '<h>           _______    </h><br><h>  ____(____      \'---</h><br><h> (______          </h><br><h>(_______          </h><br><h> (_______         </h><br><h>   (__________.---</h>'
    const scissorsSignRight = '<h>           _______    </h><br><h>  ____(____      \'---</h><br><h> (______          </h><br><h>(__________       </h><br><h>           (____)      </h><br><h>            (___)__.---</h>'

    // Get the html elements we'll need.
    const leftSignElem = document.querySelector('.left');
    const rightSignElem = document.querySelector('.right');
    const cumulativeScoreDisplay = document.querySelector('#cumulativeScoreDisplay');
    const inputTxt = document.querySelector('#inputTxt');

    // Init a variable to hold the cumulative scores of each RPS game.
    let cumulativeScore = 0;

    // Trigger the game loop once a file has been procured.
    inputTxt.addEventListener('change', readFile);

    // Define a function who's job is to run a game of RPS (Rock Paper Scissors).
    function readFile(){
        // Open the given file.
        const fileReader = new FileReader();
        // Read and store the file's content.
        fileReader.readAsText(this.files[0]);
        // Once the file has been read, run a function defined here.
        fileReader.onload = function(){
            // Store the file's content in a variable.
            let fileContent = fileReader.result;
            // Split the file at each line.
            fileContent = fileContent.split('\n');
            
            // For each line:
            for (i = 0; i < fileContent.length; i++) {
                // Switch case comparing possible results of the RPS game.
                switch (fileContent[i].slice(0, 3)) {
                    // Each block changes the html sign elements divs to the correct sign, and increases the total score by the appropriate value.
                    case 'A X':
                        leftSignElem.innerHTML = rockSignLeft;
                        rightSignElem.innerHTML = scissorsSignRight;
                        cumulativeScore += 3;
                        break;
                    case 'A Y':
                        leftSignElem.innerHTML = rockSignLeft;
                        rightSignElem.innerHTML = rockSignRight;
                        cumulativeScore += 4;
                        break;
                    case 'A Z':
                        leftSignElem.innerHTML = rockSignLeft;
                        rightSignElem.innerHTML = paperSignRight;
                        cumulativeScore += 8;
                        break;  

                    case 'B X':
                        leftSignElem.innerHTML = paperSignLeft;
                        rightSignElem.innerHTML = rockSignRight;
                        cumulativeScore += 1;
                        break;
                    case 'B Y':
                        leftSignElem.innerHTML = paperSignLeft;
                        rightSignElem.innerHTML = paperSignRight;
                        cumulativeScore += 5;
                        break;
                    case 'B Z':
                        leftSignElem.innerHTML = paperSignLeft;
                        rightSignElem.innerHTML = scissorsSignRight;
                        cumulativeScore += 9;
                        break;

                    case 'C X':
                        leftSignElem.innerHTML = scissorsSignLeft;
                        rightSignElem.innerHTML = paperSignRight;
                        cumulativeScore += 2;
                        break;
                    case 'C Y':
                        leftSignElem.innerHTML = scissorsSignLeft;
                        rightSignElem.innerHTML = scissorsSignRight;
                        cumulativeScore += 6;
                        break;
                    case 'C Z':
                        leftSignElem.innerHTML = scissorsSignLeft;
                        rightSignElem.innerHTML = rockSignRight;
                        cumulativeScore += 7;
                        break;
                    // If none of the case matches, then the file must be wrongly written.
                    default:
                        console.log('The file\'s format is incorrect.');
                }
                // Display the total score.
                cumulativeScoreDisplay.innerHTML = `<h1> score: ${cumulativeScore}</h1>`;
            }
        }

    }
}
