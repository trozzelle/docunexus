<template>
    <div id="nexus-index" class="container" >
        <div v-if="!$root.loggedIn">
            <login></login>
        </div>
        <div v-else>
            <div class="row mt-3 mb-2 border-bottom">
                <div class="col-12">
                    <h2 class="display-2 text-center text-md-left">Welcome, {{ name }}</h2>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12 col-lg-6">
                    <!-- User tool bar -->
                    <div class="card shadow">
                        <div class="card-header bg-primary">
                            <div class="row">
                                <div class="col">
                                    <h5 class="mt-1 mb-1 text-white">
                                        <i class="fad fa-tools"></i><span class="ml-2"> Tools</span>
                                    </h5>
                                </div>
                            </div>
                        </div>
                        <div class="list-group list-group-flush">
                            <a href="#" class="list-group-item list-group-item-action list-group-item-light">
                                <i class="fas fa-fw fa-user-check text-danger mr-1"></i>
                                <router-link tag="a" exact :to="{ name: 'donor', params: {} }">Donor Lookup</router-link>
                            </a>
                            <a href="#" class="list-group-item list-group-item-action list-group-item-light">
                                <i class="fas fa-fw fa-address-book text-danger mr-1"></i>
                                <router-link tag="a" exact :to="{ name: 'filer-search', params: {} }">Filer Search
                                </router-link>
                            </a>
                            <a href="#" class="list-group-item list-group-item-action list-group-item-light">
                                <i class="fad fa-trophy text-danger mr-1"></i>
                                <router-link tag="a" exact :to="{ name: 'filer-rankings', params: {} }">Filer Rankings
                                </router-link>
                            </a>
                          <a href="#" class="list-group-item list-group-item-action list-group-item-light">
                            <i class="fad fa-globe-americas text-danger mr-1"></i>
                            <router-link tag="a" exact :to="{ name: 'county', params: {} }">Influencer's Index
                            </router-link>
                          </a>
                          <a href="#" class="list-group-item list-group-item-action list-group-item-light">
                            <i class="fad fa-tools text-danger mr-1"></i>
                            <router-link tag="a" exact :to="{ name: 'voter-nexus', params: {} }">Voter nexus
                            </router-link>
                          </a>
                        </div>
                    </div>
                    <!-- User saved lists -->
                    <div class="card mt-4 shadow">
                        <div class="card-header bg-primary">
                            <div class="row">
                                <div class="col-8">
                                    <h5 class="mt-1 text-white">
                                        <i class="fad fa-cabinet-filing"></i><span class="ml-2"> Saved Lists </span>
                                    </h5>
                                </div>
                                <div class="col-4">
                                    <h5 class="float-right">
                                        <span class="badge badge-secondary">{{ savedLists.length }} list<span v-if="savedLists.length != 1">s</span></span>
                                    </h5>
                                </div>
                            </div>
                        </div>
                        <div v-if="savedLists.length > 0 && !savedListsLoading" class="list-group list-group-flush">
                          <a href="#" v-for="(s, key) in savedLists.slice(0, 5)" :key="key" class="list-group-item list-group-item-action list-group-item-light">
                                <div class="row">
                                    <div class="col-8">
                                        <strong>
                                            <router-link tag="a" exact :to="{
                                                name: 'saved-list',
                                                params: {
                                                userID: s.userid,
                                                saveID: s.saveid}, }">{{ s.save_name }}
                                            </router-link>
                                        </strong>
                                        <div>Found {{parseInt(s.record_count).toLocaleString() }} record<span v-if="s.record_count != 1">s</span>
                                        </div>
                                        <div class="list-detail">Type: {{ s.search_type }} | Last edited on {{ s.time_saved }}
                                        </div>
                                    </div>
                                </div>
                            </a>
                        </div>
                        <div v-if="savedListsLoading">
                            <div class="m-2">
                                <i class="fas fa-fw text-primary fa-circle-notch fa-spin"></i>Loading
                            </div>
                        </div>
                        <div v-if="savedLists.length == 0 && !savedListsLoading">
                            <h5 class="p-2">You have no saved lists, yet.</h5>
                        </div>
                        <div class="card-footer">
                            <i class="fas fa-arrow-to-right text-danger"></i>
                            <a href="#" v-on:click.prevent="showAllSaved('lists', savedLists)"> See all saved lists</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-12 mt-4 mt-lg-0 col-lg-6">
                    <!-- User bookmarks -->
                    <div class="card shadow">
                        <div class="card-header bg-primary">
                            <div class="row">
                                <div class="col-8">
                                    <h5 class="mt-1 text-white">
                                        <i class="fad fa-bookmark"></i><span class="ml-2"> My Favorites </span>
                                    </h5>
                                </div>
                                <div class="col-4">
                                    <h5 class="float-right">
                                        <span class="badge badge-secondary">{{ savedPages.length }} list<span v-if="savedPages.length != 1">s</span></span>
                                    </h5>
                                </div>
                            </div>
                        </div>
                        <div v-if="savedPages.length > 0 && !savedPagesLoading" class="list-group list-group-flush">

                          <a href="#" v-for="(p, key) in savedPages.slice(0,5)" :key="key" class="list-group-item list-group-item-action list-group-item-light">
                                <div class="row">
                                    <div class="col-9">
                                        <strong>
                                            <router-link tag="a" exact :to="p.location">{{p.page_title }}</router-link>
                                        </strong>
                                        <div class="list-detail">Page type: {{ p.page_type }} | Saved on {{ p.time_saved }}</div>
                                    </div>
                                </div>
                                <div v-if="p.deleting" class="row mt-1">
                                    <div class="col text-right mr-2">
                                        <strong>Are you sure?</strong>
                                        <button v-if="p.deleting" type="button" class="btn btn-sm btn-success" v-on:click="deleteList(l)">Yes
                                        </button>
                                        <button type="button" class="btn btn-sm btn-danger" v-on:click="p.deleting = false">No</button>
                                    </div>
                                </div>
                            </a>
                        </div>
                        <div v-if="savedPagesLoading">
                            <div class="m-2">
                                <i class="fas fa-fw text-primary fa-circle-notch fa-spin"></i>Loading
                            </div>
                        </div>
                        <div v-if="savedPages.length == 0 && !savedPagesLoading">
                            <h5 class="p-2">You don't have any saved bookmarks, yet.</h5>
                        </div>
                        <div class="card-footer">
                            <i class="fas fa-arrow-to-right text-danger"></i>
                            <a href="#" v-on:click.prevent="showAllSaved('pages', savedPages)"> See all favorites</a>                            
                        </div>
                    </div>
                    <!-- User saved searches -->
                    <div class="card mt-4 shadow">
                        <div class="card-header bg-primary">
                            <div class="row">
                                <div class="col-8">
                                    <h5 class="mt-1 text-white">
                                        <i class="fad fa-list"></i><span class="ml-2"> Saved Searches </span>
                                    </h5>
                                </div>
                                <div class="col-4">
                                    <h5 class="float-right">
                                        <span class="badge badge-secondary">{{ savedSearches.length }} search<span v-if="savedSearches.length != 1">es</span></span>
                                    </h5>
                                </div>
                            </div>
                        </div>
                        <div v-if="savedSearches.length > 0 && !savedSearchesLoading" class="list-group list-group-flush">
                            <a href="#" v-for="(s, key) in savedSearches.slice(0, 5)" :key="key" class="list-group-item list-group-item-action list-group-item-light">
                                <div class="row">
                                    <div class="col-8">
                                        <strong>                                            
                                            <router-link tag="a" exact :to="{
                                                name: s.route_name,
                                                params: {
                                                    loadExistingSearch: true,
                                                    userID: s.userid,
                                                    saveID: s.saveid
                                                }, }">{{ s.save_name }}</router-link>
                                        </strong>
                                        <div>Found {{parseInt(s.record_count).toLocaleString() }} record<span v-if="s.record_count != 1">s</span></div>
                                        <div class="list-detail">Type: {{ s.search_type }} | Last edited on {{ s.time_saved }}</div>
                                    </div>
                                </div>
                            </a>
                        </div>
                        <div v-if="savedSearchesLoading">
                            <div class="m-2"><i class="fas fa-fw text-primary fa-circle-notch fa-spin"></i>Loading
                            </div>
                        </div>
                        <div v-if="savedSearches.length == 0 && !savedSearchesLoading">
                            <h5 class="p-2">You don't have any saved searches, yet.</h5>
                        </div>
                        <div class="card-footer">
                            <i class="fas fa-arrow-to-right text-danger"></i>
                            <a href="#" v-on:click.prevent="showAllSaved('searches', savedSearches)"> See all saved searches</a>                                        
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <show-all :records="records" :listType="listType"></show-all>
    </div>
