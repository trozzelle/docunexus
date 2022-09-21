<template>
    <transition name="fade" mode="out-in">
        <div class="login" v-if="step == 'login'" key="login">
            <div class="row justify-content-center" v-on:keyup.enter="signIn()">
                <div class="card col-5">
                    <div class="row">
                        <div class="col">
                            <h1 class="display-2 text-center text-primary"><i class="fad fa-sign-in-alt"></i> Sign in</h1>
                        </div>
                    </div>
                    <form class="mt-3 mb-3" v-on:submit.prevent>
                        <div class="row">
                            <div class="col">
                                <div class="form-label-group input-group mb-0">
                                    <input type="text" name="userName" class="form-control" placeholder="User name" v-model="login.name" />
                                    <label>User name</label>
                                </div>
                            </div>
                        </div>
                        <div class="row p-2">
                            <div class="col">
                                <i class="fas fa-question-circle text-primary"></i> <span class="forgot" v-on:click="step = 'username'">I forgot my username</span>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col">
                                <div class="form-label-group input-group mb-0">
                                    <input type="password" name="userPassword" class="form-control" placeholder="Password" v-model="login.password" />
                                    <label>Password</label>
                                </div>
                            </div>
                        </div>
                        <div class="row p-2">
                            <div class="col">
                                <i class="fas fa-question-circle text-primary"></i> <span class="forgot" v-on:click="step = 'password'">I forgot my password</span>
                            </div>
                        </div>
                        <div v-if="error > ''" :class="{'shake': error > ''}" :key="errKey" class="row">
                            <div class="alert col mr-3 ml-3 alert-danger"><i class="fas fa-lg fa-exclamation-square"></i> {{error}}</div>
                        </div>
                        <div v-if="logoutMessage" :key="errKey+1" class="row">
                            <div class="alert col mr-3 ml-3" :class="logoutMessage.style"><i class="fas fa-lg fa-exclamation-square"></i> {{logoutMessage.message}}</div>
                        </div>
                        <div class="row mt-2">
                            <div class="col">
                                <button type="button" v-on:click="signIn()" class="btn btn-lg btn-block btn-info"><i class="fad fa-sign-in-alt"></i> Sign in</button>
                            </div>
                        </div>                        
                    </form>            
                </div>          
            </div>
        </div>
        <div class="login" v-if="step == 'username'" key="username">
            <div class="row justify-content-center" v-on:keyup.enter="sendUsername()">
                <div class="card col-5">
                    <div class="col">
                        <h1 class="display-2 text-center text-primary"><i class="fad fa-user-circle"></i> Reset username</h1>
                    </div>
                    <form class="mt-3 mb-3" v-on:submit.prevent>     
                        <div class="row">
                            <div class="col">
                                <div class="form-label-group input-group mb-0">
                                    <input type="text" name="email" class="form-control" placeholder="Email address" v-model="email" />
                                    <label>Email address</label>
                                </div>
                            </div>
                        </div>
                        <div class="row p-2">
                            <div class="col">
                                <i class="fas fa-question-circle text-primary"></i> <span class="forgot" v-on:click="step = 'password'">I forgot my password</span>
                            </div>
                        </div>                   
                        <div v-if="usernameStatus.status" :class="{'shake': usernameStatus.status == 'error'}" :key="errKey" class="row">                            
                            <div v-if="usernameStatus.status == 'error'" class="alert col mr-3 ml-3 alert-danger"><i class="fas fa-times"></i> {{usernameStatus.data}}</div>
                            <div v-else-if="usernameStatus.status == 'warning'" class="alert col mr-3 ml-3 alert-warning"><i class="fas fa-exclamation-square"></i> {{usernameStatus.data}}</div>
                            <div v-else-if="usernameStatus.status == 'success'" class="alert col mr-3 ml-3 alert-success"><i class="fas fa-check"></i> {{usernameStatus.data}}</div>
                        </div>
                        <div class="row mt-2">
                            <div class="col">
                                <button type="button" :disabled="email.trim() == ''" v-on:click="sendUsername();" class="btn btn-lg btn-block btn-primary"><i class="fad fa-paper-plane"></i> Send me my username</button>
                            </div>
                        </div>
                         <div class="row pt-2">
                            <div class="col">
                                <button type="button" v-on:click="goHome();" class="btn btn-sm btn-block btn-secondary"><i class="fas fa-sign-in-alt text-white"></i> Continue to sign in</button>                                 
                            </div>
                        </div>
                        
                    </form>            
                </div>          
            </div>
        </div>
        <div class="login" v-if="step == 'password'" key="password">
            <div class="row justify-content-center" v-on:keydown.enter="sendPassword()">
                <div class="card col-5">
                    <div class="col">
                        <h1 class="display-2 text-center text-primary"><i class="fad fa-unlock-alt"></i> Reset password</h1>
                    </div>
                    <form class="mt-3 mb-3" v-on:submit.prevent>                       
                        <div class="row">
                            <div class="col">
                                <div class="form-label-group input-group mb-0">
                                    <input type="text" name="userName" class="form-control" placeholder="User name" v-model="username" />
                                    <label>User name</label>
                                </div>
                            </div>
                        </div>
                        <div class="row p-2">
                            <div class="col">
                                <i class="fas fa-question-circle text-primary"></i> <span class="forgot" v-on:click="step = 'username'">I forgot my username</span>
                            </div>
                        </div>
                        <div v-if="passwordStatus.status" :class="{'shake': passwordStatus.status == 'error'}" :key="errKey" class="row">                            
                            <div v-if="passwordStatus.status == 'error'" class="alert col mr-3 ml-3 alert-danger"><i class="fas fa-times"></i> {{passwordStatus.data}}</div>
                            <div v-else-if="passwordStatus.status == 'warning'" class="alert col mr-3 ml-3 alert-warning"><i class="fas fa-exclamation-square"></i> {{passwordStatus.data}}</div>
                            <div v-else-if="passwordStatus.status == 'success'" class="alert col mr-3 ml-3 alert-success"><i class="fas fa-check"></i> {{passwordStatus.data}}</div>
                        </div>                       
                        <div class="row mt-2">
                            <div class="col">
                                <button type="button" :disabled="username.trim() == ''" v-on:click="sendPassword();" class="btn btn-lg btn-block btn-primary"><i class="fad fa-paper-plane"></i> Send me my password</button>
                            </div>
                        </div>
                        <div class="row pt-2">
                            <div class="col">
                                <button type="button" v-on:click="goHome()" class="btn btn-sm btn-block btn-secondary"><i class="fas fa-sign-in-alt text-white"></i> Continue to sign in</button>                                 
                            </div>
                        </div>
                    </form>            
                </div>          
            </div>
        </div>
        <div class="login" v-if="step == 'reset'" key="reset">
            <div class="row justify-content-center" v-on:keyup.enter="resetPassword()">
                <div class="card col-5">
                    <div class="row">
                        <div class="col">
                            <h1 class="display-2 text-center text-primary"><i class="fad fa-unlock-alt"></i> Set password</h1>
                        </div>
                    </div>
                    <form class="mt-3 mb-3" v-on:submit.prevent>
                        <div class="row">
                            <div class="col">
                                <div class="form-label-group input-group">
                                    <input :disabled="!passSubmit" type="password" name="pass1" class="form-control" placeholder="New password" v-model="pass1" />
                                    <label>New password</label>
                                </div>
                            </div>
                        </div>                
                        <div class="row">
                            <div class="col">
                                <div class="form-label-group input-group">
                                    <input :disabled="!passSubmit" type="password" name="pass2" class="form-control" placeholder="Repeat new password" v-model="pass2" />
                                    <label>Repeat new password</label>
                                </div>
                            </div>
                        </div>                
                        <div v-if="resetStatus.status" :class="{'shake': resetStatus.status == 'error'}" :key="errKey" class="row">                            
                            <div v-if="resetStatus.status == 'error'" class="alert col mr-3 ml-3 alert-danger"><i class="fas fa-times"></i> {{resetStatus.data}}</div>
                            <div v-else-if="resetStatus.status == 'warning'" class="alert col mr-3 ml-3 alert-warning"><i class="fas fa-exclamation-square"></i> {{resetStatus.data}}</div>
                            <div v-else-if="resetStatus.status == 'success'" class="alert col mr-3 ml-3 alert-success"><i class="fas fa-check"></i> {{resetStatus.data}}</div>
                        </div>
                        <div v-if="resetStatus.status > '' && resetStatus.status != 'success'" class="row pl-2 pr-2 pb-2">
                            <div class="col">                            
                                <i class="fas fa-question-circle text-primary"></i> <span class="forgot" v-on:click="step = 'password'">Re-send password reset email</span>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col">
                                <button type="button" :disabled="!passSubmit" v-on:click="resetPassword()" class="btn btn-lg btn-block btn-primary"><i class="fad fa-unlock-alt"></i> Set password</button>
                            </div>
                        </div>                                
                        <div v-if="resetStatus.status == 'success'" class="row pt-2">
                            <div class="col">
                                <button type="button" v-on:click="goHome()" class="btn btn-sm btn-block btn-secondary"><i class="fas fa-sign-in-alt text-white"></i> Continue to sign in</button>                                 
                            </div>
                        </div>
                    </form>            
                </div>          
            </div>
        </div>
    </transition>
    
