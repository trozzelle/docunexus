<template>
    <button type="button" class="m-1 btn btn-sm btn-success"  v-on:click="$router.push({ name: route, params: routeParams})"><i class="fas fa-arrow-right"></i> Go</button>
</template>
<script>
export default {
    name: 'goButton',
    props: {
        route: String,
        params: String,
    },
    computed: {
        routeParams: function () {
            return JSON.parse(this.params);
        },
    },
}
</script>