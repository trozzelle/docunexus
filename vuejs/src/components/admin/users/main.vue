<template>
    <div class="container" style="padding-bottom: 80px">
        <div v-if="!$root.loggedIn">
            <login></login>
        </div>
        <div v-else>
            <div class="row mt-3 mb-2 border-bottom">
                <div class="col-12">
                    <h1 class="display-1">
                    <i class="fad fa-fw fa-user-friends text-primary"></i> User management
                    </h1>
                </div>                
            </div>            
            <transition name="fade" mode="out-in">
                <div class="mt-2" v-if="!editing" key="list">
                    <button 
                        type="button" 
                        v-on:click="addNew()"
                        class="btn btn-sm btn-primary">
                            <i class="fas fa-user-plus"></i> Add a new user
                    </button>
                    <div v-if="!loading && users.length">                
                        <div class="form-row mt-2">
                            <div class="col search input-group form-label-group">
                                <input type="text" class="form-control" v-model="search" placeholder="Type a user name to begin searching...">
                                <label>Type an user name, login ID or user email to begin searching...</label>
                                <div class="input-group-append">
                                    <button type="button" :disabled="search == ''" v-on:click="search = ''" class="btn btn-secondary"><i class="fas fa-times"></i> Clear</button>
                                </div>
                            </div>
                        </div>
                        <div class="card mb-3">
                            <ul class="list-group list-group-flush">
                                <li :key="k" class="list-group-item" :class="{'inactive': n.enabled == 'N'}" v-for="(n, k) in paginatedData">                    
                                    <div class="row">
                                        <div class="col-8">
                                            <h5 class="float-left long-name" v-html="$options.filters.highlight(n.display_name, search)"></h5>
                                            <span v-if="n.site_admin == 'Y'" class="ml-2 mt-1 float-left badge badge-primary">Site administrator</span>
                                            <span class="ml-2 mt-1 float-left badge badge-pill badge-secondary" v-if="n.enabled == 'N'"> <i class="fa fa-bell" aria-hidden="true"></i> Disabled</span>
                                        </div>
                                        <div class="col-4">
                                            <div class="text-right">
                                                <button 
                                                    type="button"
                                                    v-on:click="edit(n);" 
                                                    class="btn btn-sm btn-info mr-1"                                
                                                    :disabled="n.deleting || (n.site_admin == 'Y' && $root.user.admin.site_admin == 'N')"
                                                ><i class="fas fa-pen-alt"></i> Edit</button>
                                                <button 
                                                    type="button"
                                                    v-on:click="n.deleting = true;"
                                                    class="btn btn-sm btn-danger"
                                                    :disabled="n.deleting || (n.site_admin == 'Y' && $root.user.admin.site_admin == 'N') || $root.user.userid == n.userid"
                                                ><i class="fas fa-times"></i> Delete</button>                                                                                             
                                                <div class="text-right mt-1" v-show="n.deleting">
                                                    <span class="text-danger mr-1">Are you sure?</span>
                                                    <button type="button mr-1" v-on:click="del(n)" class="btn btn-sm btn-success"><i class="fas fa-check"></i> Yes</button>
                                                    <button type="button" v-on:click="n.deleting = false;" class="btn btn-sm btn-danger"><i class="fas fa-times"></i> No</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-5">
                                            <div class="detail"><span class="text-secondary">Login ID:</span> <span class="text-info" v-html="$options.filters.highlight(n.username, search)"></span></div>                                    
                                            <div class="detail"><span class="text-secondary">Email:</span> <span class="text-info" v-html="$options.filters.highlight(n.email, search)"></span></div>                                    
                                        </div>
                                        <div class="col-5">
                                            <div class="detail"><span class="text-secondary">Regions: </span> 
                                                <span class="text-info" v-html="$options.filters.highlight(displayRegions(n), search)"></span>
                                            </div>    
                                            <div class="detail"><span class="text-secondary">Groups: </span> 
                                                <span class="text-info" v-html="$options.filters.highlight(displayGroups(n), search)"></span>
                                            </div>    
                                        </div>
                                    </div>
                                </li>                                
                            </ul>
                            <div class="card-footer">
                                <div class="row">
                                    <div class="col-2">
                                        <button class="btn btn-primary" type="button" :disabled="pageNumber == 0" v-on:click="prevPage()"><i class="fas fa-chevron-left"></i> Back</button>
                                    </div>
                                    <div class="col-8 mt-2" style="text-align: center">
                                        <span v-if="pageCount > 0">page {{pageNumber + 1}} of {{pageCount}}</span>
                                        <span v-else>Your search returned no results</span>
                                    </div>
                                    <div class="col">
                                        <button class="float-right btn btn-primary" type="button" :disabled="pageNumber == pageCount - 1 || pageCount == 0" v-on:click="nextPage()">Next <i class="fas fa-chevron-right"></i></button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div v-if="!loading && !users.length" class="border-top mt-2 pt-2">
                        <h3><i class="text-primary far fa-square"></i> <span>No users exist, yet.</span></h3>
                    </div>
                    <div v-if="loading" class="border-top mt-2 pt-2">
                        <h2 v-if="loading"><i class="text-primary fas fa-circle-notch fa-spin"></i> Loading...</h2>
                    </div>
                </div>
                <div v-if="editing" key="alias">
                    <edit></edit>
                </div>
            </transition>
        </div>    
    </div>
