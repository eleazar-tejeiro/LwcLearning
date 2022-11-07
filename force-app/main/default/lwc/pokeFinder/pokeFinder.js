import { LightningElement } from 'lwc';
import ASH from '@salesforce/resourceUrl/Ash';
import POKEFINDER from '@salesforce/resourceUrl/PokeFinder';
import getPokemon from '@salesforce/apex/PokeFinderController.search';

export default class PokeFinder extends LightningElement {
    queryTerm;
    ash = ASH;
    pokeFinder = POKEFINDER;
    loading = false;
    found = true;
    pokemon;

    handleKeyUp(evt) {
        const isEnterKey = evt.keyCode === 13;

        if (isEnterKey) {
            this.queryTerm = evt.target.value;
            this.loading = !this.loading;

            getPokemon({ pokemonName : this.queryTerm.toLowerCase() })
            .then(response => {
                if( response == 'Not Found') {
                    this.found = false;
                    return;
                }

                this.pokemon = JSON.parse(response);

                delete this.pokemon.moves;
                delete this.pokemon.game_indices;

                this.found = true;
            })
            .catch(err => {
                console.log(err);
                this.pokemon = null;
            })
            .finally(() => this.loading = !this.loading);
        }
    }    
}