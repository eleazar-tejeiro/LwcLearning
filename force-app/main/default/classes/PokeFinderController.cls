public with sharing class PokeFinderController {
    public PokeFinderController() {}

    @AuraEnabled
    public static String search(String pokemonName) {
        try {
            return PokeService.getPokemonJSON(pokemonName);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
