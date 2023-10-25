import { LightningElement, track, wire } from 'lwc';
import getSites from '@salesforce/apex/qf_guide2_Controller.getSites';
import getSettingData from '@salesforce/apex/qf_guide2_Controller.getSettingData';
import saveSecureUrl from '@salesforce/apex/qf_guide2_Controller.saveSecureUrl';
import assignPermissionSet from '@salesforce/apex/qf_guide2_Controller.assignPermissionSet';
import { CurrentPageReference } from 'lightning/navigation';
import QuickBotLogo from '@salesforce/resourceUrl/QuickBotLogo';

export default class Qf_guide2 extends LightningElement {
Logo = QuickBotLogo;
  @track isModalOpen = false;
  @track issiteModelopen = false;
  @track sites = [];
  @track selectedSite;
  @track preselectedSiteName = '';
  @track selectedSiteName = '';
  @track spinnerdatatable = false;
  error_toast = true;
  @track message;
  @track sharingrulemodal = false;
@track showquickbot = false;
  @wire(CurrentPageReference) pageRef;

  connectedCallback() {
    this.spinnerdatatable = true;
    this.getSiteDetails();
  }

  renderedCallback() {
    try {
      this.template.querySelectorAll("a").forEach(element => {
        element.addEventListener("click", evt => {
          let target = evt.currentTarget.dataset.tabId;
          this.template.querySelectorAll("a").forEach(tabel => {
            if (tabel === element) {
              tabel.classList.add("active-tab");
            } else {
              tabel.classList.remove("active-tab");
            }
          });
          this.template.querySelectorAll(".tab").forEach(tabdata => {
            tabdata.classList.remove("active-tab-content");
          });
          this.template.querySelector('[data-id="' + target + '"]').classList.add("active-tab-content");
        });
      });
    } catch (error) {
      console.log('QF INFO:- Renderedcallback QFGuide');
    }
  }

  getSiteDetails() {
    try {
      getSites()
        .then(result => {
          var tempSite = [];
          result.forEach(siteval => {
            tempSite.push({
              label: siteval.MasterLabel,
              value: siteval.Id,
              guestuserId: siteval.GuestUserId
            });
          });
          this.sites = tempSite;
          this.getSettinsDataValue();
        }).catch(() => {
          this.spinnerdatatable = false;
          this.message = 'Something went wrong in Get Site Details';
          this.showerrorpopup();
        });
    } catch (error) {
      console.log('QF INFO:- GetSiteDetails QFGuide');
    }
  }

  getSettinsDataValue() {
    try {
      getSettingData()
        .then(data => {
          if (data != null || data != undefined) {
            this.selectedSite = data;
          }
          this.spinnerdatatable = false;
        }).catch(() => {
          this.spinnerdatatable = false;
          this.message = 'Something went wrong in Get Sites(A)';
          this.showerrorpopup();
        });
    } catch (error) {
      console.log('QF INFO:- GetSettinsDataValue QFGuide');
    }
  }

  handleSave() {
    try {
      if (this.sites.length > 0) {
        this.spinnerdatatable = true;
        const comboboxField = this.template.querySelector('[data-id="sitesave"]');
        const comboboxValue = comboboxField.value;
        const selectedOption = this.sites.find(option => option.value === comboboxValue).label;
        this.selectedSiteName = selectedOption;

        if (this.selectedSite) {
          saveSecureUrl({ selectedSiteid: this.selectedSite })
            .then(() => {
              // this.spinnerdatatable = false;
              this.error_toast = true;
            assignPermissionSet({
                oldselectedSiteName: this.preselectedSiteName,
                newselectedSiteName: this.selectedSiteName
              }).then(() => {
                this.error_toast = true;
              this.template.querySelector('c-toast-component').showToast('success', 'Site updated successfully', 3000);
                setTimeout(() => { this.spinnerdatatable = false; window.location.reload(); }, 3000);
              }).catch(() => {
            this.spinnerdatatable = false;
            this.error_toast = true;
            this.template.querySelector('c-toast-component').showToast('error', 'Uh oh, something went wrong', 3000);
});
          }).catch(() => {
            this.spinnerdatatable = false;
            this.error_toast = true;
            this.template.querySelector('c-toast-component').showToast('error', 'Uh oh, something went wrong', 3000);
          });
        }
      }
      else {
        this.spinnerdatatable = false;
        this.error_toast = true;
        this.template.querySelector('c-toast-component').showToast('error', 'Please select a site or activate a site.', 3000);

      }
    } catch (error) {
      this.spinnerdatatable = false;
      console.log('QF INFO:- HandleSave QFGuide');
    }
  }

