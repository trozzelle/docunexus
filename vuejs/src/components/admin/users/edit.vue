<template>
    <div>         
        <div class="row border-bottom pt-3 mb-2">
            <div class="col-9">
                <h2 class="display-2">
                    <i class="text-primary fas fa-pen-square"></i> 
                    <span v-if="!newUser">Editing user "{{$parent.user.display_name}}"</span>
                    <span v-else>Creating a new user</span>                    
                </h2>                
            </div>            
            <div class="col-3">
                <button type="button" v-on:click="resetUser();" class="mt-1 btn btn-sm btn-primary float-right"><i class="fas fa-arrow-left"></i> Back to users</button>
            </div>
        </div>        
        <div class="card">
            <div class="card-header">
                <h4 class="float-left"><i class="fas fa-fw fa-clipboard-user"></i> User information</h4>
                <button type="button" v-on:click="update()" :disabled="!testUpdate" class="btn btn-success btn-sm float-right"><i class="fas fa-check"></i> Save</button>      
            </div>           
            <div class="card-body">
                <div class="row border-bottom pb-2 mb-2">
                    <div class="col-6">
                        <div class="row">
                            <div class="col-4 col-form-label">
                                <label><strong>Login ID</strong></label>
                            </div>
                            <div class="col-8">
                                <input type="text" v-model="tempUser.username" class="form-control" placeholder="Login ID">
                            </div>                         
                        </div>
                        <div class="row" v-if="errors.username">
                            <div class="col">
                                <div class="alert alert-danger"><i class="fas fa-lg fa-exclamation-circle"></i> {{errors.username}}</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="row">
                            <div class="col-4 col-form-label">
                                <label><strong>Password</strong></label>
                                <div>
                                    <button type="button" class="btn btn-sm btn-warning" v-on:click="generatePassword()"><i class="fas fa-key"></i> Create password</button>
                                </div>
                            </div>
                            <div class="col-8">
                                <input type="text" v-model="password.pass1" class="form-control mb-1" placeholder="New password">   
                                <input type="text" v-model="password.pass2" class="form-control" placeholder="Verify password">                                                                    
                            </div>
                        </div>
                        <div class="row mt-2" v-if="errors.password">
                            <div class="col">
                                <div class="alert alert-danger"><i class="fas fa-lg fa-exclamation-circle"></i> {{errors.password}}</div>
                            </div>
                        </div>
                    </div>                
                </div>
                <div class="row border-bottom pb-2 mb-2">
                     <div class="col-6">
                        <div class="row">
                            <div class="col-4 col-form-label">
                                <label><strong>Name</strong></label>
                            </div>
                            <div class="col-8">
                                <input type="text" v-model="tempUser.display_name" class="form-control" placeholder="Name">                         
                            </div>                         
                        </div>
                        <div class="row" v-if="errors.display_name">
                            <div class="col">
                                <div class="alert alert-danger"><i class="fas fa-lg fa-exclamation-circle"></i> {{errors.display_name}}</div>
                            </div>
                        </div>
                    </div>                   
                    <div class="col-6">
                        <div class="row">
                            <div class="col-4 col-form-label">
                                <label><strong>Email</strong></label>
                            </div>
                            <div class="col-8">
                                <input type="text" v-model="tempUser.email" class="form-control" placeholder="user@email.com">                         
                            </div>                         
                        </div>  
                        <div class="row" v-if="errors.email">
                            <div class="col">
                                <div class="alert alert-danger"><i class="fas fa-lg fa-exclamation-circle"></i> {{errors.email}}</div>
                            </div>
                        </div>                      
                    </div>                              
                </div>
               
                <div class="row">  
                    <div class="col-6">
                        <div class="row">
                            <div class="col-4 col-form-label">
                                <label><strong>Active</strong></label>
                            </div>
                            <div class="col-8">
                                <div class="form-control-plaintext">
                                    <div class="custom-control custom-radio custom-control-inline">
                                        <input type="radio" v-model="tempUser.enabled" value="Y" id="userActiveYes" name="userActive" class="custom-control-input">
                                        <label class="custom-control-label" for="userActiveYes">Yes</label>
                                    </div>
                                    <div class="custom-control custom-radio custom-control-inline">
                                        <input type="radio" v-model="tempUser.enabled" value="N" id="userActiveNo" name="userActive" class="custom-control-input">
                                        <label class="custom-control-label" for="userActiveNo">No</label>
                                    </div>
                                </div>
                            </div>                         
                        </div>
                    </div>
                    <div class="col-6" v-if="$root.user.admin.site_admin == 'Y'">
                        <div class="row">
                            <div class="col-4 col-form-label">
                                <label><strong>Site administrator</strong></label>
                            </div>
                            <div class="col-8">
                                <div class="form-control-plaintext">
                                    <div class="custom-control custom-radio custom-control-inline">
                                        <input type="radio" v-model="tempUser.site_admin" value="Y" id="userisAdminYes" name="isAdmin" class="custom-control-input">
                                        <label class="custom-control-label" for="userisAdminYes">Yes</label>
                                    </div>
                                    <div class="custom-control custom-radio custom-control-inline">
                                        <input type="radio" v-model="tempUser.site_admin" value="N" id="userisAdminNo" name="isAdmin" class="custom-control-input">
                                        <label class="custom-control-label" for="userisAdminNo">No</label>
                                    </div>
                                </div>
                            </div>                         
                        </div>                          
                    </div>
                </div>
            </div>                           
            <div v-if="$root.user.admin.site_admin == 'Y' || userRegions.length > 0 || userGroups.length > 0" class="card-header border-top">
                <h4 class="float-left"><i class="fas fa-fw fa-object-group"></i> 
                <span v-if="$root.user.admin.site_admin == 'Y' || ($root.user.admin.site_admin == 'N' && (userRegions.length > 0 && userGroups.length > 0))">Region and group membership</span>                
                    <span v-if="$root.user.admin.site_admin == 'N' && userRegions.length > 0 && userGroups.length == 0">Region membership</span>
                    <span v-if="$root.user.admin.site_admin == 'N' && userRegions.length == 0 && userGroups.length > 0">Group membership</span>                    
                </h4>
            </div>      
            <div v-if="$root.user.admin.site_admin == 'Y' || userRegions.length > 0 || userGroups.length > 0" class="card-body">
                <div v-if="$root.user.admin.site_admin == 'Y' || userRegions.length > 0">
                    <div class="col-12 mt-2 pb-2">
                        <h5>Assigned regions</h5>
                    </div>
                    <div class="col-12" v-if="tempUser.regions.length">
                        <div :key="k" v-for="(r, k) in tempUser.regions">
                            <div class="row" :class="{'border-bottom': k < tempUser.regions.length - 1}">
                                <div class="col-2 pt-2">
                                    <button type="button" class="btn btn-sm btn-danger" v-on:click="removeRegion(tempUser, r)"><i class="fas fa-times"></i> Remove</button>
                                </div>
                                <div class="col-5 pt-2">
                                    {{r.region_name}}
                                </div>             
                                <div class="col-5">                                
                                    <div class="form-control-plaintext">
                                        <label class="pr-2"><strong>Region administrator</strong></label>
                                        <div class="custom-control custom-radio custom-control-inline">
                                            <input type="radio" v-model="r.region_admin" value="Y" :id="k+'regionAdminYes'" :name="k+'regionAdmin'" class="custom-control-input">
                                            <label class="custom-control-label" :for="k+'regionAdminYes'">Yes</label>
                                        </div>
                                        <div class="custom-control custom-radio custom-control-inline">
                                            <input type="radio" v-model="r.region_admin" value="N" :id="k+'regionAdminNo'" :name="k+'regionAdmin'" class="custom-control-input">
                                            <label class="custom-control-label" :for="k+'regionAdminNo'">No</label>
                                        </div>
                                    </div>
                                </div>                            
                            </div>                                    
                        </div>
                    </div>                    
                    <div v-else>
                        <div class="col-12">
                            No regions assigned
                        </div>
                    </div>
                
                    <div class="col-12 mt-2 pt-2">
                        <div class="row">
                            <div class="col-6">                                      
                                <div class="form-label-group">                                    
                                    <select class="form-control" v-model="regionEdit">
                                        <option value="" selected="selected" disabled="disabled">Select a region</option>
                                        <option :key="k" v-for="(r, k) in $parent.regions" :disabled="userRegions.includes(r.regionid) || hasRegion(tempUser.regions, r.regionid)" :value="r.regionid">{{r.region_name}}</option>
                                    </select>                                                        
                                    <label>Region</label>
                                </div>                                                            
                            </div>
                            <div class="col-2 mt-2 text-right">
                                <button type="button" :disabled="regionEdit == ''" v-on:click="addRegion(tempUser)" class="btn btn-sm btn-success"><i class="fas fa-plus"></i> Add</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div v-if="$root.user.admin.site_admin == 'Y' || userGroups.length > 0">
                    <div class="col-12 mt-2 pt-2 pb-2 border-top">
                        <h5>Assigned groups</h5>
                    </div>
                    <div class="col-12" v-if="tempUser.groups.length">
                        <div :key="k" v-for="(r, k) in tempUser.groups">
                            <div class="row" :class="{'border-bottom': k < tempUser.groups.length - 1}">
                                <div class="col-2 pt-2">
                                    <button type="button" class="btn btn-sm btn-danger" v-on:click="removeGroup(tempUser, r)"><i class="fas fa-times"></i> Remove</button>
                                </div>
                                <div class="col-5 pt-2">
                                    {{r.group_name}}
                                </div>             
                                <div class="col-5">                                
                                    <div class="form-control-plaintext">
                                        <label class="pr-2"><strong>Group administrator</strong></label>
                                        <div class="custom-control custom-radio custom-control-inline">
                                            <input type="radio" v-model="r.group_admin" value="Y" :id="k+'groupAdminYes'" :name="k+'groupAdmin'" class="custom-control-input">
                                            <label class="custom-control-label" :for="k+'groupAdminYes'">Yes</label>
                                        </div>
                                        <div class="custom-control custom-radio custom-control-inline">
                                            <input type="radio" v-model="r.group_admin" value="N" :id="k+'groupAdminNo'" :name="k+'groupAdmin'" class="custom-control-input">
                                            <label class="custom-control-label" :for="k+'groupAdminNo'">No</label>
                                        </div>
                                    </div>
                                </div>               
                            </div>                                    
                        </div>
                    </div>
                    <div v-else>
                        <div class="col-12">
                            No groups assigned
                        </div>
                    </div>
                    <div class="col-12 mt-2 pt-2">
                        <div class="row">
                            <div class="col-6">                                      
                                <div class="form-label-group">                                    
                                    <select class="form-control" v-model="groupEdit">
                                        <option value="" selected="selected" disabled="disabled">Select a group</option>
                                        <option :key="k" v-for="(r, k) in $parent.groups" :disabled="userGroups.includes(r.groupid) || hasGroup(tempUser.groups, r.groupid)" :value="r.groupid">{{r.group_name}}</option>
                                    </select>                                                        
                                    <label>Group</label>
                                </div>                                                                                          
                            </div>
                            <div class="col-2 mt-2 text-right">
                                <button type="button" :disabled="groupEdit == ''" v-on:click="addGroup(tempUser)" class="btn btn-sm btn-success"><i class="fas fa-plus"></i> Add</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>            
        </div>
    </div>
