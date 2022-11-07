/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-14-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class PokeCardController {
    @AuraEnabled
    public static void savePokemon(String name, String spriteURL, String pokeId) {
        upsert new Pokemon__c(
            Name = name ,
            SpriteURL__c = spriteURL,
            Poke_Id__c = pokeId
        );
    }
}