</template>
<script>
const userDefault = { 
    userid: '',
    username: '',
    email: '',
    display_name: '',
    password: '',
    site_admin: 'N',
    enabled: 'Y',
    groups: [],
    regions: [],
    groupids: [],
    regionids: []
};

import edit from './edit.vue';
import { EventBus } from '@/event-bus';

export default {
    components: {
        edit: edit
    },
    data: function() {
        return {
            loading: false,
            users: [],    
            regions: [],
            groups: [],
            user: {},
            editing: false, //If we're editing a node, this controls visibility of the edit component
            search: '',
            size: 5, //Elements per page
            pageNumber: 0 //Current page number
        }
    },
    methods: {   
        displayRegions: function(user) {            
            var out = 'No regions assigned';
            var r = [];
            for (var i = 0; i < user.regions.length; i++) {                
                r.push(user.regions[i].region_name);
            }
            if (r.length) {
                out = r.join(', ');
            }
            return out;
        },
        displayGroups: function(user) {
            var out = 'No groups assigned';
            var r = [];
            for (var i = 0; i < user.groups.length; i++) {
                r.push(user.groups[i].group_name);
            }
            if (r.length) {
                out = r.join(', ');
            }
            return out;
        },    
        edit: function(user) {
            this.editing = true;
            this.user = user;
        },
        nextPage: function() {
            if (this.pageNumber < this.pageCount) {
                this.pageNumber++;
            }
        },
        prevPage: function() {
            if (this.pageNumber > 0) {
                this.pageNumber--;
            }
        },
        addNew: function() {
            var u = Object.assign({}, userDefault);
            this.edit(u);
        },
        del: function(user) {
            var _this = this;  
            var data = {};  
            data.action = 'delete';
            data.userid = user.userid;
            var formData = new FormData();            
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
                    let j = _this.users.findIndex(f => {
                        return f.userid == user.userid;
                    });
                    _this.users.splice(j, 1);
                    _this.$root.setAlert(true, 'User deleted successfully', 'alert-success');
                }
            }).catch(error => {
                _this.$root.setAlert(true, error, 'alert-danger');
                return;
            });   
        },
        resetSearch: function() {
            //Trigger update of filtered  by adding a space - then resetting the search to what it was
            var s = this.search;    
            this.search = this.search + ' '; 
            this.search = s;
        },
        getData: function() {
            this.loading = true;
            var _this = this;                  
            var params = {
                userid: this.$root.user.userid,
                site_admin: this.$root.user.admin.site_admin,
                token: [{userid: this.$root.user.userid, token: this.$root.user.auth_token}]
            };
            this.axios.get(this.$root.baseURI+'/admin/users/users.lookup', {             
                params: params
            }).then(function (response) {                 
                _this.$root.handleTokenError(response.data);                                                         
                if (response.data.error) {
                    _this.loading = false;
                    _this.$root.setAlert(true, response.data.error, 'alert-danger');
                    return;
                } else {
                    if (response.data.length >= 0) {   
                        for (var i = 0; i < response.data.length; i++) {
                            response.data[i].editing = false;
                            response.data[i].deleting = false;
                            response.data[i].groupids = [];
                            response.data[i].regionids = [];
                            for (var j = 0; j < response.data[i].regions.length; j++) {
                                response.data[i].regionids.push(response.data[i].regions[j].regionid);
                            }
                            response.data[i].regionids.sort();
                            for (var k = 0; k < response.data[i].groups.length; k++) {
                                response.data[i].groupids.push(response.data[i].groups[k].groupid);
                            }
                            response.data[i].groupids.sort();
                            _this.users.push(response.data[i]);                            
                        }                                                   
                    } else {
                        _this.$root.setAlert(true, 'Cound not get users', 'alert-warning');
                        return;
                    }
                }
            }).catch(error => {
                _this.$root.setAlert(true, error, 'alert-danger');
                return;
            });                            

            params = {                
                token: [{userid: this.$root.user.userid, token: this.$root.user.auth_token}]
            }
            this.axios.get(this.$root.baseURI+'/admin/regions/regions.lookup', {
                params: params
            }).then(function (response) {   
                _this.$root.handleTokenError(response.data);                                                           
                if (response.data.error) {  
                    _this.loading = false;                  
                    _this.$root.setAlert(true, response.data.error, 'alert-danger');
                    return;
                } else {
                    if (response.data.length) {
                        _this.regions = response.data;                        
                    } else {
                        _this.$root.setAlert(true, 'Error getting regions', 'alert-danger');
                        return;
                    }
                }
            }).catch(error => {                             
                _this.$root.setAlert(true, error, 'alert-danger');
                return;
            });  

            this.axios.get(this.$root.baseURI+'/admin/groups/groups.lookup', {
                params: params
            }).then(function (response) {       
                _this.$root.handleTokenError(response.data);                                                     
                if (response.data.error) {   
                    _this.loading = false;                 
                    _this.$root.setAlert(true, response.data.error, 'alert-danger');
                    return;
                } else {
                    if (response.data.length) {
                        _this.groups = response.data;                        
                    } else {
                        _this.$root.setAlert(true, 'Error getting groups', 'alert-danger');
                        return;
                    }
                }
            }).catch(error => {                             
                _this.$root.setAlert(true, error, 'alert-danger');
                return;
            });  

            this.loading = false;
        }
    },
    computed: {
        filtered: function() {
            var s = this.search.toLowerCase();
            return this.users.filter(a => {                
               return a.display_name.toLowerCase().includes(s) || 
                a.email.toLowerCase().includes(s) ||
                a.username.toLowerCase().includes(s) ||
                this.displayRegions(a).toLowerCase().includes(s) ||
                this.displayGroups(a).toLowerCase().includes(s)
            });
        },
        pageCount: function() {
            let l = this.filtered.length;
            let s = this.size;
            var c = Math.ceil(l/s);            
            return c;
        },
        paginatedData: function() {   
            var pn = this.pageNumber;
            if (this.pageNumber >= this.pageCount) {                
                pn = 0;
            }
            var s = pn * this.size;
            var e = s + this.size;
            return this.filtered.slice().slice(s,e);
            
        } 
    },
    mounted() {
        this.getData();
        var _this = this;        
        EventBus.$on('update-user', function(k, v) {
            var i = _this.users.findIndex(a => {
                return a.userid == v.userid;
            });                                    
            if (i == -1) {
                _this.users.unshift(v);            
            } else {
                _this.users[i] = v;
            }
            //Trigger update of filtered by adding a space - then resetting the search to what it was
            var s = _this.search;
            _this.search = _this.search + ' '; 
            _this.search = s;
        });     
    },
    watch: {    
        activeNode: function() {
            this.editing = false;
        }
    }    
}
</script>
<stype scoped>
.fa-stack, .fa-folder-times {
font-size: 0.8rem;

}

.fa-stack-1x {
margin-top: 1px;
}

.border-bottom {
    padding-bottom: 3px;
}

ol {
list-style-type: none;
font-size: 16px;
margin: 0px;
padding: 0px;
}
.card-footer .row {
    background-color: transparent;
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

.container-fluid {
    padding-bottom: 80px;
}


</style>