</template>
<script>
export default {
    data: function() {
        return {
            login: {name: '', password: ''},
            error: '',
            username: '',
            email: '',
            errKey: 0,
            step: 'login',
            usernameStatus: {status: false, data: null},
            passwordStatus: {status: false, data: null},
            resetStatus: {status: false, data: ''},
            pass1: null,
            pass2: null,
            passSubmit: false,
            passData: {userid: false},
            token: this.$route.params.token || '',
            logoutMessage: JSON.parse(localStorage.getItem('logoutMessage')) || false
        }
    },
    methods: {
        goHome: function() {
            this.logoutMessage = false;
            localStorage.removeItem('logoutMessage');
            if (window.location.pathname.indexOf('reset-password') != -1) {                
                this.$router.push({name: 'home'});
            } else {
                this.step = 'login';
            }
        },
        getPasswordData: function() {
            if (this.token == '') {
                return;
            }            
            var formData = new FormData();
            formData.append('token', this.token);
            this.axios.post(this.$root.baseURI+'/admin/password/get.reset', formData, {
                headers: { 'Content-Type': 'multipart/form-data' }
            }).then(response => {                           
                if (response.data.error) {
                    this.passSubmit = false;
                    this.errKey += 1;
                    this.$root.setAlert(true, response.data.error, 'alert-danger');    
                    return;
                } 
                if (response.data.status) {
                    this.passSubmit = false;
                    this.errKey += 1;
                    this.resetStatus = response.data;                 
                    return;
                }
                this.passSubmit = true;
                this.passData.userid = response.data[0].userid;
            }).catch(error => {
                this.$root.setAlert(true, error, 'alert-danger');
                return;
            });
        },
        resetPassword: function() {            
            this.message = {status: false, data: ''};
            this.errKey += 1;                              
            if (this.pass1.trim() != this.pass2.trim()) {
                this.resetStatus.status = 'error';
                this.resetStatus.data = 'Passwords do not match';
                return;
            }
            var formData = new FormData();
            formData.append('userid',this.passData.userid);
            formData.append('password',this.pass2);
            this.axios.post(this.$root.baseURI+'/admin/password/set.password', formData, {
                headers: { 'Content-Type': 'multipart/form-data' }
            }).then(response => {                  
                if (response.data.error) {
                    this.passSubmit = false;
                    this.errKey += 1;
                    this.$root.setAlert(true, response.data.error, 'alert-danger');    
                    return;
                }
                this.resetStatus = response.data;   
                if (this.resetStatus.status == 'success') {
                    this.passSubmit = false;
                    this.pass1 = null;
                    this.pass2 = null;
                }              
            }).catch(error => {
                this.$root.setAlert(true, error, 'alert-danger');
                return;
            });
        },
        sendUsername: function() {
            this.usernameStatus = {status: false, data: null};
            this.error = '';
            this.errKey += 1;                                          
            var formData = new FormData();
            formData.append('email', this.email);            
            this.axios.post(this.$root.baseURI+'/admin/password/forgot.username', formData, {
                headers: { 'Content-Type': 'multipart/form-data' }
            }).then(response => {        
                this.usernameStatus = response.data;  
                this.email = '';               
            }).catch(error => {
                this.$root.setAlert(true, error, 'alert-danger');
                return;
            });
        },
        sendPassword: function() {
            this.passwordStatus = {status: false, data: null};
            this.error = '';
            this.errKey += 1;                                          
            var formData = new FormData();
            formData.append('username',this.username); 
            this.axios.post(this.$root.baseURI+'/admin/password/forgot.password', formData, {
                headers: { 'Content-Type': 'multipart/form-data' }
            }).then(response => {                 
                this.passwordStatus = response.data; 
                this.username = '';                
            }).catch(error => {
                this.$root.setAlert(true, error, 'alert-danger');
                return;
            });
        },
        signIn: function() {   
            localStorage.removeItem('logoutMessage');                     
            this.logoutMessage = false;
            this.error = '';
            this.errKey += 1;                              
            var _this = this;
            var formData = new FormData();
            formData.append('user',this.login.name.trim()); 
            formData.append('pass',_this.login.password.trim());             
            this.axios.post(this.$root.baseURI+'/user.data', formData, {
                headers: { 'Content-Type': 'multipart/form-data' }
            }).then(response => {                              
                if (response.data.error) {   
                    this.error = response.data.error;
                    this.$root.loggedIn = false;
                    return;
                } else {                                 
                    this.$root.user = response.data;
                    this.$root.loggedIn = true;
                    this.$root.clearAlert();
                    if (this.$route.name != 'home') {
                        this.$router.push({name: 'home'});
                    }
                    return;
                }
            }).catch(error => {
                this.$root.setAlert(true, error, 'alert-danger');
                return;
            });
        }
    },
    created: function() {        
        if (this.$route.name == 'resetpass') {
            this.step = 'reset';
            this.getPasswordData();
        }
    },
    mounted: function() {        
    }
}
</script>
<style scoped>
.login .forgot:hover {
    text-decoration: underline;
    cursor: pointer;
}
.login .row {
    background-color: transparent;
}
.login .card {
    padding-top: 20px;
    margin-top: 20px;
    background-color: rgba(255,255,255, 0.6);
    box-shadow: 0 0 10px rgba(0,0,0,0.3);
}

.login .card .logo {
    margin: 0px auto;
}

.login .card .logo img {
    width: 50%;
    
}

.login .shake {
  animation: errShake 0.82s cubic-bezier(.36,.07,.19,.97) both;
  transform: translate3d(0, 0, 0);
  backface-visibility: hidden;
  perspective: 1000px;
}

@keyframes errShake {
  10%, 90% {
    transform: translate3d(-1px, 0, 0);
  }
  
  20%, 80% {
    transform: translate3d(2px, 0, 0);
  }

  30%, 50%, 70% {
    transform: translate3d(-4px, 0, 0);
  }

  40%, 60% {
    transform: translate3d(4px, 0, 0);
  }
}

.fade-enter-active, .fade-leave-active {
  transition: all .3s ease;
}
.fade-enter, .fade-leave-to /* .fade-leave-active below version 2.1.8 */ {
  opacity: 0;
  transform: translateX(100px);
}

.fade-leave, .fade-enter-to {
    opacity: 1;
    transform: translateX(0);
}
</style>