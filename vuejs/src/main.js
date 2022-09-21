//Base components
import Vue from 'vue';
import app from './app.vue';

//Third-party tools
import VueRouter from 'vue-router';
import axios from 'axios';
import VueAxios from 'vue-axios';
import VueCookies from 'vue-cookies';
import BootstrapVue from 'bootstrap-vue';
import Vuelidate from 'vuelidate';
import { latLng } from 'leaflet';
import { LGeoJson, LMap, LMarker, LTileLayer } from 'vue2-leaflet';
import numeral from 'numeral';
import Dayjs from 'vue-dayjs';
import VCalendar from 'v-calendar';
import VueWindowSize from 'vue-window-size';


//Global components
import alert from './components/common/alert.vue';
import login from './components/common/login.vue';
import foot from './components/common/foot.vue';

//Main
import nav from './components/common/navigation.vue';
import home from './components/home/main.vue';
import noAuth from './components/common/noauth.vue';

//Voter nexus
import voterTools from './components/voter-nexus/main.vue';
import vtQuickLookup from './components/voter-nexus/quick-lookup/main.vue';
import vtMatch from './components/voter-nexus/match/main.vue';
import vtLists from './components/voter-nexus/lists/main.vue';
import vtHistory from './components/voter-nexus/history/main.vue';

//Nexus index
import nexusIndex from './components/nexus-index/main.vue';
import niDonor from './components/nexus-index/donor/main.vue';
import niFiler from './components/nexus-index/filer/main.vue';
import niFilerSearch from './components/nexus-index/filer/search.vue';
import niFilerRankings from './components/nexus-index/filer/rankings';
import niInfluencers from './components/nexus-index/influencers-index/main.vue';
import niInfluencersCounty from './components/nexus-index/influencers-index/county.vue';
import niInfluencersCountyCommittee from './components/nexus-index/influencers-index/county-committee.vue';
import niSavedListDetail from './components/nexus-index/user-favorites/savedListDetail.vue';
import niSavedPages from './components/nexus-index/user-favorites/savedPages.vue';
import niSavedLists from './components/nexus-index/user-favorites/savedLists.vue';
import niSavedSearches from './components/nexus-index/user-favorites/savedSearches.vue';

//Admin
import adminNav from './components/admin/navigation.vue';
import admin from './components/admin/main.vue';
import adminGroups from './components/admin/groups/main.vue';
import adminRegions from './components/admin/regions/main.vue';
import adminRights from './components/admin/rights/main.vue';
import adminUsers from './components/admin/users/main.vue';

//Import CSS
import './assets/css/custom.scss';
import 'bootstrap';
//import 'bootstrap/dist/css/bootstrap.min.css';
import './assets/css/screen.css';
import './assets/css/floating-labels.css';
import './assets/js/fontawesome.js';
import 'leaflet/dist/leaflet.css';

//Import mixins
import FormattingHelpers from './mixins/FormattingHelpers.js';
import APIHelpers from './mixins/APIHelper.js';
import Utilities from '@/mixins/Utilities';

import { dataBaseURI } from "../../conf/config.json";

//Auth0
/*import { domain, clientId } from "../auth_config.json";
import { Auth0Plugin } from "./auth";

Vue.use(Auth0Plugin, {
    domain,
    clientId,
    onRedirectCallback: appState => {
      router.push(
        appState && appState.targetUrl
          ? appState.targetUrl
          : window.location.pathname
      );
    }
  });
*/

//jQuery
window.$ = window.jQuery = require('jquery');

var env = '';

if (window.location.host == 'docunexus.net') {
    env = 'PROD';    
} else {
    env = 'DEV';    
}

// Enable performance tracing for Vue and the User Timing
// API in Chrome to start fingerprinting performance issues
// and optimizing
Vue.config.performance = true
Vue.config.productionTip = false

const alertDefault = {
    display: false,
    message: '',
    class: 'alert-primary',
    timeout: false,
}

const userDefault = {
    userid: '',
    username: '',
    email: '',
    display_name: '',
    site_admin: '',
    enabled: '',
    groups: [],
    regions: [],
    admin: {},
    auth_token: '',
    auth_token_expires: '',
}

const userDemo = {
    userid: '43',
    username: 'demo',
    email: 'demo@docunexus.net',
    display_name: 'Demo user',
    site_admin: 'N',
    enabled: 'Y',
    groups: [],
    regions: ['1'],
    admin: {},
    auth_token: '',
    auth_token_exires: '',
}

//Use third-party plugins
Vue.use(BootstrapVue);
Vue.use(VueRouter);
Vue.use(Vuelidate);
Vue.use(VueCookies);
Vue.use(VueAxios, axios);
Vue.use(Dayjs);
Vue.use(VCalendar);
Vue.use(VueWindowSize);

