/**
 * An apex class that updates portal user details.
   Guest users are never able to access this page.
 */
public with sharing class MyProfilePageController {

    private User user;
    private boolean isEdit = false;

    public User getUser() {
        return user;
    }

    public MyProfilePageController() {
        if (Schema.SObjectType.User.fields.city.IsAccessible() && Schema.SObjectType.User.fields.communitynickname.IsAccessible() && Schema.SObjectType.Contact.fields.email.isAccessible() && Schema.SObjectType.User.fields.country.IsAccessible() && Schema.SObjectType.User.fields.email.IsAccessible() && Schema.SObjectType.User.fields.extension.IsAccessible() && Schema.SObjectType.User.fields.firstname.IsAccessible() && Schema.SObjectType.User.fields.languagelocalekey.IsAccessible() && Schema.SObjectType.User.fields.lastname.IsAccessible() && Schema.SObjectType.User.fields.localesidkey.IsAccessible() && Schema.SObjectType.User.fields.mobilephone.IsAccessible() && Schema.SObjectType.User.fields.phone.IsAccessible() && Schema.SObjectType.User.fields.postalcode.IsAccessible() && Schema.SObjectType.User.fields.state.IsAccessible() && Schema.SObjectType.User.fields.street.IsAccessible() && Schema.SObjectType.User.fields.timezonesidkey.IsAccessible() && Schema.SObjectType.User.fields.title.IsAccessible() && Schema.SObjectType.User.fields.username.IsAccessible()){

            user = [SELECT id, email, username, usertype, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                street, city, country, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email
                FROM User
                WHERE id = :UserInfo.getUserId()];
        }
                // guest users should never be able to access this page
        if (user.usertype == 'GUEST') {
            throw new NoAccessException();
        }
    }

    public Boolean getIsEdit() {
        return isEdit;
    }

    public void edit() {
        isEdit=true;
    }

    public void save() {
        try {
            if (Schema.SObjectType.User.fields.city.IsUpdateable() && Schema.SObjectType.User.fields.communitynickname.IsUpdateable() && Schema.SObjectType.Contact.fields.email.IsUpdateable() && Schema.SObjectType.User.fields.country.IsUpdateable() && Schema.SObjectType.User.fields.email.IsUpdateable() && Schema.SObjectType.User.fields.extension.IsUpdateable() && Schema.SObjectType.User.fields.firstname.IsUpdateable() && Schema.SObjectType.User.fields.languagelocalekey.IsUpdateable() && Schema.SObjectType.User.fields.lastname.IsUpdateable() && Schema.SObjectType.User.fields.localesidkey.IsUpdateable() && Schema.SObjectType.User.fields.mobilephone.IsUpdateable() && Schema.SObjectType.User.fields.phone.IsUpdateable() && Schema.SObjectType.User.fields.postalcode.IsUpdateable() && Schema.SObjectType.User.fields.state.IsUpdateable() && Schema.SObjectType.User.fields.street.IsUpdateable() && Schema.SObjectType.User.fields.timezonesidkey.IsUpdateable() && Schema.SObjectType.User.fields.title.IsUpdateable() && Schema.SObjectType.User.fields.username.IsUpdateable()){
                update user;
            }
            isEdit=false;
        } catch(DmlException e) {
            ApexPages.addMessages(e);
        }
    }

    public PageReference changePassword() {
        return Page.ChangePassword;
    }

    public void cancel() {
        isEdit=false;
        if (Schema.SObjectType.User.fields.city.IsAccessible() && Schema.SObjectType.User.fields.communitynickname.IsAccessible() && Schema.SObjectType.Contact.fields.email.IsAccessible() && Schema.SObjectType.User.fields.country.IsAccessible() && Schema.SObjectType.User.fields.email.IsAccessible() && Schema.SObjectType.User.fields.extension.IsAccessible() && Schema.SObjectType.User.fields.firstname.IsAccessible() && Schema.SObjectType.User.fields.languagelocalekey.IsAccessible() && Schema.SObjectType.User.fields.lastname.IsAccessible() && Schema.SObjectType.User.fields.localesidkey.IsAccessible() && Schema.SObjectType.User.fields.mobilephone.IsAccessible() && Schema.SObjectType.User.fields.phone.IsAccessible() && Schema.SObjectType.User.fields.postalcode.IsAccessible() && Schema.SObjectType.User.fields.state.IsAccessible() && Schema.SObjectType.User.fields.street.IsAccessible() && Schema.SObjectType.User.fields.timezonesidkey.IsAccessible() && Schema.SObjectType.User.fields.title.IsAccessible() && Schema.SObjectType.User.fields.username.IsAccessible()){
            user = [SELECT id, email, username, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
            street, city, country, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email
            FROM User
            WHERE id = :UserInfo.getUserId()];
        }
    }    
}