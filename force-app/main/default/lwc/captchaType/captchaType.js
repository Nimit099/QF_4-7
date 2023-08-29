import {
    LightningElement,
    api,
    track
} from 'lwc';
export default class CaptchaType extends LightningElement {
    @track getprogreshbar = 'Select';
    @track Captcha = false;
    @track Slider_Captcha = false;
    @track Image_Captcha = false;
    @track Normal_Captcha = false;
    @track Maths_Captcha = false;
    @track showBool = false;
    alphabets = "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz";
    alphabetslength = this.alphabets.length;
    @track msg_verified_captcha = false;
    @track msg_invalid_captcha = false;
    @track get_normal_captcha_value;
    @track get_math_captcha_value;
    @track normal_captcha;
    @track sum_mat_captcha;
    @track mat_captcha_1;
    @track mat_captcha_2;
    @track set_normal_captcha_value = '';
    @track set_math_captcha_value;
    @track value = 0;
    @track styleColor;
    @track pickListValueList = [];
    @track rendomcolor;
    @track color;
    @track BackgroundColor;
    @track test;
    @track isFirstLoadedNormalCaptcha = true;
    @track slider_captcha_1;
    @api captypetypes = 'Normal_Captcha';
    @track message;
    varifyvar = false;

    connectedCallback() {
        this.generate_new_math_captcha();
        this.generate_new_slider_captcha();
        this.getrendomcolore();
        this.createNewNormalCaptcha();
        if (this.captypetypes != undefined) {
            this.preview_chptchatype(this.captypetypes);
        }
    }

    renderedCallback() {
        if (this.Normal_Captcha && this.isFirstLoadedNormalCaptcha) {
            this.isFirstLoadedNormalCaptcha = false;
            this.createNewNormalCaptcha();
        }
        if (this.Normal_Captcha && this.varifyvar == false) {
            this.createNewNormalCaptcha();
        }
    }

    createNewNormalCaptcha() {
        try {
            //to generate random 6 characters for captcha
            var charsArray = "0123456789AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz";
            var lengthOtp = 6;
            var captcha = [];
            for (var i = 0; i < lengthOtp; i++) { //below code will not allow Repetition of Characters
                var index = Math.floor(Math.random() * charsArray.length + 1); //get the next character from the array
                if (captcha.indexOf(charsArray[index]) == -1)
                    captcha.push(charsArray[index]);
                else i--;
            }

            var canv = this.template.querySelector(".captchaCanvas");
            if (canv != null && canv != undefined) {
                const width = canv.width;
                const height = canv.height;
                var ctx = canv.getContext("2d");
                ctx.clearRect(0, 0, width, height);
                ctx.font = "25px Georgia";
                ctx.strokeText(captcha.join(""), 10, 30);

                for (let i = 0; i < 6; i++) {
                    ctx.beginPath();
                    ctx.moveTo(Math.random() * width, Math.random() * height);
                    ctx.lineTo(Math.random() * width, Math.random() * height);
                    ctx.strokeStyle = 'black';
                    ctx.stroke();
                }

                this.normal_captcha = captcha.join("");
                this.template.querySelector(".captchaDiv").appendChild(canv);
                this.set_normal_captcha_value = null;
                this.msg_invalid_captcha = false;
                this.msg_verified_captcha = false;
                if (typeof window !== 'undefined') {
                    const selectedEvent = new CustomEvent("captchaverification", {
                        detail: this.msg_verified_captcha
                    });
                    // Dispatches the event.
                    this.dispatchEvent(selectedEvent);
                }
            }
        } catch (error) {
            this.message = 'Something Went Wrong While Createing Normal Captcha';
            this.showerrorpopup();
        }
    }

