<template>
<div class="container main">         
    <div v-if="!$root.loggedIn">
        <login></login>
    </div>
    <div v-else>            
        <div class="row mt-3 mb-2 border-bottom">
            <div class="col-7">
                <h1 class="display-1">
                   <i class="fas fa-fw fa-search text-success"></i> Quick lookup     
                </h1>
            </div>  
            <div class="col-5">
                 <div class="float-right">
                    <div v-if="queryCount">                        
                        <button type="button" v-on:click="resetLookup()" class="mt-1 mr-2 btn btn-sm btn-primary"><i class="fas fa-undo"></i> Start over</button>
                        <button type="button" v-on:click="modifyLookup()" class="mt-1 mr-2 btn btn-sm btn-secondary"><i class="fas fa-pen"></i> Modify lookup</button>
                        <!-- <button type="button" :disabled="downloading" v-on:click="downloadResults()" class="mt-1 btn btn-sm btn-success"> -->
                        <button type="button" disabled="disabled" class="mt-1 btn btn-sm btn-success">
                            <span v-if="!downloading"><i class="fas fa-arrow-down"></i> Download results</span>
                            <span v-if="downloading"><i class="fas fa-circle-notch fa-spin"></i> Downloading</span>
                        </button>
                    </div>
                    <div v-else>
                        <router-link tag="button" type="button" to="/home" class="mt-1 btn btn-primary btn-sm float-right"><i class="fas fa-arrow-left"></i> Back to home</router-link>
                    </div>
                </div>
                
            </div>      
        </div>
        <transition name="fade" mode="out-in">            
            <div v-if="!queryCount">                      
                <div class="row">
                    <div class="col border-bottom">
                        <h4 class="display-4">Name</h4>
                    </div>
                </div>
                <div class="row ml-1 mt-2">            
                    <div class="col-3">
                        <div class="form-label-group">
                            <input type="text" name="lastName" class="form-control" placeholder="Last name" v-model="query.lastName" />
                            <label>Last name</label>
                        </div>
                    </div>
                    <div class="col-3">
                        <div class="form-label-group">
                            <input type="text" name="firstName" class="form-control" placeholder="First name" v-model="query.firstName" />
                            <label>First name</label>
                        </div>
                    </div>
                    <div class="col-2">
                        <div class="form-label-group">
                            <input type="text" name="middleName" class="form-control" placeholder="Middle initial" v-model="query.middleName" />
                            <label>Middle initial</label>
                        </div>
                    </div>
                    <div class="col-2">
                        <div class="form-label-group">
                            <input type="text" name="suffix" class="form-control" placeholder="Suffix" v-model="query.suffix" />
                            <label>Suffix</label>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col border-bottom">
                        <h4 class="display-4">Address</h4>
                    </div>
                </div>
                <div class="row ml-1 mt-2">            
                    <div class="col-2">
                        <div class="form-label-group">
                            <input type="text" name="residenceNum" class="form-control" placeholder="Number" v-model="query.residenceNum" />
                            <label>Number</label>
                        </div>
                    </div>
                    <div class="col-3">
                        <div class="form-label-group">
                            <input type="text" name="firstName" class="form-control" placeholder="Street" v-model="query.residenceStreet" />
                            <label>Street</label>
                        </div>
                    </div>
                    <div class="col-3">
                        <div class="form-label-group">
                            <input type="text" name="city" class="form-control" placeholder="City" v-model="query.residenceCity" />
                            <label>City</label>
                        </div>
                    </div>
                    <div class="col-2">
                        <div class="form-label-group">
                            <input type="text" name="suffix" class="form-control" placeholder="Zipcode" v-model="query.zipcode" />
                            <label>Zipcode</label>
                        </div>
                    </div>
                    <div class="col-2">
                        <div class="form-label-group">
                            <select class="form-control" v-model="query.county">
                                <option value="" selected="selected">Select a county</option>
                                <option :key="k" v-for="(c, k) in selectFields.counties" :value="c.county_code">{{c.county_name}}</option>
                            </select>                                                        
                            <label>County</label>
                        </div>                        
                    </div>
                    <div class="col-12">                
                        <div class="form-group form-check-inline">
                            <input type="checkbox" class="form-check-input" id="hasTelephone" v-model="query.hasTelephone">
                            <label class="form-check-label" for="hasTelephone">Has telephone on file</label>
                        </div>                
                        <div class="form-group form-check-inline">
                            <input type="checkbox" class="form-check-input" id="hasEmail" v-model="query.hasEmail">
                            <label class="form-check-label" for="hasEmail">Has email on file</label>
                        </div>                        
                    </div>
                </div>
                <div class="row">
                    <div class="col border-bottom">
                        <h4 class="display-4">Biographical data</h4>
                    </div>
                </div>
                <div class="row mt-2 ml-1">  
                    <div class="row col-12">   
                        <div class="col-12">       
                            <h5>Gender</h5>
                        </div>
                        <div class="col-12">                
                            <div class="form-group form-check-inline">
                                <input type="checkbox" class="form-check-input" id="genderMale" value="M" v-model="query.gender">
                                <label class="form-check-label" for="genderMale">Male</label>
                            </div>                
                            <div class="form-group form-check-inline">
                                <input type="checkbox" class="form-check-input" id="genderFemale" value="F" v-model="query.gender">
                                <label class="form-check-label" for="genderFemale">Female</label>
                            </div>                
                            <div class="form-group form-check-inline">
                                <input type="checkbox" class="form-check-input" id="genderUnspecified" value="U" v-model="query.gender">
                                <label class="form-check-label" for="genderUnspecified">Unspecified</label>
                            </div>                
                        </div>
                    </div>
                </div>
                <div class="row mt-2 ml-1">    
                    <div class="row col-12">
                        <div class="col-12">
                            <h5>Age</h5>
                        </div>
                        <div class="col-12">
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="ageRange" id="olderThan" value="older" v-model="query.ageRange">
                                <label class="form-check-label" for="olderThan">As old or older than</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="ageRange" id="youngerThan" value="younger" v-model="query.ageRange">
                                <label class="form-check-label" for="youngerThan">As young or younger than</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="ageRange" id="between" value="between" v-model="query.ageRange">
                                <label class="form-check-label" for="between">Between the ages of</label>
                            </div>
                        </div>

                        <div class="col-2">
                            <div class="form-label-group">
                                <input type="text" :disabled="query.ageRange == ''" name="age" class="form-control" :placeholder="{'Starting age': !query.ageRange, 'Age': query.ageRange != 'between'}" v-model="query.ageStart" />
                                <label v-if="query.ageRange != 'between'">Age</label>
                                <label v-if="query.ageRange == 'between'">Starting age</label>
                            </div>
                        </div>
                        <div v-if="query.ageRange == 'between'" class="col-1 text-center pt-2">
                            <strong>and</strong>
                        </div>
                        <div v-if="query.ageRange == 'between'" class="col-2">
                            <div class="form-label-group">
                                <input type="text" name="age" class="form-control" placeholder="Ending age" v-model="query.ageEnd" />
                                <label>Ending age</label>
                            </div>
                        </div> 
                    </div>          
                </div>
                <div class="row">
                    <div class="col border-bottom">
                        <h4 class="display-4">Voter representation</h4>                        
                    </div>
                </div>
                <div class="row ml-1 mt-2">     
                    <div class="col-12">
                        <h5>District data</h5>                                    
                    </div>
                    <div class="col-12">
                        <div class="pb-1">* separate multiple values with commas, e.g. 12, 14</div>
                    </div>
                    <div class="col">
                        <div class="form-label-group">
                            <input type="text" name="electionDistrict" class="form-control" placeholder="Election district" v-model="query.electionDistrict" />
                            <label>Election district</label>
                        </div>
                    </div>
                    <div class="col">
                        <div class="form-label-group">
                            <input type="text" name="congressionalDistrict" class="form-control" placeholder="Congressional district" v-model="query.congressionalDistrict" />
                            <label>Congressional district</label>
                        </div>
                    </div>
                    <div class="col">
                        <div class="form-label-group">
                            <input type="text" name="senateDistrict" class="form-control" placeholder="Senate district" v-model="query.senateDistrict" />
                            <label>Senate district</label>
                        </div>
                    </div>
                    <div class="col">
                        <div class="form-label-group">
                            <input type="text" name="legislativeDistrict" class="form-control" placeholder="Legislative district" v-model="query.legislativeDistrict" />
                            <label>Legislative district</label>
                        </div>
                    </div>
                    <div class="col">
                        <div class="form-label-group">
                            <input type="text" name="assemblyDistrict" class="form-control" placeholder="Assembly district" v-model="query.assemblyDistrict" />
                            <label>Assembly district</label>
                        </div>
                    </div>
                </div>
                <div class="row ml-1 mt-2">
                    <div class="col-12">
                        <h5>Elected representatives</h5>                                                     
                    </div>
                    <div class="col-6"> 
                        <div class="input-group">
                            <input type="text" disabled="disabled" placeholder="Assembly representative" class="form-control" :value="selectFields.assembly_rep.filter(item => query.assemblyRep.includes(item.val)).map(v => {return v.display}).join(', ')">
                            <div class="input-group-append">
                                <button type="button" v-on:click="pickValue('assemblyRep', selectFields.assembly_rep)" class="float-right btn btn-success">Pick</button>
                                <button type="button" :disabled="query.assemblyRep.length == 0" v-on:click="query.assemblyRep = [];" class="float-right btn btn-danger">Clear</button>
                            </div>
                        </div>   
                    </div>                                 
                    <div class="col-6"> 
                        <div class="input-group">
                            <input type="text" disabled="disabled" placeholder="Congressional representative" class="form-control" :value="selectFields.congressional_rep.filter(item => query.congressionalRep.includes(item.val)).map(v => {return v.display}).join(', ')">
                            <div class="input-group-append">
                                <button type="button" v-on:click="pickValue('congressionalRep', selectFields.congressional_rep)" class="float-right btn btn-success">Pick</button>
                                <button type="button" :disabled="query.congressionalRep.length == 0" v-on:click="query.congressionalRep = [];" class="float-right btn btn-danger">Clear</button>
                            </div>
                        </div>   
                    </div>                                 
                    <div class="col-6 pt-3"> 
                        <div class="input-group">
                            <input type="text" disabled="disabled" placeholder="Senate representative" class="form-control" :value="selectFields.senate_rep.filter(item => query.senateRep.includes(item.val)).map(v => {return v.display}).join(', ')">
                            <div class="input-group-append">
                                <button type="button" v-on:click="pickValue('senateRep', selectFields.senate_rep)" class="float-right btn btn-success">Pick</button>
                                <button type="button" :disabled="query.senateRep.length == 0" v-on:click="query.senateRep = [];" class="float-right btn btn-danger">Clear</button>
                            </div>
                        </div>   
                    </div>                                                                                  
                </div>
                <div class="row mt-3">
                    <div class="col border-bottom">
                        <h4 class="display-4">Voter data</h4>                                    
                    </div>
                </div>
                <div class="row ml-1 mt-2"> 
                    <div class="col-12">
                        <div class="row col-6">
                            <h5>Has voted in this range of years</h5>                            
                            <div class="col-12">
                                <div class="row">
                                    <div class="col-5">
                                        <div class="form-label-group">
                                            <select class="form-control" v-model="query.voteStart">
                                                <option value="" selected="selected">Select a year</option>
                                                <option :key="k"  :disabled="c < query.voteEnd" v-for="(c, k) in electionYears" :value="c">{{c}}</option>
                                            </select>                                                        
                                            <label>Start year</label>
                                        </div>
                                    </div>
                                    <div class="col-2 mt-2"> and </div>
                                    <div class="col-5">
                                        <div class="form-label-group">
                                            <select class="form-control" v-model="query.voteEnd">
                                                <option value="" selected="selected">Select a year</option>
                                                <option :key="k" :disabled="c <= query.voteStart" v-for="(c, k) in electionYears" :value="c">{{c}}</option>
                                            </select>                                                        
                                            <label>End year</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-12 form-inline">
                                <span>Has voted in at least</span><input type="text" name="electionYearsIncludeCount" class="ml-2 col-3 mr-2 form-control" placeholder="Times voted" v-model="query.voteIncludeCount" /><span> of these elections</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-12">
                        <div class="row col-6">
                            <h5>Party affiliation</h5>                            
                            <div class="col-12">
                                <div class="input-group">
                                    <input type="text" disabled="disabled" placeholder="Party affiliation" class="form-control" :value="selectFields.enrollment.filter(item => query.enrollment.includes(item.val)).map(v => {return v.display}).join(', ')">
                                    <div class="input-group-append">
                                        <button type="button" v-on:click="pickValue('enrollment', selectFields.enrollment)" class="float-right btn btn-success">Pick</button>
                                        <button type="button" :disabled="query.enrollment.length == 0" v-on:click="query.enrollment = [];" class="float-right btn btn-danger">Clear</button>
                                    </div>
                                </div> 
                            </div>
                        </div>
                    </div>
                    <!--<div class="col-6">
                        <div class="row">
                            <h5>Has not voted in these years</h5>                            
                            <div class="col-12">
                                <div class="form-label-group">
                                    <input type="text" name="electionYearsExclude" class="form-control" placeholder="Years not voted" v-model="query.electionYearsExclude" />
                                    <label>Years not voted</label>
                                </div>
                            </div>
                        </div>
                    </div>-->
                </div>
                <div class="row mt-2">
                    <div class="col border-bottom">
                        <h4 class="display-4">Lookup behavior</h4>                                    
                    </div>
                </div>
                <div class="row ml-1 mt-2">
                    <div class="col-12">
                        <div class="form-group form-check-inline">
                            <input type="checkbox" id="random" value="Y" v-model="query.random" class="form-check-input"> <label for="random" class="form-check-label">Generate a random list for downloading</label>
                        </div>
                    </div>
                    <div class="col-12 form-inline">
                        <span>Limit results to </span><input type="text" name="countLimit" class="ml-2 col-3 mr-2 form-control" placeholder="Result count" v-model="query.limit" /><span> records</span>
                    </div>                    
                </div>
                <div class="row mt-2">      
                    <div class="col-12 border-top pt-2">
                        <button class="btn btn-primary" :disabled="queryDisabled || queryLoading" v-on:click="submitQuery(false)">
                            <span v-if="!queryLoading"><i class="fas fa-search"></i> Do lookup</span>
                            <span v-if="queryLoading"><i class="fas fa-circle-notch fa-spin"></i> Searching</span>
                        </button>
                    </div>
                </div>
            </div>

            <div v-if="queryCount">
                <div class="row">
                    <div class="col-12">
                        <h4 class="display-4">
                            {{Number(queryCount).toLocaleString()}} record<span v-if="queryCount != 1">s</span> match<span v-if="queryCount == 1">es</span> your search<span v-if="queryCount > 10000">, viewing the first 10,000</span>
                        </h4>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12">
                        <table class="table" style="font-size: 0.8rem">
                            <thead>
                                <tr>
                                    <th scope="col">Name</th>
                                    <th scope="col">Address</th>
                                    <th scope="col">Date of birth</th>
                                    <th scope="col">Gender</th>
                                    <th scope="col">Enrollment</th>
                                    <th scope="col">Last voted date</th>
                                    <th scope="col">Email</th>
                                    <th scope="col">Telephone</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr :key="i" v-for="(q, i) in paginatedData">                                    
                                    <td>
                                        {{resultName(q)}}
                                    </td>
                                    <td>
                                        <div>{{resultAddress(q)}}</div>
                                        <div>{{resultCityZip(q)}}</div>
                                    </td>
                                    <td>
                                        {{resultDate(q, 'age')}}
                                    </td>
                                    <td>
                                        {{resultGender(q)}}
                                    </td>
                                    <td>
                                        {{resultEnrollment(q)}}
                                    </td>
                                    <td>
                                        {{resultDate(q, 'lastVoted')}}
                                    </td>
                                    <td>{{q.email}}</td>
                                    <td>{{q.telephone}}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="row">
                    <div class="col-3">
                        <button class="btn btn-primary" type="button" :disabled="pageNumber == 0" v-on:click="prevPage()"><i class="fas fa-chevron-left"></i> Back</button>
                    </div>
                    <div class="col-6" style="text-align: center">
                        <h5 v-if="pageCount">page {{pageNumber + 1}} of {{Number(pageCount).toLocaleString()}}</h5>
                    </div>
                    <div class="col-3">
                        <button class="float-right btn btn-primary mr-1" type="button" :disabled="pageNumber == pageCount - 1 || !pageCount" v-on:click="nextPage()">Forward <i class="fas fa-chevron-right"></i></button>
                    </div>
                </div>

            </div>
        </transition>
        <value-picker></value-picker>
    </div>