Object.defineProperty(Vue.prototype, '$numeral', { value: numeral });

//Use third-party components
Vue.component('l-map', LMap);
Vue.component('l-tile-layer', LTileLayer);
Vue.component('l-marker', LMarker);
Vue.component('l-geo-json', LGeoJson);

Vue.component('alert', alert);
Vue.component('login', login);
Vue.component('foot', foot);

Vue.mixin(FormattingHelpers);
Vue.mixin(APIHelpers);
Vue.mixin(Utilities);


//Routes and route components
const router = new VueRouter({
    mode: 'history',
    routes: [
    /*{
        name: 'home',
        path: '/',
        components: {
            default: home,
            navigation: nav
        },
        props: {
            default: true,
            navigation: true
        }
    },*/
    {
        name: 'voter-nexus',
        path: '/voter-nexus/',
        components: {
            default: voterTools,            
            navigation: nav
        },
        props: {
            default: true,
            navigation: true
        }
    },
    {
        name: 'nexus-index',
        path: '/nexus-index/',
        components: {
            default: nexusIndex,
            navigation: nav
        },
        props: {
            default: true,
            navigation: true
        }
    },        
    {
        name: 'donor',
        path: '/nexus-index/donor/:userID?/:saveID?',
        components: {
            default: niDonor,
            navigation: nav
        },
        props: {
            default: true,
            navigation: true
        }
    },
    {
        name: 'filer',
        path: '/nexus-index/filer/:filerID',
        components: {
            default: niFiler,
            navigation: nav
        },
        props: {
            default: true,
            navigation: true
        }
    },
    {
        name: 'filer-search',
        path: '/nexus-index/filer-search/:userID?/:saveID?',
        components: {
            default: niFilerSearch,
            navigation: nav
        },
        props: {
            default: true,
            navigation: true
        }
    },
    {
        name: 'filer-rankings',
        path: '/nexus-index/filer-rankings/',
        components: {
            default: niFilerRankings,
            navigation: nav            
        },
        props: {
            default: true,
            navigation: true
        }
    },
    {
        name: 'influencers-index',
        path: '/nexus-index/influencers-index/',
        components: {
            default: niInfluencers,
            navigation: nav            
        },
        props: {
            default: true,
            navigation: true
        }
    },
    {
        name: 'county',
        path: '/nexus-index/influencers-index/county/',
        components: {
            default: niInfluencersCounty,
            navigation: nav            
        },
        props: {
            default: true,
            navigation: true
        }
    },
    {
        name: 'county-committee',
        path: '/nexus-index/influencers-index/county/:county?',
        components: {
            default: niInfluencersCountyCommittee,
            navigation: nav            
        },
        props: {
            default: true,
            navigation: true
        }
    },
    {
        name: 'saved-list',
        path: '/nexus-index/saved-list/:userID?/:saveID?',
        components: {
            default: niSavedListDetail,
            navigation: nav
            
        },
        props: {
            default: true,
            navigation: true,
        },
    },
    {
        name: 'saved-lists',
        path: '/nexus-index/user-favorites/saved-lists',
        components: {
            default: niSavedLists,
            navigation: nav            
        },
        props: {
            default: true,
            navigation: true,
        },
    },
    {
        name: 'saved-pages',
        path: '/nexus-index/user-favorites/saved-pages',
        components: {
            default: niSavedPages,
            navigation: nav            
        },
        props: {
            default: true,
            navigation: true,
        },
    },
    {
        name: 'saved-searches',
        path: '/nexus-index/user-favorites/saved-searches',
        components: {
          default: niSavedSearches,
          navigation: nav
        },
        props: {
          default: true,
          navigation: true,
        },
    },
    {
        name: 'quick-lookup',
        path: '/voter-nexus/quick-lookup',
        components: {
            default: vtQuickLookup,
            navigation: nav
            
        },
        props: {
            default: true,
            navigation: true
        }
    },
    { 
        name: 'match',
        path: '/voter-nexus/match',
        components: {
            default: vtMatch,
            navigation: nav
            
        },
        props: {
            default: true,
            navigation: true
        }
    },
    { 
        name: 'history',
        path: '/voter-nexus/history/:userid?/:matchid?', 
        components: {
            default: vtHistory,
            navigation: nav
            
        },
        props: {
            default: true,
            navigation: true
        }
    },
    { 
        name: 'targets',
        path: '/voter-nexus/targets/:listid?', 
        components: {
            default: vtLists,
            navigation: nav
            
        },
        props: {
            default: true,
            navigation: true                
        }
    },        
    { 
        name: 'admin',
        path: '/admin', 
        components: {
            default: admin,
            navigation: nav,
            adminNavigation: adminNav
        },
        props: {
            default: true,
            navigation: true,
            adminNavigation: true
        }
    },
    { 
        name: 'groups',
        path: '/admin/groups/:groupid?', 
        components: {
            default: adminGroups,
            navigation: nav,
            adminNavigation: adminNav
        },
        props: {
            default: true,
            navigation: true,
            adminNavigation: true
        }
    },       
    { 
        name: 'regions',
        path: '/admin/regions/:regionid?', 
        components: {
            default: adminRegions,
            navigation: nav,
            adminNavigation: adminNav
        },
        props: {
            default: true,
            navigation: true,
            adminNavigation: true
        }
    },
    { 
        name: 'rights',
        path: '/admin/rights', 
        components: {
            default: adminRights,
            navigation: nav,
            adminNavigation: adminNav
        },
        props: {
            default: true,
            navigation: true,
            adminNavigation: true
        }
    },
    { 
        name: 'users',
        path: '/admin/users/:userid?', 
        components: {
            default: adminUsers,
            navigation: nav,
            adminNavigation: adminNav
        },
        props: {
            default: true,
            navigation: true,
            adminNavigation: true
        }
    },
    {
        name: 'resetpass',
        path: '/reset-password/:token',
        components: {
            default: home,
            navigation: nav
        },
        props: {
            default: true,
            navigation: true
        }
    },
    {
        name: 'noauth',
        path: '/not-authorized',
        components: {
            default: noAuth,
            navigation: nav
        },
        props: {
            default: true,
            navigation: true
        }
    },
    {
        path: '*',
        //redirect: '/'
        redirect: '/nexus-index'
    }
]
});