    // Start Captcha 1 Normal Captcha
    verify_normal_captcha() {
        try {
            this.varifyvar = true;
            // this.get_normal_captcha_value = event.target.value;
            this.get_normal_captcha_value = this.template.querySelector('input[data-id=normal_captch_usr_input]').value;

            if (this.get_normal_captcha_value == this.normal_captcha) {
                this.msg_verified_captcha = true;
                this.msg_invalid_captcha = false;
                this.set_normal_captcha_value = this.get_normal_captcha_value;
                // Creates the event with the data.
                const selectedEvent = new CustomEvent("captchaverification", {
                    detail: this.msg_verified_captcha
                });
                // Dispatches the event.
                this.dispatchEvent(selectedEvent);
            } else {
                this.createNewNormalCaptcha();
                this.msg_invalid_captcha = true;
                this.msg_verified_captcha = false;
                this.set_normal_captcha_value = null;
                const selectedEvent = new CustomEvent("captchaverification", {
                    detail: this.msg_verified_captcha
                });
                // Dispatches the event.
                this.dispatchEvent(selectedEvent);
            }
        } catch (error) {
            this.message = 'Something Went Wrong while verifying Normal Captcha';
            this.showerrorpopup();
        }
    }

    @api generate_new_normal_captcha() {
        try {
            this.first = this.alphabets[Math.floor(Math.random() * this.alphabetslength)];
            this.second = Math.floor(Math.random() * 10);
            this.third = Math.floor(Math.random() * 10);
            this.fourth = this.alphabets[Math.floor(Math.random() * this.alphabetslength)];
            this.fifth = this.alphabets[Math.floor(Math.random() * this.alphabetslength)];
            this.sixth = Math.floor(Math.random() * 10);
            this.normal_captcha = this.first + this.second + this.third + this.fourth + this.fifth + this.sixth;
            this.set_normal_captcha_value = null;
            this.msg_invalid_captcha = false;
            this.msg_verified_captcha = false;
            const selectedEvent = new CustomEvent("captchaverification", {
                detail: this.msg_verified_captcha
            });
            // Dispatches the event.
            this.dispatchEvent(selectedEvent);
            this.createNewNormalCaptcha();
        } catch (error) {
            this.message = 'Something Went Wrong while generating Normal Captcha';
            this.showerrorpopup();
        }
    }
    // End Captcha 1 Normal Captcha

    // Start Captcha 2 Math Captcha
    @api generate_new_math_captcha() {
        try {
            this.mat_captcha_1 = Math.floor(Math.random() * 100);
            this.mat_captcha_2 = Math.floor(Math.random() * 10);
            this.sum_mat_captcha = parseInt(this.mat_captcha_1) + parseInt(this.mat_captcha_2);
            this.set_math_captcha_value = null;
            this.msg_invalid_captcha = false;
            this.msg_verified_captcha = false;
            if (typeof window !== 'undefined') {
                const selectedEvent = new CustomEvent("captchaverification", {
                    detail: this.msg_verified_captcha
                });
                // Dispatches the event.
                this.dispatchEvent(selectedEvent);
            }
        } catch (error) {
            this.message = 'Something Went Wrong while generating Math Captcha';
            this.showerrorpopup();
        }
    }

    verify_math_captcha() {
        try {
            this.get_math_captcha_value = this.template.querySelector('input[data-id=math_captch_usr_input]').value;

            if (this.get_math_captcha_value == this.sum_mat_captcha) {
                this.msg_verified_captcha = true;
                this.msg_invalid_captcha = false;
                this.set_math_captcha_value = this.get_math_captcha_value;
                const selectedEvent = new CustomEvent("captchaverification", {
                    detail: this.msg_verified_captcha
                });
                // Dispatches the event.
                this.dispatchEvent(selectedEvent);
            } else {
                this.generate_new_math_captcha();
                this.msg_invalid_captcha = true;
                this.msg_verified_captcha = false;
                this.set_math_captcha_value = null;
                const selectedEvent = new CustomEvent("captchaverification", {
                    detail: this.msg_verified_captcha
                });
                // Dispatches the event.
                this.dispatchEvent(selectedEvent);
            }
        } catch (error) {
            this.message = 'Something Went Wrong while verifying Math Captcha';
            this.showerrorpopup();
        }
    }


    // End Captcha 2 Math Captcha