</div>
</template>
<script>
var electionYears = [];
for (var i = 2020; i >= 1984; i--) {
    electionYears.push(i);
}
var defaultQuery = {
    lastName: '',                 
    firstName: '',
    middleName: '',
    suffix: '',
    residenceNum: '',
    residenceStreet: '',
    residenceCity: '',
    zipcode: '',      
    county: '',          
    gender: [], 
    ageRange: '', 
    ageStart: '',
    ageEnd: '',
    electionDistrict: '',
    congressionalDistrict: '',
    senateDistrict: '',
    legislativeDistrict: '',
    assemblyDistrict: '',
    assemblyRep: [],
    congressionalRep: [],
    senateRep: [],
    enrollment: [],
    hasTelephone: false,
    hasEmail: false,
    voteStart: '',
    voteEnd: '',
    random: [],
    limit: '',
    voteIncludeCount: 1
};
/*var enrollment = [
    {code: 'none', label: 'None'},
    {code: 'BLK', label: 'No party affiliation'},
    {code: 'CON', label: 'Conservative'},
    {code: 'DEM', label: 'Democratic'},
    {code: 'GRE', label: 'Green'},
    {code: 'IND', label: 'Independence'},
    {code: 'LBT', label: 'Libertarial'},
    {code: 'OTH', label: 'Other'},
    {code: 'REF', label: 'Reform'},
    {code: 'REP', label: 'Republican'},
    {code: 'SAM', label: 'Serve America Movement'},
    {code: 'WEP', label: 'Womens Equality Party'},
    {code: 'WOR', label: 'Working Families'}
];*/

