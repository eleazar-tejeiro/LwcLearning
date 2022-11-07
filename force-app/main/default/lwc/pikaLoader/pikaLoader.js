import { LightningElement } from 'lwc';
import PIKACHU from '@salesforce/resourceUrl/Pikachu';

export default class PikaLoader extends LightningElement {
    pikachu = PIKACHU;
    interval;
    coolPhrases = [
        'Looking for your next best friend . . .',
        'Sending a Pidgey to search in the forest',
        'Is that a Snorlax!?',
        'Almost there',
        'gotta catch \'em all!',
        '"Living is using time given to you. You cannot recall lost time." — NPC',
        '"That’s okay, Brock, you’ll find lots of other girls to reject you!" — Ash',
        '"A Caterpie may change into a Butterfree, but the heart that beats inside remains the same." — Brock',
        '"Don’t you know that love is the most important thing in the whole world?" — Misty'
    ];
    choosenCoolPhrase = 'Pikachu use thunderbolt!';

    connectedCallback() {
        this.interval = setInterval(() => { 
            const rndInt = Math.floor(Math.random() * 9);

            this.choosenCoolPhrase = this.coolPhrases.at(rndInt);
        }, 3500);
    }
}