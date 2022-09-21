<template>
<div class="container">         
    <div v-if="!$root.loggedIn">
        <login></login>
    </div>
    <div v-else>              
        <div class="row mt-3 mb-2 border-bottom">  
            <div class="col-8">
                <h1 class="display-1"><i class="fas fa-fw text-success" :class="{'fa-history': !loading, 'fa-circle-notch fa-spin': loading}"></i> Match History</h1>
            </div>
            <div class="col-4">                 
                 <router-link tag="button" type="button" to="/home" class="mt-1 btn btn-primary btn-sm float-right"><i class="fas fa-arrow-left"></i> Back to home</router-link>
            </div>
        </div>             
        <transition name="fade" mode="out-in">
            <div v-if="!batches.length">
                <h4 class="display-4"><i class="fas fa-empty-set"></i> You have no matches to view or edit</h4>
            </div>
            <div v-else>
                <div class="row" v-if="!editing">
                    <div class="col">
                        <div class="card batch-list mb-3">
                            <ul class="list-group list-group-flush">
                                <li class="list-group-item" :key="k" v-for="(n, k) in paginatedData">                                                                            
                                    <div class="row">                                
                                        <div class="col-9 pt-1 pb-1">
                                            <h5>
                                                <status :status="n.status"></status>                                
                                                <span>{{n.matchfile_name}}</span>
                                            </h5>                                
                                        </div>
                                        <div class="col-3">                                        
                                            <div class="text-right">
                                                <div class="btn-group mt-1" v-if="downloading != k && batchDelete != k">
                                                    <button :id="'group'+k" type="button" v-on:click="setEdit(n)" class="btn btn-sm btn-primary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                        Actions
                                                    </button>
                                                    <div class="dropdown-menu-right dropdown-menu" :aria-labelledby="'group'+k">
                                                        <a v-if="n.potentialcount > 0" class="dropdown-item text-success" v-on:click.prevent="download('match', n, k)" href="#"><i class="fas fa-arrow-down"></i> Download matches</a>
                                                        <!-- <a class="dropdown-item text-primary" v-on:click.prevent="download('original', n, k)" href="#"><i class="fas fa-download"></i> Download original file</a> -->
                                                        <a class="dropdown-item text-primary" disabled="disabled"  href="#"><i class="fas fa-download"></i> Download original file</a>
                                                        <!-- <a class="dropdown-item text-info" v-on:click.prevent="n.restarting = true; n.deleting = false" href="#"><i class="fas fa-redo"></i> Restart matching</a>
                                                        <a v-if="n.status != 'COMPLETE'" class="dropdown-item text-warning" v-on:click.prevent="cancel(n)" href="#"><i class="fas fa-ban"></i> Cancel matching</a> -->
                                                        <a class="dropdown-item text-danger" v-on:click.prevent="n.deleting = true; n.restarting = false;" href="#"><i class="fas fa-trash"></i> Delete batch</a>                                                    
                                                        <div class="dropdown-divider"></div>
                                                        <a class="dropdown-item text-warning" v-on:click.prevent="setMatchRoute(n)" href="#"><i class="fas fa-wrench"></i> Resolve potential matches</a>                                                                                                                
                                                    </div>
                                                </div>
                                                <button type="button" disabled="disabled" v-if="downloading == k" class="mt-1 btn btn-sm btn-primary">
                                                    <i class="fas fa-circle-notch fa-spin"></i> Downloading
                                                </button>                                                                                
                                                <button type="button" disabled="disabled" v-if="batchDelete == k" class="mt-1 btn btn-sm btn-primary">
                                                    <i class="fas fa-circle-notch fa-spin"></i> Deleting
                                                </button>   
                                            </div>
                                        </div>
                                    </div>
                                    <div v-if="n.deleting || n.restarting" class="row">
                                        <div class="col mb-2 text-right">
                                            <strong>Are you sure?</strong>
                                            <button type="button" v-if="n.restarting" v-on:click="restart(n)" class="btn btn-sm btn-success">Yes</button>
                                            <button type="button" :disabled="batchDelete == k" v-if="n.deleting" v-on:click="deleteBatch(k, n)" class="btn btn-sm btn-success">Yes</button>
                                            <button type="button" :disabled="batchDelete == k" v-on:click="n.deleting = false; n.restarting = false;" class="btn btn-sm btn-danger">No</button>
                                        </div>
                                    </div>
                                    <hr>
                                    <div class="row p-1">   
                                        <div class="col-6"> 
                                            <div class="row">
                                                <div class="col-5"><strong>Date added</strong></div>
                                                <div class="col-7">
                                                    <span>{{n.date_submitted}}</span>
                                                </div>                                            
                                            </div>                                                                          
                                            <div class="row">
                                                <div class="col-5"><strong>Date completed</strong></div>
                                                <div class="col-7">
                                                    <span>{{n.date_completed}}</span>
                                                </div>
                                            </div>                                                                                                              
                                        </div>                                
                                        <div class="col-6">
                                            <div class="row">
                                                <div class="col-6"><strong>Match attempts</strong></div>
                                                <div class="col-6">{{n.matchcount}}</div>
                                            </div>                                                                          
                                            <div class="row">
                                                <div class="col-6"><strong>Matches</strong></div>
                                                <div class="col-6">
                                                    {{n.matched}}                                                
                                                </div>
                                            </div>                                                                          
                                            <div class="row">
                                                <div class="col-6"><strong>Potential matches</strong></div>
                                                <div class="col-6">
                                                    {{n.potentialcount}}                                                
                                                </div>
                                            </div>                                    
                                            <div class="row">
                                                <div class="col-6"><strong>Not found</strong></div>
                                                <div class="col-6">
                                                    {{n.unmatched}}                                                
                                                </div>
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
                </div>
                <match v-if="editing"></match>
            </div>
        </transition>

    </div>