import valuePicker from './value.pick.vue';


export default {   
    components: {        
        valuePicker: valuePicker
    },
    data: function() {
        return {                  
            batches: [],
            counties: [],
            loading: false,
            queryLoading: false, 
            downloading: false,  
            defaultQuery: JSON.parse(JSON.stringify(defaultQuery)),
            query: JSON.parse(JSON.stringify(defaultQuery)),
            queryResults: [],  
            selectFields: {assembly_rep: [], congressional_rep: [], senate_rep: [], enrollment: [], counties: []},   
            selectList: [],  
            selectModel: '',
            queryCount: false,
            electionYears: electionYears,
            size: 10,
            pageNumber: 0
        }
    },
    methods: {       
        pickValue: function(val, list) {
            this.selectList = list;                  
            this.selectModel = val;
             $('#qlValuePick').modal('show'); 
        },
        downloadResults: function() {
            this.downloading = true;
            var _this = this;
            this.query.action = 'download';
            var formData = new FormData();
            formData.append('query', JSON.stringify(this.query));
            formData.append('token', JSON.stringify([{userid: this.$root.user.userid, token: this.$root.user.auth_token}]));
            this.axios.post(this.$root.baseURI+'/quick-lookup/query', formData, {
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
                    _this.downloading = false;
                    return;
                }                                        
                if (response.data.error) {
                    _this.$root.setAlert(true, response.data.error, 'alert-danger');
                    _this.downloading = false;
                    return;
                } else {                       
                    const url = window.URL.createObjectURL(new Blob([response.data]));
                    const link = document.createElement('a');
                    link.href = url;
                    link.setAttribute('download', 'quick-lookup-download.csv');
                    document.body.appendChild(link);
                    link.click();
                    _this.downloading = false;        
                }
            }).catch(error => {
                _this.$root.setAlert(true, error, 'alert-danger');
                _this.downloading = false;
                return;
            });                
        },
        resultGender: function(record) {
            var out = 'N/A';
            switch (record.gender) {
                case 'M':
                    out = 'Male';
                break;
                case 'F':
                    out = 'Female';
                break;
                case 'U':
                case '':
                    out = 'Unspecified';
                break;
            }
            return out;
        },
        resultDate: function(record, type) {            
            var out = 'N/A';
            var d = '';
            switch (type) {
                case 'age':
                   d = record.date_of_birth;
                break;
                case 'lastVoted':
                   d = record.last_voted_date;
                break;
            }

            if (d > '') {
                var year = d.substring(0, 4);
                var month = d.substring(4, 6);
                var day = d.substring(6, 8);
                out = month+'/'+day+'/'+year;
            }
            return out;
        },
        resultEnrollment: function(record) {
            var out = 'None';
            var e = this.selectFields.enrollment.filter(en => {
                return en.code == record.enrollment;
            });
            if (e.length > 0) {
                out = e[0].label;
            }
            return out;
        },
        resultName: function(record) {
            var arr = new Array(record.first_name, record.middle_name, record.last_name, record.name_suffix);
            var out = '';
            for (var i = 0; i < arr.length; i++) {
                out += (arr[i] || '') + ' ';
            }
            out = out.trim();
            return out;
        },
        resultAddress: function(record) {
            var arr = new Array(record.residence_num, record.residence_halfnum, record.residence_aptnum, record.residence_pre_street_dir, record.residence_street_name, record.residence_post_street_dir);
            var out = '';
            for (var i = 0; i < arr.length; i++) {
                out += (arr[i] || '') + ' ';
            }
            out = out.trim();
            return out;
        },
        resultCityZip: function(record) {
            var out = record.residence_city;
            if (out > '') {
                out += ', '+record.residence_zip;
                if (record.residence_zip > '' && record.residence_zip_4 > '') {
                    out += '-'+record.residence_zip_4;
                } 
            }
            out = out.trim();
            return out;
        },
        modifyLookup: function() {
            this.queryCount = false;
            this.queryResults = false;            
            this.pageNumber = 0;
        },
        resetLookup: function() {
            this.queryCount = false;
            this.queryResults = false;            
            this.query = JSON.parse(JSON.stringify(defaultQuery));
            this.pageNumber = 0;
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
        cleanData: function(data, str) {
            var tmpData = JSON.parse(JSON.stringify(data)).split(",");
            var arrTmp = [];
            for (var i = 0; i < tmpData.length; i++) {
                var tmp = parseInt(tmpData[i]);
                if (!isNaN(tmp)) {
                    arrTmp.push(tmp);
                }
            }
            data = arrTmp.join(str);
            return data;
        },        
        submitQuery: function(page) {            
            //Handle invalid data in district inputs
            this.query.electionDistrict = this.cleanData(this.query.electionDistrict, ",");
            this.query.congressionalDistrict = this.cleanData(this.query.congressionalDistrict, ",");
            this.query.senateDistrict = this.cleanData(this.query.senateDistrict, ",");
            this.query.legislativeDistrict = this.cleanData(this.query.legislativeDistrict, ",");
            this.query.assemblyDistrict = this.cleanData(this.query.assemblyDistrict, ",");
            this.query.zipcode = this.cleanData(this.query.zipcode, "-");
            if (this.queryDisabled) {
                return;
            }
            this.queryLoading = true;
            if (!page) {
                this.queryCount = false;
            }
            var _this = this;   
            this.query.action = 'query'; 
            var params = {
                query: this.query,
                token: [{userid: this.$root.user.userid, token: this.$root.user.auth_token}]
            }        
            this.axios.get(this.$root.baseURI+'/quick-lookup/query', {                    
                params: params
            }).then(function (response) {                   
                 _this.$root.handleTokenError(response.data);                   
                _this.queryLoading = false;                                     
                if (response.data.error) {                    
                    _this.$root.setAlert(true, response.data.error, 'alert-danger');
                    return;
                } else {                    
                    if (response.data.length) {                           
                        _this.queryCount = response.data[0][0].records;                                
                        _this.queryResults = response.data[1];                  
                    } else {
                        _this.$root.setAlert(true, 'Error performing query', 'alert-danger');
                        return;
                    }
                }
            }).catch(error => {
                _this.queryLoading = false;                
                _this.$root.setAlert(true, error, 'alert-danger');
                return;
            });  
        },
        getSelectFields: function() {
            var _this = this;
            var params = {
                 token: [{userid: this.$root.user.userid, token: this.$root.user.auth_token}]
            }
            this.axios.get(this.$root.baseURI+'/lists/selectFields.get', {
                params: params
            }).then(function (response) {  
                _this.$root.handleTokenError(response.data);                                                                      
                if (response.data.error) {
                    _this.$root.setAlert(true, response.data.error, 'alert-danger');
                    return;
                } else {                    
                    if (response.data) {                                      
                        _this.selectFields = response.data;                                                     
                    }
                }
            }).catch(error => {
                _this.$root.setAlert(true, error, 'alert-danger');
                return;
            });  
        }
    },
    computed: {
        pageCount: function() {
            let l = this.queryResults.length;
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
            return this.queryResults.slice().slice(s,e);
        },
        queryDisabled: function() {
            if (
                this.query.lastName == '' 
                && this.query.firstName == ''
                && this.query.middleName == ''
                && this.query.suffix == ''
                && this.query.residenceNum == ''
                && this.query.residenceStreet == ''
                && this.query.residenceCity == ''
                && this.query.zipcode == ''           
                && this.query.county == ''
                && this.query.gender.length == 0
                && this.query.ageStart == ''
                && this.query.electionDistrict == ''
                && this.query.congressionalDistrict == ''
                && this.query.senateDistrict == ''
                && this.query.legislativeDistrict == ''
                && this.query.assemblyDistrict == ''
                && this.query.hasTelephone == false
                && this.query.hasEmail == false
                && this.query.voteStart == ''
                && this.query.voteEnd == ''
                && this.query.assemblyRep.length == 0
                && this.query.congressionalRep.length == 0                
                && this.query.senateRep.length == 0
                && this.query.enrollment.length == 0    
            ) {
                return true;
            } else {
                return false;
            }    
        }
    },
    watch: {        
    },    
    mounted: function() {
        this.getSelectFields();
    }
};
</script>
<style scoped>
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

.main {
    margin-bottom: 80px;
}
</style>