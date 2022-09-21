<template>
    <nav class="navbar navbar-expand-md">        
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarAdmin" aria-controls="navbarAdmin" aria-expanded="false" aria-label="Toggle navigation">
            <i class="fas fa-bars"></i>
        </button>
        <div class="container collapse navbar-collapse" id="navbarAdmin">
            <ul class="navbar-nav">                
                <!--<li><router-link tag="a" exact class="nav-item nav-link" :to="{name: 'rights', params: {}}"><i class="fad fa-unlock-alt"></i> Rights</router-link></li>-->
                <!-- <li><router-link tag="a" exact class="nav-item nav-link" :to="{name: 'admin', params: {}}"><i class="fad fa-tools"></i> Home</router-link></li> -->
                <li v-if="$root.user.admin.region_admin == 'Y' || $root.user.admin.site_admin == 'Y'"><router-link tag="a" exact class="nav-item nav-link" :to="{name: 'regions', params: {}}"><i class="fad fa-globe-stand"></i> Regions</router-link></li>
                <li v-if="$root.user.admin.group_admin == 'Y' || $root.user.admin.region_admin == 'Y' || $root.user.admin.site_admin == 'Y'"><router-link tag="a" exact class="nav-item nav-link" :to="{name: 'groups', params: {}}"><i class="fad fa-layer-group"></i> Groups</router-link></li>
                <li v-if="$root.user.admin.group_admin == 'Y' || $root.user.admin.region_admin == 'Y' || $root.user.admin.site_admin == 'Y'"><router-link tag="a" exact class="nav-item nav-link" :to="{name: 'users', params: {}}"><i class="fad fa-user-friends"></i> Users</router-link></li>
            </ul>
        </div>                    
    </nav>    
</template>
<script>
export default {       
    data: function() {
        return {  
            
        }
    },
    methods: {
        
    },
    created: function() {        
    },    
}
</script>
<style scoped>
nav {        
    background-color: #099;
    border-top: 1px solid #007c7c;
    font-size: 1.0rem;    
}

#navbarAdmin {
    margin-bottom: 0px;
}

.navbar {    
    padding: 0 1rem;   
}

.navbar .navbar-nav>li>a {
    color: #FFF;
    transition: all .4s;
}

.navbar .navbar-nav li a.nav-item.router-link-active, 
.navbar .navbar-nav li a.nav-item.router-link-active:focus, 
.navbar .navbar-nav li a.nav-item.router-link-active:hover,
.dropdown-menu a:hover,
.dropdown-menu a:focus {
    color: #099;
    background-color: #EEE;
}

.navbar .navbar-nav>li>a:hover {
   color: #099;
    background-color: #EEE;
}

.navbar .navbar-text {
    padding: 0;
}

.navbar-expand-md .navbar-nav .nav-link {
padding: 0.6rem 1.7rem;
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