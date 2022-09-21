<template>
    <div style="margin: 10px auto 80px auto; padding-bottom: 80px;">
        <div class="row border-bottom pb-1 mb-1">
            <div class="col-12 mt-1 pb-2 border-bottom">
                <div class="row">
                    <div class="col-10">
                        <h3 class="display-3"><i class="text-success" :class="{'fad fa-user-friends': !$parent.matchLoading, 'fas fa-circle-notch fa-spin': $parent.matchLoading}"></i> 
                            <span v-if="$parent.matchLoading">Loading, please wait...</span>
                            <span v-else>Matching entities from upload "{{$parent.detail[0].matchfile_name}}"</span>
                        </h3>
                    </div>
                    <div class="col-2">
                        <button type="button" v-on:click="$parent.setMatchRoute(false)" class="mt-1 btn btn-primary btn-sm float-right"><i class="fas fa-arrow-left"></i> Back to history</button>
                    </div>
                </div>
            </div>
            <div class="col-12 m-2 pt-2" v-if="!$parent.matchLoading">
                <div class="row">
                    <div class="col-1 mt-1 pr-0 pl-0"><span class="h5"><i class="fad fa-filter"></i> Filters: </span></div>
                    <div class="col-6 mt-1">
                        <span class="custom-control custom-switch ml-3"><input type="checkbox" class="custom-control-input" v-model="showMatched" id="showMatched"><label class="custom-control-label" for="showMatched">Matched records</label></span>
                        <span class="custom-control custom-switch ml-3"><input type="checkbox" class="custom-control-input" v-model="showPotential" id="showPotential"><label class="custom-control-label" for="showPotential">Potential matches</label></span>
                        <span class="custom-control custom-switch ml-3"><input type="checkbox" class="custom-control-input" v-model="showNomatch" id="showNomatch"><label class="custom-control-label" for="showNomatch">No matches</label></span>
                    </div>
                    <div class="col-5">
                        <div class="input-group">
                            <input type="text" class="form-control" placeholder="Filter by name" v-model="search">
                            <div class="input-group-append">
                                <button type="button" :disabled="search == ''" v-on:click="search = ''" class="btn btn-danger">Clear</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="mt-3" v-if="!$parent.matchLoading && matches.length">
            <div id="donor-listing">
                <div class="card" :key="x" v-for="(t, x) in paginatedData">
                    <div class="card-header" :class="{'bg-success text-white': t.matched_voter_id > '', 'bg-secondary text-white': t.potentials.length == 0}">
                        <!-- collapse header, donor name and amount -->
                        <div class="float-left">
                            <strong class="mb-0" data-toggle="collapse" :data-target="'#collapse-'+t.queueid" aria-expanded="true" :aria-controls="'collapse-'+t.queueid">
                            <span>Batch record {{t.queueid}}: </span>
                            <span v-if="t.first_name || t.middle_name || t.last_name || t.name_suffix" v-html="$options.filters.highlight(entityName(t, 'entity'), search)"></span>
                            </strong>
                            <div>{{t.potentials.length}} potential match<span v-if="t.potentials.length != 1">es</span></div>
                        </div>
                        <div v-if="t.matched_voter_id > ''" class="float-right">
                            <div>
                                <voter-status :data="t"></voter-status>
                                <strong>Matched ID Number: {{t.matched_voter_id}}</strong>
                            </div>
                            <button type="button" class="btn float-right btn-sm btn-warning" :disabled="t.DONOR_CLEAR" v-on:click="setMatch(t, null)">
                            <span><i class="fas fa-ban"></i> Clear</span>
                            </button>
                        </div>
                    </div>
                    <!-- collapse body -->
                    <div class="collapse container-fluid p-0" :id="'collapse-'+t.queueid">
                        <div class="row">
                            <div class="col-lg-6 col-md-12 pr-lg-0">
                                <h5 class="bg-secondary p-2 m-0">Provided information</h5>
                                <div class="container-fluid donor">
                                    <!-- Names -->
                                    <div class="row" v-if="t.first_name || t.middle_name || t.last_name || t.name_suffix">
                                        <div class="col-3 bg-light">Name</div>
                                        <div class="col">{{entityName(t, 'entity')}}</div>
                                    </div>
                                    <!-- Address -->
                                    <div class="row" v-if="t.residence_num || t.residence_halfnum || t.residence_aptnum || t.residence_pre_street_dir || t.residence_street_name || t.residence_post_street_dir || t.residence_city || t.residence_zip || t.residence_zip_4">
                                        <div class="col-3 bg-light">Address</div>
                                        <div class="col">
                                            <div v-if="t.residence_num || t.residence_halfnum || t.residence_aptnum || t.residence_pre_street_dir || t.residence_street_name || t.residence_post_street_dir || t.residence_city || t.residence_zip || t.street_address_1 || t.street_address_2">
                                                {{address(t, 'residenceNum')}}
                                            </div>
                                            <span v-if="t.residence_city">{{t.residence_city}}</span> <span v-if="t.residence_zip">{{t.residence_zip}}</span><span v-if="t.residence_zip_4">-{{t.residence_zip_4}}</span>
                                        </div>
                                    </div>
                                    <!-- Address -->
                                    <div class="row" v-if="t.mailing_address_1 || t.mailing_address_2 || t.mailing_address_3 || t.mailing_address_4">
                                        <div class="col-3 bg-light">Mailing address</div>
                                        <div class="col">
                                            {{address(t, 'mailingAddress')}}
                                        </div>
                                    </div>
                                    <!-- Telephone -->
                                    <div v-if="t.telephone" class="row">
                                        <div class="col-3 bg-light">Telephone</div>
                                        <div class="col">
                                            <div>
                                                {{phoneFormat(t.telephone)}}
                                            </div>
                                        </div>
                                    </div>
                                    <!-- Email -->
                                    <div v-if="t.email" class="row">
                                        <div class="col-3 bg-light">Email</div>
                                        <div class="col">
                                            <div>
                                                {{t.email}}
                                            </div>
                                        </div>
                                    </div>
                                    <!-- Birth date -->
                                    <div class="row" v-if="t.date_of_birth">
                                        <div class="col-3 bg-light">Birth date</div>
                                        <div class="col">{{t.date_of_birth}}</div>
                                    </div>
                                    <!-- age -->
                                    <div class="row" v-if="t.birth_year">
                                        <div class="col-3 bg-light">Age</div>
                                        <div class="col">{{t.birth_year}}</div>
                                    </div>
                                    <!-- Gender -->
                                    <div class="row" v-if="t.gender">
                                        <div class="col-3 bg-light">Gender</div>
                                        <div class="col">{{getGender(t.gender)}}</div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-6 col-md-12 pl-lg-0">
                                <h5 class="bg-secondary p-2 m-0" style="border-left: 1px solid #FFF">Potential matches</h5>
                                <div v-if="t.potentials.length">
                                    <div :key="i" class="container-fluid p-0 potentials" :class="{'matched': t.matched_voter_id == d.nys_voter_id}"  v-for="(d, i) in t.potentials">
                                        <div class="container-fluid donor" :id="'potential-'+i">
                                            <!-- Match -->
                                            <div class="row">
                                                <div class="col" :class="matchClass(d)">
                                                    <div class="clearfix">
                                                        <div class="float-left">
                                                            <strong>{{match(d)}}</strong>
                                                        </div>
                                                        <div class="float-right">
                                                            <button type="button" v-on:click="setMatch(t, d.nys_voter_id)" :disabled="t.matched_voter_id == d.nys_voter_id" class="btn btn-sm btn-primary">
                                                            <span v-if="t.matched_voter_id == d.nys_voter_id">Matched</span>
                                                            <span v-else>Set as match</span>
                                                            </button>
                                                        </div>
                                                    </div>
                                                    <div v-if="d.showMatched == 'less'" class="float-left">Matched on {{matchedOn(d).trunc}} <span  v-if="matchedOn(d).toggle" v-on:click="d.showMatched = 'more'" class="badge badge-primary">More</span></div>
                                                    <div v-if="d.showMatched == 'more'" class="float-left">Matched on {{matchedOn(d).full}} <span v-on:click="d.showMatched = 'less'" class="badge badge-primary">Less</span></div>
                                                </div>
                                            </div>
                                            <!-- Names -->
                                            <div class="row" v-if="t.first_name || t.middle_name || t.last_name || t.name_suffix">
                                                <div class="col-3 bg-light">Name</div>
                                                <div class="col">{{entityName(d, 'entity')}}</div>
                                            </div>
                                            <!-- Address -->
                                            <div class="row" v-if="d.residence_num || d.residence_halfnum || d.residence_aptnum ||
                                                d.residence_pre_street_dir || d.residence_street_name || d.residence_post_street_dir || d.residence_city || d.residence_zip || d.residence_zip_4">
                                                <div class="col-3 bg-light">Address</div>
                                                <div class="col">
                                                    <div v-if="d.residence_num || d.residence_halfnum || d.residence_aptnum || d.residence_pre_street_dir || d.residence_street_name || d.residence_post_street_dir">
                                                        {{address(d, 'residenceNum')}}
                                                    </div>
                                                    <div>
                                                        <span v-if="d.residence_city">{{d.residence_city}}</span>
                                                        <span v-if="d.residence_zip">{{d.residence_zip}}</span><span v-if="d.residence_zip_4">-{{d.residence_zip_4}}</span>
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- Address -->
                                            <div class="row" v-if="d.mailing_address_1 || d.mailing_address_2 || d.mailing_address_3 || d.mailing_address_4">
                                                <div class="col-3 bg-light">Mailing address</div>
                                                <div class="col">
                                                    <div v-if="d.mailing_address_1">{{d.mailing_address_1}}</div>
                                                    <div v-if="d.mailing_address_2">{{d.mailing_address_2}}</div>
                                                    <div v-if="d.mailing_address_3">{{d.mailing_address_3}}</div>
                                                    <div v-if="d.mailing_address_4">{{d.mailing_address_4}}</div>
                                                </div>
                                            </div>
                                            <!-- Telephone -->
                                            <div v-if="d.telephone" class="row">
                                                <div class="col-3 bg-light">Telephone</div>
                                                <div class="col">
                                                    <div>
                                                        {{phoneFormat(d.telephone)}}
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- Email -->
                                            <div v-if="d.email" class="row">
                                                <div class="col-3 bg-light">Email</div>
                                                <div class="col">
                                                    <div>
                                                        {{d.email}}
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- Birth date -->
                                            <div v-if="d.date_of_birth">
                                                <div class="row">
                                                    <div class="col-3 bg-light">Birth date</div>
                                                    <div class="col">{{getAge('dob', d.date_of_birth)}}</div>
                                                </div>
                                                <div class="row" v-if="d.date_of_birth">
                                                    <div class="col-3 bg-light">Age</div>
                                                    <div class="col">{{getAge('age', d.date_of_birth)}}</div>
                                                </div>
                                            </div>
                                            <!-- Gender -->
                                            <div class="row" v-if="d.gender">
                                                <div class="col-3 bg-light">Gender</div>
                                                <div class="col">{{getGender(d.gender)}}</div>
                                            </div>
                                            <div class="row" v-if="d.voter_status">
                                                <div class="col-3 bg-light" :class="{'purged': d.voter_status == 'PURGED' || d.voter_status == 'INACTIVE'}">Voter status</div>
                                                <div class="col">{{d.voter_status}}</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div v-if="t.potentials.length == 0" class="container-fluid p-0 potentials">
                                    <h5 class="m-2">No potential matches found</h5>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- end donor -->
            </div>
            <div class="row">
                <div class="col-3">
                    <button class="btn btn-primary" type="button" :disabled="pageNumber == 0" v-on:click="setPage(0)"><i class="fas fa-chevron-circle-left"></i> First</button>
                    <!-- <button class="btn btn-primary" type="button" :disabled="pageNumber - 9 <= 0" v-on:click="setPage(pageNumber - 10)"><i class="fas fa-chevron-left"></i> Back 10</button> -->
                    <button class="btn btn-primary" type="button" :disabled="pageNumber == 0" v-on:click="prevPage()"><i class="fas fa-chevron-left"></i> Back</button>
                </div>
                <div class="col-6" style="text-align: center">
                    <h5 v-if="pageCount">page {{pageNumber + 1}} of {{pageCount}}</h5>
                </div>
                <div class="col-3">
                    <button class="float-right btn btn-primary" type="button" :disabled="pageNumber == pageCount - 1 || !pageCount" v-on:click="setPage(pageCount - 1)">Last <i class="fas fa-chevron-circle-right"></i></button>
                    <!--<button class="float-right btn btn-primary mr-1" type="button" :disabled="pageNumber + 10 >= pageCount" v-on:click="setPage(pageNumber + 10)">Forward 10 <i class="fas fa-chevron-right"></i></button>-->
                    <button class="float-right btn btn-primary mr-1" type="button" :disabled="pageNumber == pageCount - 1 || !pageCount" v-on:click="nextPage()">Forward <i class="fas fa-chevron-right"></i></button>
                </div>
            </div>
        </div>
    </div>
