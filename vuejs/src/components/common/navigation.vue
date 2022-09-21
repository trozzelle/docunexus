<template>
    <nav class="navbar navbar-expand-md">
        <span class="navbar-brand mb-0 h1"><a href="/"><img :src="navImg" alt="Docunexus"></a></span>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavAltMarkup" aria-controls="navbarNavAltMarkup" aria-expanded="false" aria-label="Toggle navigation">
            <i class="fas fa-bars"></i>
        </button>        
        <div v-if="$root.loggedIn" class="collapse navbar-collapse" id="navbarNavAltMarkup">            
            <ul v-show="navSite == 'home'" id='navHome' class="navbar-nav">                  
               <!-- <li><router-link tag="a" exact class="nav-item nav-link" :to="{name: 'home', params: {}}"><i class="fad fa-home-lg-alt"></i> Home</router-link></li>      -->
                <li><router-link tag="a" exact class="nav-item nav-link" :to="{name: 'voter-nexus', params: {}}"><i class="fad fa-tools"></i> Voter nexus</router-link></li>
                <li><router-link tag="a" exact class="nav-item nav-link" :to="{name: 'nexus-index', params: {}}"><i class="fad fa-address-book"></i> Nexus index</router-link></li>                
            </ul>            
            <ul v-show="navSite == 'nexus-index'" id="navNI" class="navbar-nav">
                <li><router-link tag="a" exact class="nav-item nav-link" :to="{name: 'nexus-index', params: {}}"><i class="fad fa-home-lg-alt"></i> Home</router-link></li>
                <li><router-link tag="a" exact class="nav-item nav-link" :to="{name: 'donor', params: {}}"><i class="fad fa-clipboard-list-check"></i> Donor Lookup</router-link></li>
                <li><router-link tag="a" exact class="nav-item nav-link" :to="{name: 'filer-search', params: {}}"><i class="fad fa-file-search"></i> Filer Search</router-link></li>
                <li><router-link tag="a" exact class="nav-item nav-link" :to="{name: 'filer-rankings', params: {}}"><i class="fad fa-trophy"></i> Rankings</router-link></li>
                <li><router-link tag="a" class="nav-item nav-link" :to="{ name: 'county-committee', params: {county: 'Oneida'} }"><i class="fad fa-globe-americas"></i> Influencer's Index</router-link></li>                
            </ul>
            <ul v-show="navSite == 'voter-nexus'" id="navVN" class="navbar-nav">                
                <li><router-link tag="a" exact class="nav-item nav-link" :to="{name: 'voter-nexus', params: {}}"><i class="fad fa-home-lg-alt"></i> Home</router-link></li>     
                <li><router-link tag="a" exact class="nav-item nav-link" :to="{name: 'quick-lookup', params: {}}"><i class="fad fa-search"></i> Voter query</router-link></li>
                <li><router-link tag="a" exact class="nav-item nav-link" :to="{name: 'match', params: {}}"><i class="fad fa-user-check"></i> Voter match</router-link></li>                
                <li><router-link tag="a" exact class="nav-item nav-link" :to="{name: 'history', params: {}}"><i class="fad fa-history"></i> Match history</router-link></li>      
                <li><router-link tag="a" exact class="nav-item nav-link" :to="{name: 'targets', params: {}}"><i class="fad fa-bullseye-pointer"></i> Target maker</router-link></li>                      
            </ul>
            <!-- Link to other site -->
            <router-link tag="button" v-if="navSite == 'voter-nexus'" exact class="ml-3 btn btn-danger" :to="{name: 'nexus-index', params: {}}"><i class="fad fa-address-book"></i> Nexus index</router-link>
            <router-link tag="button" v-if="navSite == 'nexus-index'" exact class="ml-3 btn btn-success" :to="{name: 'voter-nexus', params: {}}"><i class="fad fa-tools"></i> Voter nexus</router-link>
            <!-- Admin link -->
            <router-link v-if="$root.user.admin.group_admin == 'Y' || $root.user.admin.region_admin == 'Y' || $root.user.admin.site_admin == 'Y'" tag="button" exact class="ml-3 btn btn-info" :to="{name: 'admin', params: {}}"><i class="fad fa-user-unlock"></i> Administration</router-link>
        </div>
        <div v-else class="collapse navbar-collapse" id="navbarNavAltMarkup">
            <!-- This space intentionally left blank -->
        </div>        
        
        <div v-if="$root.development" class="alert alert-danger mr-3 mb-0 p-1">
            <div><i class="fas fa-exclamation-circle text-danger"></i> <strong>Warning:</strong> this a development environment!</div>
            <div class="branch">Using branch <strong>{{$root.branch}}</strong></div>
        </div>
        <form v-if="$root.loggedIn" class="form-inline my-2 my-lg-0">      
            <span class="mr-3 user-detail"><i class="fad fa-lg fa-user-circle"></i> <a class="text-primary" data-toggle="modal" data-backdrop="static" data-target="#userDetail">{{name}}</a></span>
            <button disabled="disabled" class="btn btn-primary my-2 my-sm-0" v-on:click="$root.logOut(logoutMsg);" type="button"><i class="fad fa-sign-out-alt"></i> Log out</button>
        </form>
        <user-detail></user-detail>                
    </nav> 
