import { LightningElement, track, wire, api } from 'lwc';
// import getSitePrefixes from '@salesforce/apex/userConfig.getSitePrefixes';
import getSites from '@salesforce/apex/userConfig.getSites';
import saveSecureUrl from '@salesforce/apex/userConfig.saveSecureUrl';
// import { updateRecord } from 'lightning/uiRecordApi';

export default class Qf_guide2 extends LightningElement {

    @track isModalOpen = false;
    @track issiteModelopen = false;
    @track sites;
    @api selectedSite;
    siteOptions = [];
    error_toast = true;
    // @api siteId;

    connectedCallback(){
        getSites()
        .then(result => {
            console.log("result : "+JSON.stringify(result));
           
            // this.sites = result[0].Name; 
            this.sites = result.map(result1 => {
                            return { label: result1.MasterLabel, value: result1.Id};
                        });
            // console.log(JSON.stringify(result));
            // this.sites.unshift({ label: '-- Select Site --', value: '' });
        })
        .catch(error => {
            console.error(error);
        });
    }

    // Handle the button click event
    handleSave() {
        console.log('enter');
        console.log(this.selectedSite);
        if (this.selectedSite) {
            console.log('inside if : '+this.selectedSite);
            saveSecureUrl({selectedSiteid : this.selectedSite})
            .then( result => {
                console.log("result : "+JSON.stringify(result));
                this.error_toast = true;
                this.template.querySelector('c-toast-component').showToast('success', 'Successfully Saved', 3000);
            })
            .catch(error => {
                console.error(error);
                this.error_toast = true;
                this.template.querySelector('c-toast-component').showToast('success', 'Uh oh, something went wrong', 3000);
            });
            // console.log(this.sites);
            // getSites().then(sites => {
            //     console.log(selectedSite);
            //     const selectedSite = sites.find(site => site.Id === this.selectedSite);
            //     if (selectedSite) {
            //         saveSecureUrl({ siteId: selectedSite.Id, secureUrl: selectedSite.SecureUrl }).then(() => {
            //             console.log('SecureUrl saved successfully');
            //             // Show a success message or perform other actions
            //         }).catch(error => {
            //             console.error(error);
            //         });
            //     }
            // }).catch(error => {
            //     console.error(error);
            // });
        }

        // console.log(selectedOption);
        // // Search for the selected site in the options array
        // let selectedOption = this.sites.find(option => option.value === this.sites);

        // // Get the SecureUrl value for the selected site
        // this.secureUrl = selectedOption.secureUrl;

        // // Save the SecureUrl value to the custom setting using LDS
        // const recordInput = { fields: {SiteUrl__c: this.secureUrl } };
        // updateRecord({ recordInput, recordId: 'Site_Details__c' })
        //     .then(() => {
        //         // Display a success message
        //         console.log('SecureUrl saved successfully');
        //     })
        //     .catch(error => {
        //         // Display an error message
        //         console.error(error);
        //     });
    }

    handleSiteChange(event) {
        this.selectedSite = event.detail.value;
        console.log(this.selectedSite);
    }

    renderedCallback(){
        this.template.querySelectorAll("a").forEach(element => {
            element.addEventListener("click", evt=>{
                let target = evt.currentTarget.dataset.tabId;

                this.template.querySelectorAll("a").forEach(tabel =>{
                    if(tabel === element){
                        tabel.classList.add("active-tab");
                    }
                    else{
                        tabel.classList.remove("active-tab");
                    }
                });
                this.template.querySelectorAll(".tab").forEach(tabdata=>{
                    tabdata.classList.remove("active-tab-content");
                });
                this.template.querySelector('[data-id="'+target+'"]').classList.add("active-tab-content");
            });
        });
    }

    // siteOptions = [
    //     { label: 'Option 1', value: 'option1' },
    //     { label: 'Option 2', value: 'option2' },
    //     { label: 'Option 3', value: 'option3' },
    // ];

    // @wire(getSitePrefixes)
    // wiredSitePrefixes({ error, data }) {
    //     if (data) {
    //         console.log(sitePrefix);
    //         this.siteOptions = data.map(sitePrefix => {
    //             return { label: sitePrefix, value: sitePrefix};
    //         });
    //     } else if (error) {
    //         console.error(error);
    //     }
    // }

    closesiteModel() {
        this.isModalOpen = false;

        const target = "tab1";
        this.template.querySelectorAll("a").forEach(tabel => {
        tabel.classList.remove("active-tab");
        });
        this.template.querySelectorAll(".tab").forEach(tabdata => {
        tabdata.classList.remove("active-tab-content");
        });
        this.template.querySelector('[data-tab-id="' + target + '"]').classList.add("active-tab");
        this.template.querySelector('[data-id="' + target + '"]').classList.add("active-tab-content");
    }

    openModel() {
        this.isModalOpen = true;
    }

    openCreateEditModel() {
        this.issiteModelopen = true;
    }

    closeModel() {
        this.issiteModelopen = false;

        const target = "tab1";
        this.template.querySelectorAll("a").forEach(tabel => {
        tabel.classList.remove("active-tab");
        });
        this.template.querySelectorAll(".tab").forEach(tabdata => {
        tabdata.classList.remove("active-tab-content");
        });
        this.template.querySelector('[data-tab-id="' + target + '"]').classList.add("active-tab");
        this.template.querySelector('[data-id="' + target + '"]').classList.add("active-tab-content");
    }

    opensite() {
        try {
        const baseUrl = window.location.origin + '/lightning/setup/CustomDomain/home';
        window.open(baseUrl, '_blank');
        } catch (error) {
        console.error(error);
        }
    }
    tabing(){
        const target = "tab1";
        this.template.querySelectorAll("a").forEach(tabel => {
        tabel.classList.remove("active-tab");
        });
        this.template.querySelectorAll(".tab").forEach(tabdata => {
        tabdata.classList.remove("active-tab-content");
        });
        this.template.querySelector('[data-tab-id="' + target + '"]').classList.add("active-tab");
        this.template.querySelector('[data-id="' + target + '"]').classList.add("active-tab-content");
    }
}