</template>
<script>

import voterStatus from './voter.status.vue';
export default {   
    components: {
        voterStatus:  voterStatus
    },
    data: function() {
        return {
            id_number: '',   
            transaction: {},
            size: 8,
            pageNumber: 0,
            entityCreating: false,
            search: '',
            idSearch: [],
            potentials: [],
            showMatched: true,
            showPotential: true,
            showNomatch: true,
            matchData: {NOTE: ''},
            matches: JSON.parse(JSON.stringify(this.$parent.matches))
        }
    },
    methods: {
        getGender: function(gender) {
            var out = 'Not specified';
            switch (gender.toUpperCase()) {
                case 'M':
                    out = 'Male';
                break;
                case 'F':
                    out = 'Female';
                break;
            }
            return out;
        },
        getAge: function(flag, dateString) {
            var year        = dateString.substring(0,4);
            var month       = dateString.substring(4,6);
            var day         = dateString.substring(6,8);
            var out = dateString;
            var currentDate = new Date();
            switch (flag) {
                case 'dob':
                    out = month+'/'+day+'/'+year;
                break;
                case 'age':
                    out = currentDate.getFullYear() - parseInt(year);
                break;
            }
            return out;
        },
        setMatch: function(record, voterid) {
            var params = {
                matchid: this.$parent.matchid,
                queueid: record.queueid,
                voterid: voterid,
                token: [{userid: this.$root.user.userid, token: this.$root.user.auth_token}]
            };            
            var _this = this;
            this.axios.get(this.$root.baseURI+'/history/match.set', {
                params: params
            }).then(response => {                                
                _this.$root.handleTokenError(response.data);                         
                if (response.data.error) {                    
                    this.setAlert(true, response.data.error, 'alert-danger');
                    return;
                } else {        
                    record.matched_voter_id = voterid;
                    this.setAlert(true, 'Record updated successfully', 'alert-success');
                    return;
                }
            }).catch(error => {
                this.setAlert(true, error, 'alert-danger');
                return;
            });
        },
        matchClass: function(record) {
            var m = '';
            if (record.score > 100) {
                m = 'bg-success text-white';
            } else if (record.score > 50 && record.score <= 99) {
                m = 'bg-warning';
            } else {
                m = 'bg-danger text-white';
            }
            return m;
        },
        match: function(record) {
            var m = '';
            if (record.score > 100) {
                m = 'Likely match';
            } else if (record.score > 50 && record.score <= 99) {
                m = 'Possible match';
            } else {
                m = 'Unlikely match';
            }
            return m;
        },
        matchedOn: function(record) {
            var arr = record.matched_on.split("|");
            var mArr = [];
            arr = arr.filter((v, i, a) => a.indexOf(v) === i);
            for (var i = 0; i < arr.length; i++) {
                switch (arr[i]) {
                    case 'FULLNAMEADDREXACT':
                        mArr.push("full name and address");
                    break;
                    case 'FNLNCITYSTREETEXACT':
                        mArr.push("first and last name/street and city");
                    break;
                    case 'STREETZIPLNAMEFNAMEEXACT':
                        mArr.push("first and last name/street and zipcode");
                    break;
                    case 'FULLNAMEMAILINGEXACT':
                        mArr.push("full name and mailing address");
                    break;
                    case 'FNAMELNAMEMAILINGRESIDENCEEXACT':
                        mArr.push("first and last name/mailing address is reaidence address");
                    break;
                    case 'FNAMELNAMERESIDENCEMAILINGEXACT':
                        mArr.push("first and last name/residence address is mailing address");
                    break;
                    case 'FNAMELNAMEPREVIOUSMAILINGEXACT':
                        mArr.push("first and last name/previous address is mailing address");
                    break;
                    case 'FNAMELNAMEPREVIOUSRESIDENCEEXACT':
                        mArr.push("first and last name/previous address is residence address");
                    break;
                    case 'FNAMELNAMERESIDENCEPREVIOUSEXACT':
                        mArr.push("first and last name/residence address is previous address");
                    break;
                    case 'FNAMELNAMEMAILINGPREVIOUSEXACT':
                        mArr.push("first and last name/mailing address is previous address");
                    break;
                    case 'FNAMELNAMEMAILINGEXACT':
                        mArr.push("first and last name/mailing address");
                    break;
                    case 'FNPARTLNRNUMSTREET':
                        mArr.push("last name and partial first name/street name and number");
                    break;
                    case 'FNPARTLNCITYRNUM':
                        mArr.push("last name and partial first name/city and residence number");
                    break;
                    case 'FINITIALLNMAILINGLIKE':
                        mArr.push("last name and partial first name/similar mailing address");
                    break;
                    case 'LNPARTRNUMZIPGENDERPARTSTREET':
                        mArr.push("last name and partial street name/zipcode/partial residence number");
                    break;
                    case 'LNFNADDRESSEXACT': 
                        mArr.push("address/first and last name");
                    break;
                    case 'LNAMEFNAMEDOBEXACT':
                        mArr.push("first and last name/date of birth");
                    break;
                    case 'LNFNDOBADDRESSEXACT':
                        mArr.push("first and last name/date of birth/address");
                    break;                    
                    case 'EMAILEXACT':
                        mArr.push("e-mail");
                    break;
                    case 'PHONEEXACT':
                        mArr.push("telephone");
                    break;
                    case 'FULLNAMECITY':
                        mArr.push("full name and city");
                    break;
                    case 'FUZZYFULLNAMEADDRESSEXISTS':
                    case 'FUZZYFULLNAMEADDRESS':
                        mArr.push("similar full name or similar address");
                    break;
                    case 'FUZZYFNAMELNAMECITYEXISTS':
                        mArr.push("similar first and last name and city");
                    break;
                    case 'FUZZYFNAMELNAMEZIP':
                        mArr.push("similar first and last name/zipcode");
                    break;
                }
            }
            var str = mArr.join(", ");
            var trunc = str;
            var toggle = false;
            if (str.length > 50) {
                trunc = str.substring(0,50)+'...';
                toggle = true;
            }
            return {trunc: trunc, full: str, toggle: toggle};
        },
        nextPage: function() {
            if (this.pageNumber < this.pageCount) {
                this.pageNumber++;
                this.switchPage();
            }
        },
        prevPage: function() {
            if (this.pageNumber > 0) {
                this.pageNumber--;
                this.switchPage();
            }
        },
        setPage: function(p) {
            this.pageNumber = p;
            this.switchPage();
        },
        switchPage: function() {
            $('.collapse').addClass('no-transition').collapse('hide').removeClass('no-transition');
        },
        setAlert: function(display, message, css, icon) {
            this.$parent.$parent.setAlert(display, message, css, icon);
        },
        clearAlert: function() {
            this.$root.clearAlert();
        },
        address: function(record, flag) {
            var arr = [];
            switch (flag) {
                case 'residenceNum':
                    if (record.street_address_1 || record.street_address_2) {
                        arr = new Array(record.street_address_1, record.street_address_2);
                    } else {
                        arr = new Array(record.residence_num, record.residence_halfnum, record.residence_aptnum, record.residence_pre_street_dir, record.residence_street_name, record.residence_post_street_dir);
                    }
                break;
                case 'mailingAddress':
                    arr = new Array(record.mailing_address_1, record.mailing_address_2, record.mailing_address_3, record.mailing_address_4);
                break;
            }
            var out = '';
            for (var i = 0; i < arr.length; i++) {
                out += (arr[i] || '') + ' ';
            }
            out = out.trim();
            return out;
        },
        entityName: function(record, flag) {
            var arr = [];
            switch (flag) {
                case 'match':
                    if (record.ORG_NAME.trim() > ' ') {
                        arr = new Array(record.ORG_NAME);
                    } else {
                        arr = new Array(record.R_FIRST_NAME, record.R_MIDDLE_NAME, record.R_LAST_NAME);
                    }
                break;
                case 'entity':
                    arr = new Array(record.first_name, record.middle_name, record.last_name, record.name_suffix);
                break;
            }
            var out = '';
            for (var i = 0; i < arr.length; i++) {
                out += (arr[i] || '') + ' ';
            }
            out = out.trim();
            return out;
        },
        phoneFormat: function(phone) {
            var out = phone;
            if (typeof(phone) == 'undefined' || phone == null) {
                out = '';
            } else {
                switch (phone.length) {
                    case 10:
                        out = '('+phone.substr(0,3)+') '+phone.substr(3,3)+'-'+phone.substr(6,4);
                    break;
                    case 7:
                        out = phone.substr(0,3)+'-'+phone.substr(3,4);
                    break;
                    case 0:
                        out = '';
                    break;
                }
            }
            return out;
        },
        queueLookup: function() {
            if (this.$route.params.queueid) {
                this.search = this.$route.params.queueid;
            }
        },
        matchFilter: function() {
            this.setPage(0);  
            this.matches = JSON.parse(JSON.stringify(this.$parent.matches));
            //All checked
            if (this.showMatched && this.showPotential && this.showNomatch) {
                return;
            }
            if (!this.showMatched) {
                this.matches = this.matches.filter(a => {
                    return a.matched_voter_id == null;
                });
            } else {
                if (!this.showPotential && !this.showNomatch) {
                    this.matches = this.matches.filter(a => {
                        return a.matched_voter_id != null;
                    });
                }
            }
    
            if (!this.showPotential) {
                if (this.showMatched) {
                    this.matches = this.matches.filter(a => {
                        return a.matched_voter_id != null || a.potentials.length == 0;
                    });
                } else {
                    this.matches = this.matches.filter(a => {
                        return a.potentials.length == 0;
                    });
                }
            } else {
                if (!this.showNomatch) {
                    this.matches = this.matches.filter(a => {
                        return a.potentials.length > 0;
                    });
                }
            }
            
            if (!this.showNomatch) {
                if (this.showMatched) {
                    this.matches = this.matches.filter(a => {
                        return a.matched_voter_id != null || a.potentials.length != 0;
                    });
                } else if (this.showPotentials) {
                    this.matches = this.matches.filter(a => {
                        return a.matched_voter_id != null;
                    });
                } else {
                    this.matches = this.matches.filter(a => {
                        return a.potentials.length != 0;
                    });
                }
            }                 
        },       
    },
    computed: {
        filteredEntities: function() {
            return this.matches.filter(match => {
                return this.entityName(match, 'entity').toLowerCase().includes(this.search.toLowerCase());
            });
        },
        pageCount: function() {
            let l = this.filteredEntities.length;
            let s = this.size;
            var c = Math.floor(l/s);
            if (l % s > 0) {
                c++;
            }
            return c;
        },
        paginatedData: function() {   
            var pn = this.pageNumber;
            if (this.pageNumber >= this.pageCount) {                
                pn = 0;
            }
            var s = pn * this.size;
            var e = s + this.size;     
            return this.matches.slice().slice(s,e);
        }
    },
    watch: {
        'showMatched': function(newVal, oldVal) {
            if (newVal != oldVal) {
                this.matchFilter();
            }
        },
        'showPotential': function(newVal, oldVal) {
            if (newVal != oldVal) {
                this.matchFilter();
            }
        },
        'showNomatch': function(newVal, oldVal) {
            if (newVal != oldVal) {
                this.matchFilter();
            }
        },
        '$parent.matches': function() {
            this.matches = JSON.parse(JSON.stringify(this.$parent.matches));
        }     
    },
    filters: {
        toFixed: function (value) {
            if (!value) {
                return 0.00;
            }
            value = parseFloat(value).toFixed(2);
            return value;
        }
    },
    created() {
    /*eventBus.$on('matches-fetched', function (data) {
    this.matches = data;
    });*/
    },
    mounted: function() {
    
    }
    }