  handleSiteChange(event) {
    try {
      if (this.sites.length == 0) {
        this.template.querySelector('c-toast-component').showToast('error', 'Uh First Create a Site or Active a Sites', 3000);
      } else {

        this.selectedSite = event.detail.value;
        const selectedLabel = this.sites.find(option => option.value === this.selectedSite).label;        
        this.preselectedSiteName = this.selectedSiteName;
        this.selectedSiteName = selectedLabel;
        this.template.querySelector('.rkclass').disabled = true;
      }
    } catch (error) {
      console.log('QF INFO:- HandleSiteChange QFGuide');
    }
  }

  closesiteModel() {
    try {
      this.isModalOpen = false;
      this.sharingrulemodal = false;
      const target = "tab1";
      this.template.querySelectorAll("a").forEach(tabel => {
        tabel.classList.remove("active-tab");
      });
      this.template.querySelectorAll(".tab").forEach(tabdata => {
        tabdata.classList.remove("active-tab-content");
      });
      this.template.querySelector('[data-tab-id="' + target + '"]').classList.add("active-tab");
      this.template.querySelector('[data-id="' + target + '"]').classList.add("active-tab-content");
    } catch (error) {
      console.log('QF INFO:- ClosesiteModel QFGuide');
    }
  }

  openModel(event) {
    if (event.currentTarget.dataset.name == 'SharingRule') {
      this.sharingrulemodal = true;
    } else {
      this.isModalOpen = true;
    }
  }

  openCreateEditModel() {
    this.issiteModelopen = true;
  }

  closeModel() {
    try {
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
    } catch (error) {
      console.log('QF INFO:- CloseModel QFGuide');
    }
  }

  opensite(event) {
    try {
      if (event.currentTarget.dataset.name == 'SharingRule') {
        const baseUrl = window.location.origin + '/lightning/setup/SecuritySharing/home';
        window.open(baseUrl, '_blank');
      } else {
        const baseUrl = window.location.origin + '/lightning/setup/CustomDomain/home';
        window.open(baseUrl, '_blank');
      }
    } catch (error) {
      this.message = 'Something went wrong in Open Site Function';
      this.showerrorpopup();
    }
  }

  tabing() {
    try {
      const target = "tab1";
      this.template.querySelectorAll("a").forEach(tabel => {
        tabel.classList.remove("active-tab");
      });
      this.template.querySelectorAll(".tab").forEach(tabdata => {
        tabdata.classList.remove("active-tab-content");
      });
      this.template.querySelector('[data-tab-id="' + target + '"]').classList.add("active-tab");
      this.template.querySelector('[data-id="' + target + '"]').classList.add("active-tab-content");
    } catch (error) {
      console.log('QF INFO:- Tabing QFGuide');
    }
  }

  quickbot() {
    this.showquickbot = !this.showquickbot;
  }

  changequickbot() {
    this.showquickbot = false;
  }
  
  modalbotclose() {
    this.showquickbot = false;
  }

  sendsuccesspopup() {
    try {
      this.error_toast = true;
      let toast_error_msg = 'Message Sent Successfully';
      this.template.querySelector('c-toast-component').showToast('success', toast_error_msg, 3000);
    } catch (error) {
      console.log('QF INFO:- Sendsuccesspopup QFGuide');
    }
  }

  senderrorpopup() {
    try {
      this.error_toast = true;
      let toast_error_msg = 'Email was not Sent. Something went Wrong, Please try again';
      this.template.querySelector('c-toast-component').showToast('error', toast_error_msg, 3000);
    } catch (error) {
      console.log('QF INFO:- Senderrorpopup QFGuide');
    }
  }

  showerrorpopup() {
    try {
      this.template.querySelector('c-errorpopup').errormessagee("User Configuration Page", this.message);
    } catch (error) {
      console.log('QF INFO:- Showerrorpopup QFGuide');
    }
  }
}