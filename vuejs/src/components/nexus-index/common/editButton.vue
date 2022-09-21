<template>
    <button type="button" class="m-1 btn btn-sm btn-secondary" v-on:click="record.editing = true" ><i class="fas fa-pen"></i> Edit</button>
</template>
<script>
export default {
    name: 'editButton',
    props: {
        record: Object,
        pageType: String,
        title: String,
        saveid: String,
    },
    methods: {},
}
</script>
