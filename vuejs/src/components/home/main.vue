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
        <div class="row pt-2 mb-2">
            <div class="col">
                <h3><router-link tag="a" exact class="nav-item nav-link" :to="{name: 'voter-nexus', params: {}}"><img src="/assets/images/voternexus.png" /></router-link></h3>
                <p>Match your data to the Board of Elections voter database, create lists using BOE and your own data, look up voters and more.</p>
            </div>
        </div>
        <div class="row border-top">
            <div class="col">
                <h3><router-link tag="a" exact class="nav-item nav-link" :to="{name: 'nexus-index', params: {}}"><img src="/assets/images/nexusindex.png" /></router-link></h3>                
                <p>Look up donors, filers, see the top fundraising candidates, PAC's and committees, and research regional influencers.</p>
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
        }
    },
    methods: {
                
    },
    mounted: function() {
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

    h3 img {
        transition: transform 0.2s;
    }

    h3 img:hover {
        transform: translateX(15px);
    }

    h3 img {
        max-width: 500px;
    }

    p {
        font-size: 1.2rem;
        margin-left: 20px;        
    }

</style>