new Vue({
    components: {        
        home        
    },    
    router,
    login,
    data: {
        user: JSON.parse(JSON.stringify(userDefault)),
        originalUser: {},
        alert: JSON.parse(JSON.stringify(alertDefault)),
        env: env,
        dates: [],
        events: [],
        loggedIn: false,
        loading: false,
        logoutMessage: false,
        personas: [],
        baseURI: dataBaseURI,
        branch: ''
    },
    computed: {
        development: function () {
            var hostname = window.location.hostname
            var out = true
            switch (hostname) {
                case 'docunexus.net':
                    out = false;
                break;
                default:
                    out = true;
                break;
            }
            return out;
        },
    },

    created() {
        //this.$root.logOut();
        this.isLoggedIn();
        
    },

    methods: {   
        getEnvironment: function() {
            this.baseURI = dataBaseURI;
        },
        getBranch: function() {
            var _this = this;            
            axios.get(this.baseURI+'/git.branch')
            .then(function (response) {                
                _this.branch = response.data;
            });
        },        
        logOut: function (message) {
            this.$cookies.remove('docunexus-user');
            this.user = JSON.parse(JSON.stringify(userDefault));
            localStorage.setItem('loggedOut', true);
            localStorage.setItem('logoutMessage', JSON.stringify(message));
            this.loggedIn = false;
        },
        isLoggedIn: function () {            
            var p = window.location.pathname;
            this.logoutMessage = false;
            if (p.indexOf('reset-password') != -1) {
                return;
            }            
            this.user = JSON.parse(JSON.stringify(userDemo));
            this.loggedIn = true;

            /*
            if (this.$cookies.isKey('docunexus-user')) {
                this.user = this.$cookies.get('docunexus-user');
                this.originalUser = JSON.parse(JSON.stringify(this.user));
                this.loggedIn = true;
            } else {
                if (this.$route.name != 'home') {
                    this.$router.push('home');
                }
            }*/
        },
        handleTokenError: function (data) {
            if (data.tokenerror) {
                this.logOut({ message: data.message, style: 'alert-warning' });
            }
        },
        clearAlert: function () {
            this.alert = JSON.parse(JSON.stringify(alertDefault));
        },
        setAlert: function (display, message, css) {
            this.alert.display = display;
            this.alert.class = css;
            this.alert.message = message;
        },
    },
    render: (h) => h(app)
}).$mount('#app');

Vue.filter('highlight', function(item, query) {
    if (item == null) {
        return;
    }
    var invalid = /[°"§%()[\]{}=\\?´`'#<>|,;.:+_]+/g;
    var repl = query.trim().replace(invalid, "");
    var check = new RegExp(repl, "ig");	
    return item.toString().replace(check, function(matchedText){
        return ('<span class="bg-warning text-white">' + matchedText + '</span>');
    });
});
Vue.directive('tooltip', function(el, binding){
    $(el).tooltip({
        title: binding.value,
        placement: binding.arg,
        trigger: 'hover'
    }).on('click', function() {
        $(el).tooltip('hide');
    });
});