<template>
    <div class="container">
        <div v-if="!$root.loggedIn">
            <login></login>
        </div>
        <div v-else>
            <div class="row mt-3 mb-2 border-bottom">
                <div class="col-12">
                    <h1 class="display-1">
                    <i class="fad fa-tools text-primary"></i> Administration tools
                    </h1>
                </div>                         
            </div> 
            <div class="row">                
                <div v-if="$root.user.admin.region_admin == 'Y' || $root.user.admin.site_admin == 'Y'" class="col-12">
                    <h4 class="display-4"><router-link tag="a" exact class="nav-item nav-link" :to="{name: 'regions', params: {}}"><i class="fad fa-fw fa-globe-stand"></i> Regions</router-link></h4>
                </div>
                <div v-if="$root.user.admin.group_admin == 'Y' || $root.user.admin.region_admin == 'Y' || $root.user.admin.site_admin == 'Y'" class="col-12">
                    <h4 class="display-4"><router-link tag="a" exact class="nav-item nav-link" :to="{name: 'groups', params: {}}"><i class="fad fa-fw fa-layer-group"></i> Groups</router-link></h4>
                </div>
                <div v-if="$root.user.admin.group_admin == 'Y' || $root.user.admin.region_admin == 'Y' || $root.user.admin.site_admin == 'Y'" class="col-12">
                    <h4 class="display-4"><router-link tag="a" exact class="nav-item nav-link" :to="{name: 'users', params: {}}"><i class="fad fa-fw fa-user-friends"></i> Users</router-link></h4>
                </div>
            </div>
        </div>
    </div>
</template>