</template>
<script>
import { EventBus } from '@/event-bus';
export default {
    data: function() {
        return {            
            newUser: this.$parent.user.userid == '',            
            loading: this.$parent.loading,
            tempUser: JSON.parse(JSON.stringify(this.$parent.user)),                        
            password: {hidden: true, pass1: '', pass2: ''},
            errors: {display_name: false, password: false, email: false, username: false},    
            regionEdit: '',
            groupEdit: ''        
        }
    },
    methods: {   
        generatePassword: function() {
            var p = Math.random().toString(36).slice(2) + Math.random().toString(36).slice(2);            
            this.password.pass1 = p;
            this.password.pass2 = p;
        },        
        removeRegion: function(user, region) {            
            user.regions = user.regions.filter(r => {return r.regionid != region.regionid});
            user.regionids = user.regionids.filter(i => {return i != region.regionid});
        },
        addRegion: function(user) {
            var r = this.$parent.regions.find(region => region.regionid == this.regionEdit);
            this.$set(r, 'region_admin', 'N');
            user.regions.push(r);
            user.regionids.push(r.regionid);
            user.regionids.sort();
            this.regionEdit = '';
        },
        hasRegion: function(regions, regionid) {
            var out = true;
            var l = regions.filter(r => {
                return r.regionid == regionid;
            });
            if (l.length == 0) {
                out = false;
            }            
            return out;
        },  
        removeGroup: function(user, group) {            
            user.groups = user.groups.filter(r => {return r.groupid != group.groupid});
            user.groupids = user.groupids.filter(i => {return i != group.groupid});
        },
        addGroup: function(user) {
            var r = this.$parent.groups.find(group => group.groupid == this.groupEdit);
            this.$set(r, 'group_admin', 'N');            
            user.groups.push(r);
            user.groupids.push(r.groupid);
            user.groupids.sort();
            this.groupEdit = '';
        },
        hasGroup: function(groups, groupid) {
            var out = true;
            var l = groups.filter(r => {
                return r.groupid == groupid;
            });
            if (l.length == 0) {
                out = false;
            }            
            return out;
        }, 
        finishUpdate: function(userid) {
            var i = this.$parent.users.findIndex(a => {
                return a.userid == userid;
            });                        
            this.tempUser.userid = userid;                                
            this.$parent.user.display_name = this.tempUser.display_name;
            this.$parent.user.username = this.tempUser.username;
            var p = this.testValid('password');
            if (p.valid && p.update) {
                this.tempUser.password = this.password.pass2;
                this.password = {hidden: true, pass1: '', pass2: ''};
            }
            this.$parent.user.enabled = this.tempUser.enabled;
            this.$parent.user.password = this.tempUser.password;
            this.$parent.user.site_admin = this.tempUser.site_admin;                    
            this.$parent.user.email = this.tempUser.email;      
            this.$parent.user.groups = this.tempUser.groups;              
            this.$parent.user.regions = this.tempUser.regions;
            this.$parent.user.groupids = this.tempUser.groupids;              
            this.$parent.user.regionids = this.tempUser.regionids;
            EventBus.$emit('update-user', i, this.tempUser);
            this.tempUser = JSON.parse(JSON.stringify(this.$parent.user));
        },  
        testValid: function(item) {
            var i = '';
            var update = false;
            var valid = true;
            var error = '';
            var out = {item: '', data: '', valid: true, update: false, error: ''};
            var arr = [];
            switch (item) {
                case 'username':
                    i = this.tempUser.username.trim();
                    update = (i > '' && i != this.$parent.user.username);                    
                    var exists = this.$parent.users.some(u => {
                        return u.username == i;
                    });                    
                    if (exists) {                        
                        valid = false;
                        error = 'That login ID is being used by another user';
                    }                      
                    if (i == '') {
                        valid = false;
                        error = 'Login ID is required';
                    }
                break;                
                case 'display_name':
                    i = this.tempUser.display_name;
                    var t = i.toLowerCase().trim();
                    update = (t > '' && t != this.$parent.user.display_name.toLowerCase().trim());  
                    if (i == '') {
                        valid = false;
                        error = 'Display name is required';
                    }                    
                break;                                
                case 'password':
                    i = this.password.pass2.trim();
                    update = (i > '' && i != this.$parent.user.password && this.password.pass1.trim() == i);                   
                    if (this.tempUser.password == '' && (i == '' && this.password.pass1.trim() == '')) {
                        valid = false;
                        error = 'Please create a password';
                    } else if (this.password.pass1.trim() != i) {
                        valid = false;
                        error = 'Both passwords must match';
                    }
                break;
                case 'email':
                    i = this.tempUser.email;
                    update = (i != this.$parent.user.email);   
                    if (i == '') {
                        valid = false;
                        error = 'Email address is required';
                    }                                     
                break;                  
                case 'enabled': 
                    i = this.tempUser.enabled;
                    update = (i != this.$parent.user.enabled);
                break;                
                case 'site_admin': 
                    i = this.tempUser.site_admin;
                    update = (i != this.$parent.user.site_admin);
                break;   
                case 'groups':
                    arr = this.tempUser.groups.sort((a, b) => (a.groupid > b.groupid) ? 1 : -1);
                    i = this.tempUser.groups;                       
                    update = (JSON.stringify(arr) != JSON.stringify(this.$parent.user.groups));    
                break;
                case 'regions':
                    arr = this.tempUser.regions.sort((a, b) => (a.regionid > b.regionid) ? 1 : -1);
                    i = this.tempUser.regions;
                    update = (JSON.stringify(arr) != JSON.stringify(this.$parent.user.regions));                    
                break;
            }
            out.item = item;
            out.data = i;
            out.valid = valid;
            out.update = update;
            out.error = error;
            return out;
        },     
        update: function() {
            var error = false;
            var fields = [];
            var toUpdate = [];
            var _this = this;
            var formData = false;   
            
            fields.push(
                this.testValid('username'),
                this.testValid('display_name'),                
                this.testValid('password'),                
                this.testValid('enabled'),                
                this.testValid('email'),
                this.testValid('site_admin'),
                this.testValid('groups'),
                this.testValid('regions')
                );    
                
            for (var i = 0; i < fields.length; i++) {
                this.errors[fields[i].item] = false;
                //If the field has been flagged to update, make sure it's valid - if it is, add to the update queue, otherwise, add an error
                //All fields need to be validated for new members
                if (fields[i].update || this.newUser) { 
                    if (!fields[i].valid) {
                        this.errors[fields[i].item] = fields[i].error;
                        error = true;
                    } else {                         
                        toUpdate.push(fields[i]);
                    }
                }
            }             
            if (!error) {
                if (this.newUser) { //This is the first user save, create a new user                    
                    var newUserData = {
                        username: this.tempUser.username,
                        display_name: this.tempUser.display_name,
                        password: this.password.pass2,
                        enabled: this.tempUser.enabled,                        
                        email: this.tempUser.email,                        
                        site_admin: this.tempUser.site_admin,
                        groups: this.tempUser.groups,
                        regions: this.tempUser.regions,                        
                        action: 'add'
                    };

                    formData = new FormData();  
                    formData.append("data", JSON.stringify(newUserData));
                    formData.append('token', JSON.stringify([{userid: this.$root.user.userid, token: this.$root.user.auth_token}]));
                    this.axios({
                        method: 'post',
                        url: this.$root.baseURI+'/admin/users/users.update',
                        data: formData
                    }).then(function (response) {                             
                         _this.$root.handleTokenError(response.data);                                                                       
                        _this.loading = false;                                 
                        if (response.data.error) {
                            _this.$root.setAlert(true, response.data.error, 'alert-danger');
                            return;
                        } else {
                            _this.tempUser.userid = response.data[0].userid;
                            _this.$parent.user = _this.tempUser;                        
                            _this.newUser = false;
                            _this.finishUpdate(_this.$parent.user.userid);
                            _this.$root.setAlert(true, 'User added successfully', 'alert-success');
                        }
                    }).catch(error => {
                        _this.$root.setAlert(true, error, 'alert-danger');
                        return;
                    });                                    

                } else {
                    var data = {};                    
                    for (var j = 0; j < toUpdate.length; j++) {
                        data[toUpdate[j].item] = toUpdate[j].data;
                    } 
                    data.action = 'update';
                    data.userid = this.tempUser.userid;
                    formData = new FormData();                      
                    formData.append("data", JSON.stringify(data));
                    formData.append('token', JSON.stringify([{userid: this.$root.user.userid, token: this.$root.user.auth_token}]));
                    this.axios({
                        method: 'post',
                        url: this.$root.baseURI+'/admin/users/users.update',
                        data: formData
                    }).then(function (response) {                           
                        _this.$root.handleTokenError(response.data);                                          
                        _this.loading = false;                                 
                        if (response.data.error) {
                            _this.$root.setAlert(true, response.data.error, 'alert-danger');
                            return;
                        } else {
                            _this.finishUpdate(_this.$parent.user.userid);
                            _this.$root.setAlert(true, 'Update successful', 'alert-success');
                        }
                    }).catch(error => {
                        _this.$root.setAlert(true, error, 'alert-danger');
                        return;
                    });                                    
                }
            }
        },        
        resetUser: function() {
            this.$parent.editing = false;
        }      
    },
    computed: {
        userRegions: function() {
            return this.$parent.user.regions.filter(region => {
                return region.region_admin == 'Y';
            }).map(function(r) {
                return r.regionid;
            }); 
        },
        userGroups: function() {
            return this.$parent.user.groups.filter(group => {
                return group.group_admin == 'Y';
            }).map(function(g) {
                return g.groupid;
            }); 
        },
        testUpdate: function() {                        
           return this.testValid('username').update 
           || this.testValid('display_name').update            
           || this.testValid('password').update       
           || this.testValid('enabled').update 
           || this.testValid('email').update 
           || this.testValid('site_admin').update
           || this.testValid('groups').update
           || this.testValid('regions').update;
        }
    }
}
</script>
<style scoped>
.color span {
    width: 100px;
}
.form-group {
    margin-bottom: 0;
}

.card-body {
    padding: 10px;
}

.alert {
    margin-bottom: 0;
}

.row {
    margin-left: -10px;
    margin-right: -10px;
}
</style>