</div>
</template>
<script>
import status from './status.vue';
import match from './match.vue';
export default {   
    components: {        
        status: status,
        match: match
    },
    data: function() {
        return {      
            matches: [],
            loading: false,
            matchLoading: false,
            downloading: null,
            batchDelete: null,
            editing: false,            
            batches: [],
            userid: this.$route.params.userid,
            matchid: this.$route.params.matchid,
            currentRecord: {},
            size: 5,
            pageNumber: 0               
            
        }
    },
    methods: {
        download: function(flag, batch, key) {
            this.downloading = key;            
            var _this = this;
            var url = '';
            var filename = '';            
            switch (flag) {
               case 'match':
                    url = this.$root.baseURI+'/history/download.match'; 
                    filename = 'matched_'+batch.matchfile_name;                    
                break;
                case 'original':
                    url = this.$root.baseURI+'/history/download.original';
                    filename = batch.matchfile_name;                                                            
                break;
            }
            var formData = new FormData();
            formData.append('userid', batch.userid);
            formData.append('matchid', batch.matchid);
            formData.append('token', JSON.stringify([{userid: this.$root.user.userid, token: this.$root.user.auth_token}]));
            this.axios.post(url, formData, {
                headers: { 'Content-Type': 'multipart/form-data' },
                responseType: 'blob'                
            }).then(response => {                      
                if (response.data.type == 'text/html') {
                    var d = new Blob([response.data]);
                    var r = new FileReader();
                    r.addEventListener('loadend', (e) => {
                        const err = e.target.result;
                        _this.$root.handleTokenError(err);  
                        _this.$root.setAlert(true, err, 'alert-danger');
                    });
                    r.readAsText(d);                                        
                    _this.downloading = null;
                    return;
                }                                        
                if (response.data.error) {
                    _this.$root.setAlert(true, response.data.error, 'alert-danger');
                    _this.downloading = null;
                    return;
                } else {                       
                    const url = window.URL.createObjectURL(new Blob([response.data]));
                    const link = document.createElement('a');
                    link.href = url;
                    link.setAttribute('download', filename);
                    document.body.appendChild(link);
                    link.click();
                    _this.downloading = null;        
                }
            }).catch(error => {
                _this.$root.setAlert(true, error, 'alert-danger');
                _this.downloading = null;
                return;
            });    
        },
        setEdit: function(record) {
            this.currentRecord = record;
        },           
        setMatchRoute: function(record) {            
            if (!record) {
                this.router.push({name: 'history', params: {}});
            } else {                
                var params = {
                    userid: record.userid, 
                    matchid: record.matchid
                };
                this.router.push({name: 'history', params: params});
            }
        },
        matchPotentials: function(userid, matchid) {   
            var _this = this;                     
            var params = {
                userid: userid,
                matchid: matchid,
                token: [{userid: this.$root.user.userid, token: this.$root.user.auth_token}]
            };
            if (params.userid && params.matchid) {
                this.editing = true;
                this.matchLoading = true;
                this.axios.get(this.$root.baseURI+'/history/potential.data', {
                    params: params
                }).then(response => {  
                     _this.$root.handleTokenError(response.data);                   
                    if (response.data.error) {                    
                        this.$root.setAlert(true, response.data.error, 'alert-danger');
                        return;
                    } else {                                             
                        this.detail = response.data[0];                               
                        this.matches = []; 
                        for (var i = 0; i < response.data[1].length; i++) {                        
                            for (var j = 0; j < response.data[1][i].potentials.length; j++) {
                                response.data[1][i].potentials[j].showMatched = 'less';                                                                
                            }
                            this.matches.push(response.data[1][i]);
                        }     
                        this.matchLoading = false;                                                                                     
                    }                                         
                }).catch(error => {
                    this.$root.setAlert(true, error, 'alert-danger');
                    return;
                });
            } else {
                this.editing = false;
            }   
        },
        deleteBatch: function(k, batch) {
            var _this = this;    
            this.batchDelete = k;        
            var data = {                                
                userid: this.$root.user.userid,
                matchid: batch.matchid,
                token: [{userid: this.$root.user.userid, token: this.$root.user.auth_token}]
            };  
            this.axios.get(this.$root.baseURI+'/history/match.delete', {                    
                params: data
            }).then(function (response) {     
                _this.batchDelete = null;                              
                _this.$root.handleTokenError(response.data);                             
                if (response.data.error) {                    
                    _this.$root.setAlert(true, response.data.error, 'alert-danger');
                    return;
                } else {
                    _this.getMatches();                    
                }
            }).catch(error => {                
                _this.batchDelete = null;                              
                _this.$root.setAlert(true, error, 'alert-danger');
                return;
            });  
        },
        getMatches: function() {
            var _this = this;
            var data = {                                
                userid: this.$root.user.userid,
                token: [{userid: this.$root.user.userid, token: this.$root.user.auth_token}]
            };  
            this.axios.get(this.$root.baseURI+'/history/matches.get', {                    
                params: data
            }).then(function (response) {                 
                _this.$root.handleTokenError(response.data);                                    
                _this.loading = false;                                 
                if (response.data.error) {
                    _this.$root.setAlert(true, response.data.error, 'alert-danger');
                    return;
                } else {
                    if (response.data.length) {
                        for (var i = 0; i < response.data.length; i++) {
                            response.data[i].deleting = false;
                            response.data[i].restarting = false;
                        }                
                        _this.batches = response.data;                        
                    } else {
                        _this.batches = [];
                        //_this.$root.setAlert(true, 'Cound not get match history', 'alert-warning');
                        return;
                    }
                }
            }).catch(error => {
                _this.$root.setAlert(true, error, 'alert-danger');
                return;
            });  
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
        }        
       
    },
    computed: {
        pageCount: function() {
            let l = this.batches.length;
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
            return this.batches.slice().slice(s, e);            
        }       
    },
    watch: {        
        '$route': function() {            
            this.matchPotentials(this.$route.params.userid, this.$route.params.matchid);             
            this.matchid = this.$route.params.matchid;
        }
    },        
    mounted: function() {        
        if (!this.matches.length) {
            this.getMatches();
            this.matchPotentials(this.$route.params.userid, this.$route.params.matchid);  
            this.matchid = this.$route.params.matchid;
        }
    }
}
</script>
<style scoped>
.mapped {
    background-color: #cce5ff;
}
.table thead th {
    vertical-align: top;
}
.mapping, .mapping  select{
    width: 230px;   
}

.custom-control-label {
    font-size: 1.25rem;
}

.custom-control-label::before,
.custom-control-label::after {
    top: .45rem;
    width: 1.25rem;
    height: 1.25rem;
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

</style>