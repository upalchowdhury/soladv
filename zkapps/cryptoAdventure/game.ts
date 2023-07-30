class Game {
    storyLine: string[];
    currentStoryIndex: number;
    encryptedMessage: string;
    shift: number;
    answerBox: HTMLInputElement;

    constructor(storyLine: string[], encryptedMessage: string, shift: number, answerBox: HTMLInputElement) {
        this.storyLine = storyLine;
        this.currentStoryIndex = 0;
        this.encryptedMessage = encryptedMessage;
        this.shift = shift;
        this.answerBox = answerBox;
        this.displayCurrentStory();
    }

    displayCurrentStory() {
        document.getElementById('story').innerText = this.storyLine[this.currentStoryIndex];
    }

    static caesarCipherDecrypt(text: string, shift: number): string {
        return text.split('').map(char => {
            let code = char.charCodeAt(0);
            if ((code >= 65 && code <= 90)) {
                return String.fromCharCode(((code - 65 + shift) % 26) + 65);
            } else if ((code >= 97 && code <= 122)) {
                return String.fromCharCode(((code - 97 + shift) % 26) + 97);
            } else {
                return char;
            }
        }).join('');
    }
    
    checkAnswer() {
        let userAnswer = this.answerBox.value;
        if(Game.caesarCipherDecrypt(this.encryptedMessage, this.shift) === userAnswer) {
            document.getElementById('message').innerText = "Congrats, your answer is correct!";
            this.currentStoryIndex++;
            this.displayCurrentStory();
        } else {
            document.getElementById('message').innerText = "Oops, your answer is incorrect. Please try again.";
        }
    }
}

window.onload = () => {
    let answerBox = <HTMLInputElement> document.getElementById('answer');
    let game = new Game(["Welcome to the world of cryptography. Your first task is to decrypt the following message: 'Jgnnq' with a shift of 2. Try to decrypt it and then type your answer."], 'Jgnnq', 2, answerBox);
    document.getElementById('check').addEventListener('click', () => game.checkAnswer());
}