</template>
<script>
import showAll from './showAll';
export default {   
    components: {
       showAll: showAll
    },
    data: function () {
        return {
            name: this.$root.user.display_name.split('+').join(' '),
            savedLists: [],
            savedListsLoading: false,
            savedPages: [],
            savedPagesLoading: false,
            savedSearches: [],
            savedSearchesLoading: false,
            records: [],
            listType: ''
        }
    },
    watch: {
        '$root.user': {
            deep: true,
            handler(newVal) {
                if (newVal.userid > '') {
                    this.name = this.$root.user.display_name.split('+').join(' ')
                }
            }
        },
        name: {
            handler: 'initializePage',
            deep: true,
        },
    },
    created: function () {},
    mounted: function () {
        if (this.$root.loggedIn) {
            this.getUserLists();
            this.getSavedPages();
            this.getSavedSearches();
        }
        if (localStorage.getItem('loggedOut') == 'true') {
        //  this.$root.setAlert(true, 'You have been logged out successfully', 'alert-success');
            localStorage.clear();
        }
    },
    methods: {
        showAllSaved: function(type, data) {
            this.listType = type;
            this.records = data;
            $('#niShowAll').modal('show'); 
        },
        getUserLists: function() {  
            if (this.$root.user.userid > '') {          
                this.savedListsLoading = true;
                var _this = this;
                var data = {                                
                    userid: this.$root.user.userid,
                    token: [{userid: this.$root.user.userid, token: this.$root.user.auth_token}]
                };  
                this.axios.get(this.$root.baseURI+'/user-favorites/get.saved-lists', {                    
                    params: data
                }).then(function (response) {                         
                    _this.$root.handleTokenError(response.data);                           
                    _this.savedListsLoading = false;                                 
                    if (response.data.error) {
                        _this.$root.setAlert(true, response.data.error, 'alert-danger');
                        return;
                    } else {
                        if (response.data.length) {                                      
                            _this.savedLists = response.data;                        
                        }
                    }
                }).catch(error => {
                    _this.savedListsLoading = false;
                    _this.$root.setAlert(true, error, 'alert-danger');
                    return;
                });
            }  
        },
        getSavedPages: function() {  
            if (this.$root.user.userid > '') {          
                this.savedPagesLoading = true;
                var _this = this;
                var data = {                                
                    userid: this.$root.user.userid,
                    token: [{userid: this.$root.user.userid, token: this.$root.user.auth_token}]
                };  
                this.axios.get(this.$root.baseURI+'/user-favorites/get.saved-pages', {                    
                    params: data
                }).then(function (response) {     
                    _this.$root.handleTokenError(response.data);                           
                    _this.savedPagesLoading = false;                                 
                    if (response.data.error) {
                        _this.$root.setAlert(true, response.data.error, 'alert-danger');
                        return;
                    } else {
                        if (response.data.length) {                                      
                            _this.savedPages = response.data;                        
                        }
                    }
                }).catch(error => {
                    _this.savedPagesLoading = false;
                    _this.$root.setAlert(true, error, 'alert-danger');
                    return;
                });
            }  
        },
        getSavedSearches: function() {  
            if (this.$root.user.userid > '') {          
                this.savedSearchesLoading = true;
                var _this = this;
                var data = {                                
                    userid: this.$root.user.userid,
                    token: [{userid: this.$root.user.userid, token: this.$root.user.auth_token}]
                };  
                this.axios.get(this.$root.baseURI+'/user-favorites/get.saved-searches', {                    
                    params: data
                }).then(function (response) {     
                    _this.$root.handleTokenError(response.data);                           
                    _this.savedSearchesLoading = false;                                 
                    if (response.data.error) {
                        _this.$root.setAlert(true, response.data.error, 'alert-danger');
                        return;
                    } else {
                        if (response.data.length) {                                      
                            _this.savedSearches = response.data;                        
                        }
                    }
                }).catch(error => {
                    _this.savedSearchesLoading = false;
                    _this.$root.setAlert(true, error, 'alert-danger');
                    return;
                });
            }  
        }       
    }
}    
</script>
<style lang="scss" scoped>
@import "assets/nexusStyle.css";

//.card{
//  border-radius: 4px;
//  background: #fff;
//  box-shadow: 0 6px 10px rgba(0,0,0,.08), 0 0 6px rgba(0,0,0,.05);
//  transition: .3s transform cubic-bezier(.155,1.105,.295,1.12),.3s box-shadow,.3s -webkit-transform cubic-bezier(.155,1.105,.295,1.12);
//  cursor: pointer;
//}
//
//.card:hover{
//  transform: scale(1.01);
//  box-shadow: 0 10px 20px rgba(0,0,0,.12), 0 4px 8px rgba(0,0,0,.06);
//}


.list-detail {
  font-size: 0.8rem;
}

.text-info {
  padding-right: 0.25rem;
}

/* .container, .container-lg, .container-md, .container-sm {
    max-width: 1150px !important;
} */
</style>