/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-14-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class PokeService {
    private static final String POKE_ENDPOINT = '/api/v2/pokemon/';
    public PokeService() {

    }

    public static Pokemon getPokemon(String pokeIdOrPokeName) {
        return Pokemon.parse(getPokemonJSON(pokeIdOrPokeName));
    }

    public static String getPokemonJSON(String pokeIdOrName) {
        Http httpObject = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:PokeApi' + POKE_ENDPOINT + pokeIdOrName);
        request.setMethod('GET');
        HttpResponse response = httpObject.send(request);
        String responseBody = response.getBody();
        return responseBody;
    }
}