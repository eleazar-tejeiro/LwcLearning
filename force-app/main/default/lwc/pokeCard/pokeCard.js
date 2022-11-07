import { LightningElement, api } from 'lwc';
import savePokemon from '@salesforce/apex/PokeCardController.savePokemon';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class PokeCard extends LightningElement {
    @api pokemon;
    hasBeenAdded = false;
    disabled = false;

    get sprite() {
        return this.pokemon?.sprites?.front_default;
    }

    get name() {
        return this.pokemon?.name ? this.pokemon?.name : '???';
    }

    get height() {
        return this.pokemon?.height ? this.pokemon?.height : '???';
    }

    get weight() {
        return this.pokemon?.weight ? this.pokemon?.weight : '???';
    }

    get baseExp() {
        return this.pokemon?.base_experience ? this.pokemon?.base_experience : '???';
    }

    get stats() {
        return this.pokemon?.stats;
    }

    get types() {
        return this.pokemon?.types;
    }

    get noTypes() {
        return this.pokemon?.types.length ? this.pokemon?.types.length : '???' ;
    }

    get stats() {
        return this.pokemon?.stats;
    }

    get noStats() {
        return this.pokemon?.stats.length ? this.pokemon?.stats.length : '???' ;
    }

    get showAddPokemon() {
        if(this.hasBeenAdded) {
            return false;
        }
        return !!this.pokemon ? true : false; 
    }

    handleClick() {
        this.hasBeenAdded = true;
        this.disabled = true;

        savePokemon({ name : this.name , spriteURL : this.sprite, pokeId : this.pokemon.id})
        then( _ => {
            this.showToast();
        })
        .catch(err => {
            this.showToast('Error', err, 'error');
            console.log(err); 
        });
    }

    showToast(title = 'Success', message = 'The Pokamon has been saved', variant = 'success') {
        this.dispatchEvent(
            new ShowToastEvent({
                title,
                message,
                variant,
            })
        );
    }
}