</script>
<style scoped>
    .card {
        margin-bottom: 10px;
    }
    .card-header strong[data-toggle] {
        cursor: pointer;
        border-bottom: none;
    }
    .card-header strong[data-toggle]:hover {
        text-decoration: underline;
    }
    .bg-secondary {
        color: #FFF;
    }
    .donor .col-3, .donor .col, .potentials .col-3, .potentials .col {
        padding: 6px;
    }
    .potentials .row, .donor .row {
        border-bottom: 1px solid #DDD;
    }
    .donor .row.last {
        border-bottom: none;
    }
    .potentials .row.subsequent {
        border-top: 1px solid #DDD;
    }
    .potentials .col-3.bg-light {
        border-left: 1px solid #DDD;
    }
    .potentials {
        margin-bottom: 10px;
    }
    .matched .row {
        border-color: #c3e6cb !important;
    }
    .matched .col-3 {
        background-color: #d4edda !important;
        color: #155724 !important;
    }
    .matched .purged.col-3, .purged {
        color: #FFF !important;
        background-color: #dc3545 !important;
    }
    .bg-success .text-primary {
        color: #FFF !important;
    }
    .no-transition {
        transition: none !important;
    }
    .border-light {
        border-color: #EEE !important;
    }
    .custom-control-label::before, .custom-control-label::after {
        top: .25rem;
        height: 1rem;
    }
    .custom-control-label {
        font-size: inherit;
    }
    .custom-control {
        display: inline;
    }
    .badge:hover {
        text-decoration: underline;
        cursor: pointer;
    }
</style>