</template>
<script>
import userDetail from './user.detail.vue';
export default {    
    components: {
        userDetail: userDetail
    },
    data: function() {
        return {             
            name: this.$root.user.display_name.split('+').join(' '),
            logoutMsg: {message: "You have been logged out successfully", style: "alert-success"},
            navSite: 'home',
            navImg: '/assets/images/docunexus.png'
        }
    },
    methods: {
        setupNav: function() {
            let s = this.$route.path.split("/")[1];            
            switch (s) {
                case 'nexus-index':
                    this.navSite = s;
                    this.navImg = '/assets/images/nexusindex.png';
                break;
                case 'voter-nexus':
                    this.navSite = s;
                    this.navImg = '/assets/images/voternexus.png';
                break;
                default:
                    this.navSite = 'home';
                    this.navImg = '/assets/images/docunexus.png';
                break;
            }

        }
    },
    watch: {
        '$root.user': {
            deep: true,
            handler: function() {
                this.name = this.$root.user.display_name.split('+').join(' ');
            }
        },
        '$route': function() {
            this.setupNav();
        }
    },    
    mounted: function () {
        this.$root.getBranch();
        this.setupNav();
    }
}
</script>
<style scoped>
.branch {    
    font-size: 0.8rem;
    text-align: center;
}
.user-detail a:hover {
    text-decoration: underline;
    cursor: pointer;
}
nav {        
    border-top: 1px solid #DDD;
    font-size: 1.0rem;
    box-shadow: rgba(0,0,0,.118) 0 4px 3px -3px;
}

.row {
    background-color: rgba(255 ,255, 255);
}

.navbar {    
    padding: 0 1rem;   
}

.navbar .navbar-nav>li>a {
    color: #333;
    transition: all .4s;
}

.navbar #navHome.navbar-nav li a.nav-item.router-link-active, 
.navbar #navHome.navbar-nav li a.nav-item.router-link-active:focus, 
.navbar #navHome.navbar-nav li a.nav-item.router-link-active:hover,
#navHome .dropdown-menu a:hover,
#navHome .dropdown-menu a:focus {
    color: #23b5d3;
    background-color: #EEE;
}

.navbar #navHome.navbar-nav>li>a:hover {
   color: #23b5d3;
    background-color: #EEE;
}

.navbar #navNI.navbar-nav li a.nav-item.router-link-active,
.navbar #navNI.navbar-nav li a.nav-item.router-link-active:focus, 
.navbar #navNI.navbar-nav li a.nav-item.router-link-active:hover,
#navNI .dropdown-menu a:hover,
#navNI .dropdown-menu a:focus {
    color: #1A2D50;
    background-color: #EEE;
}

.navbar #navNI.navbar-nav>li>a:hover {
   color: #1A2D50;
    background-color: #EEE;
}

.navbar #navVN.navbar-nav li a.nav-item.router-link-active, 
.navbar #navVN.navbar-nav li a.nav-item.router-link-active:focus, 
.navbar #navVN.navbar-nav li a.nav-item.router-link-active:hover,
#navVN .dropdown-menu a:hover,
#navVN .dropdown-menu a:focus {
    color: #43aa8b;
    background-color: #EEE;
}

.navbar #navVN.navbar-nav>li>a:hover {
    color: #43aa8b;
    background-color: #EEE;
}


.navbar .navbar-text {
margin-top: 8px;
    margin-bottom: 8px;
    padding: 0;
}

.navbar-brand img {
    width: 200px;
}

.navbar-expand-md .navbar-nav .nav-link {
padding: 1rem 1.7rem;
}

.dropdown:hover>.dropdown-menu {
    display: block;    
}

.dropdown-menu {   
    border-radius: 0;
    border: none;    
    margin: 0;  
    padding: 0;
}

.dropdown-menu a {
    text-transform: uppercase;
    font-size: 0.9rem;
    padding: 0.6rem 1rem;
    transition: all .4s;
}

@media (min-width: 992px) {
    .animate {
        animation-duration: 0.3s;
        -webkit-animation-duration: 0.3s;
        animation-fill-mode: both;
        -webkit-animation-fill-mode: both;
    }
}

.fadeIn {
    animation-name: fadeIn;
}

@keyframes fadeIn {
    0% {
        opacity: 0;
    }
    100% {
        opacity: 1;
    }
    0% {
        opacity: 0;
    }
}
</style>