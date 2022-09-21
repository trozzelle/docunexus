<template>
<div class="container">         
    <div v-if="!$root.loggedIn">
        <login></login>
    </div>
    <div v-else>
        <div class="row mt-3 mb-2 border-bottom">
            <div class="col-12">
                <h2 class="display-2">
                    Welcome, {{name}}                        
                </h2>                
            </div>        
        </div>
        <div class="row">
            <div class="col-6">
                <div class="card shadow">
                    <div class="card-header bg-success">
                        <div class="row">
                            <div class="col">
                                <h5 class="mt-1 mb-1 text-white"><i class="fad fa-tools"></i> Tools</h5>
                            </div>
                        </div>
                    </div>
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item"><i class="fas fa-fw fa-search text-success"></i> <router-link tag="a" exact :to="{name: 'quick-lookup', params: {}}">Voter query</router-link></li>    
                        <li class="list-group-item"><i class="fas fa-fw fa-user-check text-success"></i> <router-link tag="a" exact :to="{name: 'match', params: {}}">Voter match</router-link></li>                        
                        <li class="list-group-item"><i class="fas fa-fw fa-history text-success"></i> <router-link tag="a" exact :to="{name: 'history', params: {}}">Match history</router-link></li>      
                        <li class="list-group-item"><i class="fas fa-fw fa-bullseye-pointer text-success"></i> <router-link tag="a" exact :to="{name: 'targets', params: {}}">Target maker</router-link></li>     
                        <li class="list-group-item"><i class="fas fa-fw fa-address-book text-success"></i> <router-link tag="a" exact :to="{name: 'nexus-index', params: {}}">Nexus Index</router-link></li>     
                    </ul>
                </div>
                <div class="card mt-4 shadow">
                    <div class="card-header bg-success">
                        <div class="row">
                            <div class="col-8">
                                <h5 class="mt-1 text-white"><i class="fad fad fa-user-check"></i> My Voter Matches <span class="badge badge-secondary">{{matches.length}} match<span v-if="matches.length != 1">es</span></span></h5>
                            </div>
                            <div class="col-4">
                                <router-link :to="{name: 'match'}" tag="button" type="button" class="btn btn-sm btn-primary float-right">
                                    <i class="fas fa-arrow-right"></i> Begin matching
                                </router-link>
                            </div>
                        </div>                        
                    </div>
                    <ul v-if="matches.length > 0 && !matchesLoading" class="list-group list-group-flush">                        
                        <li class="list-group-item" :key="key" v-for="(b, key) in matches.slice(0,2)">
                            <span v-if="b.status == 'QUEUED'">
                                <div>
                                    <i class="fas fa-check-square text-success mr-1"></i> 
                                    <router-link tag="a" exact :to="{name: 'history', params: {}}">
                                        <strong>{{b.matchfile_name}}</strong>
                                    </router-link>
                                </div>
                                <div>{{parseInt(b.matchcount).toLocaleString()}} record<span v-if="b.matchcount != 1">s</span> submitted</div>
                                <div style="font-size: 0.8rem">Submitted on {{b.date_submitted}}</div>
                            </span>
                            <span v-if="b.status == 'COMPLETE'">
                                <div>
                                    <i class="fas fa-check-square text-success mr-1"></i> 
                                    <router-link tag="a" exact :to="{name: 'history', params: {}}">
                                        <strong>{{b.matchfile_name}}</strong>
                                    </router-link>
                                </div>
                                <div>{{parseInt(b.matchcount).toLocaleString()}} record<span v-if="b.matchcount != 1">s</span> submitted, {{parseInt(b.matched).toLocaleString()}} record<span v-if="b.matched != 1">s</span> matched, {{parseInt(b.unmatched).toLocaleString()}} record<span v-if="b.unmatched != 1">s</span> not matched</div>
                                <div style="font-size: 0.8rem">Submitted on {{b.date_submitted}}, completed on {{b.date_completed}}</div>
                            </span>
                            <span v-if="b.status == 'LOADED'">
                                <div>
                                    <router-link tag="a" exact :to="{name: 'history', params: {}}">
                                        <i class="fas fa-file-upload text-warning mr-1"></i> <strong>{{b.matchfile_name}}</strong>
                                    </router-link>
                                </div>                                
                                <div style="font-size: 0.8rem">Submitted on {{b.date_submitted}}</div>
                            </span>
                            <span v-if="b.status == 'MATCHING' || b.status == 'PASS1'">
                                <div>
                                    <i class="fas fa-fw text-success fa-circle-notch fa-spin mr-1"></i> 
                                    <router-link tag="a" exact :to="{name: 'history', params: {}}">
                                        <strong>{{b.matchfile_name}}</strong> {{parseInt(b.matchcount).toLocaleString()}} record<span v-if="b.matchcount != 1">s</span> being matched
                                    </router-link>
                                </div>
                                <div class="list-detail">Submitted on {{b.date_submitted}}</div>
                            </span>
                        </li>                        
                    </ul>
                    <div v-if="matchesLoading">
                        <div class="m-2">
                            <i class="fas fa-fw text-primary fa-circle-notch fa-spin"></i> Loading
                        </div>
                    </div>
                    <div v-if="matches.length == 0 && !matchesLoading">
                        <h5 class="p-2">You don't have any voter matches, yet.</h5>
                    </div>
                    <div class="card-footer">
                        <i class="fas fa-arrow-to-right text-success"></i> <router-link :to="{name: 'history'}" tag="a">See all voter matches</router-link>
                    </div>
                </div>
            </div>
            <div class="col-6">
                <div class="card shadow">
                    <div class="card-header bg-success">
                        <div class="row">
                            <div class="col-8">
                                <h5 class="mt-1 text-white"><i class="fad fa-bullseye-pointer"></i> My Targets <span class="badge badge-secondary">{{lists.length}} list<span v-if="lists.length != 1">s</span></span></h5>                                
                            </div>
                            <div class="col-4">
                                <router-link :to="{name: 'targets', params: {}}" tag="button" type="button" class="btn btn-sm btn-primary float-right">
                                    <i class="fas fa-arrow-right"></i> Make a target
                                </router-link>
                            </div>
                        </div>
                    </div>
                    <ul v-if="lists.length > 0 && !listsLoading" class="list-group list-group-flush">                        
                        <li class="list-group-item" :key="key" v-for="(l, key) in lists.slice(0,2)">
                            <div class="row">                                
                                <div class="col-8">                                                                   
                                    <strong>
                                        <router-link tag="a" exact :to="{name: 'targets', params: {listid: l.listid}}">{{l.list_name}}</router-link>                                                                              
                                    </strong>
                                    <div>{{parseInt(l.list_count).toLocaleString()}} record<span v-if="l.list_count != 1">s</span> in target</div>
                                    <div class="list-detail">Last edited on {{l.date_modified}}</div>
                                </div>                              
                            </div>
                            <div v-if="l.deleting" class="row mt-1">
                                <div class="col text-right mr-2">
                                    <strong>Are you sure?</strong>                                    
                                    <button type="button" v-if="l.deleting" v-on:click="deleteList(l)" class="btn btn-sm btn-success">Yes</button>
                                    <button type="button" v-on:click="l.deleting = false" class="btn btn-sm btn-danger">No</button>
                                </div>
                            </div>
                        </li>                    
                    </ul>


                    <div v-if="listsLoading">
                        <div class="m-2">
                            <i class="fas fa-fw text-primary fa-circle-notch fa-spin"></i> Loading
                        </div>
                    </div>
                    <div v-if="lists.length == 0 && !listsLoading">
                        <h5 class="p-2">You don't have any targets, yet.</h5>
                    </div>                    
                    <div class="card-footer">
                        <i class="fas fa-arrow-to-right text-success"></i> <router-link :to="{name: 'targets'}" tag="a">See all targets</router-link>
                    </div>
                </div>
            </div>       
        </div>
    </div>