    // Start Captcha 3 Slider Captcha
    @api generate_new_slider_captcha() {
        try {
            this.slider_captcha_1 = Math.floor(Math.random() * 50);
        } catch (error) {
            console.log(error);
        }
    }
    testch(event) {
        try {
            this.value = event.target.value;
        } catch (error) {
            console.log(error);
        }

    }
    handleValueChange() {
        try {
            if (this.value == this.slider_captcha_1) {
                this.msg_verified_captcha = true;
                this.msg_invalid_captcha = false;
                const selectedEvent = new CustomEvent("captchaverification", {
                    detail: this.msg_verified_captcha
                });
                // Dispatches the event.
                this.dispatchEvent(selectedEvent);
            } else {
                this.msg_invalid_captcha = true;
                this.msg_verified_captcha = false;
                const selectedEvent = new CustomEvent("captchaverification", {
                    detail: this.msg_verified_captcha
                });
                // Dispatches the event.
                this.dispatchEvent(selectedEvent);
                this.generate_new_slider_captcha();
            }
        } catch (error) {
            console.log(error);
        }

    }
    // End Captcha 3 Slider Captcha



    @api getrendomcolore() {
        try {
            this.pickListValueList = [];
            for (var i = 1; i <= 8; i++) {
                const letter = "0123456789ABCDEF";
                this.color = "#";
                for (let j = 0; j < 6; j++) {
                    this.color += letter[Math.floor(Math.random() * 16)];
                }
                this.BackgroundColor = 'background-color:' + this.color;

                this.pickListValueList.push(this.BackgroundColor);
                this.rendomcolor = this.pickListValueList[Math.floor(Math.random() * 8)];
            }
            this.msg_verified_captcha = false;
            if (typeof window !== 'undefined') {
                const selectedEvent = new CustomEvent("captchaverification", {
                    detail: this.msg_verified_captcha
                });
                // Dispatches the event.
                this.dispatchEvent(selectedEvent);
            }
        } catch (error) {
            this.message = 'Something Went Wrong while getting random Color';
            this.showerrorpopup();
        }
    }
    verfication_color_captcha(event) {
        try {
            this.test = event.target.dataset.name;
            if (this.test == this.rendomcolor) {
                this.msg_verified_captcha = true;
                this.msg_invalid_captcha = false;
                const selectedEvent = new CustomEvent("captchaverification", {
                    detail: this.msg_verified_captcha
                });
                // Dispatches the event.
                this.dispatchEvent(selectedEvent);
            } else {
                this.msg_invalid_captcha = true;
                this.msg_verified_captcha = false;
                this.getrendomcolore();
                const selectedEvent = new CustomEvent("captchaverification", {
                    detail: this.msg_verified_captcha
                });
                // Dispatches the event.
                this.dispatchEvent(selectedEvent);

            }
        } catch (error) {
            this.message = 'Something Went Wrong while verifying Color Captcha';
            this.showerrorpopup();
        }
    }




    @api preview_chptchatype(strString) {
        try {
            this.getprogreshbar = strString;
            if (this.getprogreshbar == 'Select') {
                this.Captcha = false;
                this.Slider_Captcha = false;
                this.Image_Captcha = false;
                this.Normal_Captcha = false;
                this.Maths_Captcha = false;
            } else if (this.getprogreshbar == 'Slider_Captcha') {
                this.Captcha = false;
                this.Slider_Captcha = true;
                this.Image_Captcha = false;
                this.Normal_Captcha = false;
                this.Maths_Captcha = false;
            } else if (this.getprogreshbar == 'Image_Captcha') {
                this.Captcha = false;
                this.Slider_Captcha = false;
                this.Image_Captcha = true;
                this.Normal_Captcha = false;
                this.Maths_Captcha = false;
            } else if (this.getprogreshbar == 'Normal_Captcha') {
                this.Captcha = false;
                this.Slider_Captcha = false;
                this.Image_Captcha = false;
                this.Normal_Captcha = true;
                this.Maths_Captcha = false;
                this.isFirstLoadedNormalCaptcha = true;
            } else if (this.getprogreshbar == 'Maths_Captcha') {
                this.Captcha = false;
                this.Slider_Captcha = false;
                this.Image_Captcha = false;
                this.Normal_Captcha = false;
                this.Maths_Captcha = true;
            }
        } catch (error) {
            this.message = 'Something Went Wrong In Preview Captcha';
            this.showerrorpopup();
        }

    }
    @api error_msg() {
        this.msg_invalid_captcha = false;
        this.msg_verified_captcha = false;
    }

    showerrorpopup() {
        try {
            this.template.querySelector('c-errorpopup').errormessagee('Publish Component Error', this.message);
            
        } catch (error) {
            console.log(error);
        }
    }

}