<template>
    <div class="modal fade" id="userDetail" tabindex="-1" role="dialog" aria-labelledby="userDetailLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 class="display-3"><i class="fad fa-user-tag"></i> Update your information</h3>
                    <button type="button" class="close" v-on:click="closeModal()" aria-label="Close"><i class="fas fa-times"></i></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <label for="username" class="col-3 col-form-label">Username: </label>
                        <div class="col-9">
                            <div class="form-label-group input-group">
                                <input type="text" maxlength="50" class="form-control" id="username" placeholder="Username" v-model="user.username"/>
                                <label>Username</label>
                            </div>
                        </div>
                    </div>
                    <div class="row" v-if="user.username.trim() == ''">
                        <div class="col-9 offset-3">
                            <div class="alert alert-warning">Username is required</div>
                        </div>
                    </div>
                    <div class="row" v-if="usernameWarn">
                        <div class="col-9 offset-3">
                            <div class="alert alert-warning">The username you provided is already in use</div>
                        </div>
                    </div>            
                    <div class="row">
                        <label for="username" class="col-3 col-form-label">Password: </label>
                        <div class="col-9">
                            <div class="form-label-group input-group">
                                <input type="password" maxlength="40" name="pass1" class="form-control" placeholder="New password" v-model="pass1"/>
                                <label>New password</label>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-9 offset-3">
                            <div class="form-label-group input-group">
                                <input type="password" maxlength="40" name="pass2" class="form-control" placeholder="Repeat new password" v-model="pass2"/>
                                <label>Repeat new password</label>
                            </div>
                        </div>
                    </div>
                    <div class="row" v-if="pass2tmp.trim() > '' && pass1.trim() != pass2tmp.trim()">
                        <div class="col-9 offset-3">
                            <div class="alert alert-warning">Passwords must match</div>
                        </div>
                    </div>
                    <div class="row">
                        <label for="email" class="col-3 col-form-label">Email address: </label>
                        <div class="col-9">
                            <div class="form-label-group input-group">
                                <input type="text" maxlength="255" class="form-control" id="email" placeholder="Email address" v-model="user.email"/>
                                <label>Email address</label>
                            </div>
                        </div>
                    </div>
                    <div class="row" v-if="user.email.trim() == ''">
                        <div class="col-9 offset-3">
                            <div class="alert alert-warning">Email address is required</div>
                        </div>
                    </div>
                    <div class="row" v-if="emailWarn">
                        <div class="col-9 offset-3">
                            <div class="alert alert-warning">The email address you provided is already in use</div>
                        </div>
                    </div>
                    <div class="row">
                        <label for="email" class="col-3 col-form-label">Display name: </label>
                        <div class="col-9">
                            <div class="form-label-group input-group">
                                <input type="text" maxlength="255" class="form-control" id="display_name" placeholder="Display name" v-model="user.display_name"/>
                                <label>Display name</label>
                            </div>
                        </div>
                    </div>
                    <div class="row" v-if="user.display_name.trim() == ''">
                        <div class="col-9 offset-3">
                            <div class="alert alert-warning">Display name is required</div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer text-right">
                    <!-- <button :disabled="!formInvalid" type="button" class="btn btn-sm btn-success" v-on:click="saveUser()"><i class="fas fa-save"></i> Save</button> -->                                        
                    <button type="button" class="btn btn-sm btn-danger" v-on:click="closeModal()"><i class="fas fa-times"></i> Close</button>
                </div>
            </div>
        </div>
    </div>
</template>
<script>

export default {
    data: function () {
        return {
            user: JSON.parse(JSON.stringify(this.$root.user)),
            pass1: '',
            pass2: '',
            pass2tmp: '',
            passTimeout: null,
            saving: false,
            usernameWarn: false,
            emailWarn: false
        }
    },
    methods: {
        closeModal: function () {
            $('#userDetail').modal('hide');
            this.user = JSON.parse(JSON.stringify(this.$root.user));
        },
        saveUser: function () {
            var _this = this;
            this.usernameWarn = false;
            this.emailWarn = false;
            this.saving = true;
            var params = {
                userid: this.user.userid,
                username: this.user.username,
                password: this.pass2tmp,
                email: this.user.email,
                display_name: this.user.display_name,
                token: [{userid: this.$root.user.userid, token: this.$root.user.auth_token}]
            }
            this.axios.get(this.$root.baseURI+'/user.update', {
                params: params
            }).then(response => {
                _this.$root.handleTokenError(response.data);
                if (response.data.warning) {
                    switch (response.data.warning) {
                        case 'username':
                            _this.usernameWarn = true;
                        break;
                        case 'email':
                            _this.emailWarn = true;
                        break;
                    }
                    return;
                }
                if (response.data.error) {
                    _this.$root.setAlert(true, response.data.error, 'alert-danger');
                    return;
                } else {
                    _this.$root.user = response.data;
                    _this.closeModal();
                    _this.$root.setAlert(true, 'Your information has been updated', 'alert-success');
                }
            }).catch(error => {
                this.$root.setAlert(true, error, 'alert-danger');
                return;
            });
        }
    },
    computed: {
        formInvalid: function () {
            var out = false;
            if (this.user.username.trim() > '' && this.user.email.trim() > '' && this.user.display_name.trim() > '') {
                if (this.pass1.trim() == '' && this.pass2.trim() == '') {
                    out = true;
                } else {
                    if ((this.pass1.trim() > '' || this.pass2tmp.trim() > '') && this.pass1.trim() == this.pass2tmp.trim()) {
                        out = true;
                    } else {
                        out = false;
                    }
                }
            } else {
                out = false;
            }
            return out;
        },
    },
    watch: {
        '$root.user': {
            deep: true,
            handler(newVal) {
                if (newVal.userid > '') {
                    this.user = JSON.parse(JSON.stringify(newVal));
                }
            }
        },
        'pass2': function (newVal, oldVal) {
            var _this = this;
            if (newVal != oldVal) {
                clearTimeout(_this.passTimeout);
                _this.passTimeout = setTimeout(function () {
                    _this.pass2tmp = newVal;
                }, 750);
            }
        }
    }
}
</script>
<style scoped>
.modal-lg {
  width: 650px;
}
</style>