</div>
</template>
<script>
export default {       
    data: function() {
        return {                  
            name: this.$root.user.display_name.split('+').join(' '),
            matches: [],
            matchesLoading: false,
            lists: [],
            listsLoading: false,
        }
    },
    methods: {
        editList: function(list) {
            this.$root.list = list;
            this.router.push({name: 'lists', params: {}});
        },
        getUserMatches: function() {  
            if (this.$root.user.userid > '') {              
                this.matchesLoading = true;
                var _this = this;
                var data = {                        
                    userid: this.$root.user.userid,
                    token: [{userid: this.$root.user.userid, token: this.$root.user.auth_token}]
                };  
                this.axios.get(this.$root.baseURI+'/history/matches.get', {                    
                    params: data
                }).then(function (response) {                 
                    _this.$root.handleTokenError(response.data);
                    _this.matchesLoading = false;                                 
                    if (response.data.error) {
                        _this.$root.setAlert(true, response.data.error, 'alert-danger');
                        return;
                    } else {
                        if (response.data.length) {                                      
                            _this.matches = response.data;                                
                        }
                    }
                }).catch(error => {
                    _this.matchesLoading = false; 
                    _this.$root.setAlert(true, error, 'alert-danger');
                    return;
                });  
            }
        },
        getUserLists: function() {  
            if (this.$root.user.userid > '') {          
                this.listsLoading = true;
                var _this = this;
                var data = {                                
                    userid: this.$root.user.userid,
                    token: [{userid: this.$root.user.userid, token: this.$root.user.auth_token}]
                };  
                this.axios.get(this.$root.baseURI+'/lists/lists.get', {                    
                    params: data
                }).then(function (response) {     
                     _this.$root.handleTokenError(response.data);                           
                    _this.listsLoading = false;                                 
                    if (response.data.error) {
                        _this.$root.setAlert(true, response.data.error, 'alert-danger');
                        return;
                    } else {
                        if (response.data.length) {                                      
                            _this.lists = response.data;                        
                        }
                    }
                }).catch(error => {
                    _this.listsLoading = false;
                    _this.$root.setAlert(true, error, 'alert-danger');
                    return;
                });
            }  
        },
    },
    mounted: function() {
        this.getUserMatches();
        this.getUserLists();        
        if (localStorage.getItem('loggedOut') == "true") {                 
          //  this.$root.setAlert(true, 'You have been logged out successfully', 'alert-success');
            localStorage.clear();
        }
    },
    watch: {
        '$root.user': {
            deep: true,
            handler(newVal) {                
                if (newVal.userid > '') {
                    this.name = this.$root.user.display_name.split('+').join(' ');
                    this.getUserMatches();
                    this.getUserLists();
                }                
            }
        }        
    }
};
</script>
<style scoped>
    .list-detail {
        font-size: 0.8rem;
    }

    .btn-group-xs>.btn, .btn-xs {
        padding: .25rem;
        font-size: .75rem;
        line-height: 1.2;
        border-radius: .2rem;
    }
</style>