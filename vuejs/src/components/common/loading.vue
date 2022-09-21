<template>
    <div v-if="!$parent.loggedIn" id="loggedIn" class="container">
        <h3 class="display-4"><i class="text-primary fa-xs fas fa-circle-notch fa-spin"></i> Please wait while the application loads...</h3>        
    </div>
</template>
<script>
export default {
    props: ['user']
}
</script>
<style scoped>
#loggedIn {    
    background-color: #FFF;    
    margin-top: 100px;
}
</style>