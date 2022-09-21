<template>
    <button type="button" class="m-1 btn btn-sm btn-danger" v-on:click.prevent="record.deleting = true"><i class="fas fa-times"></i> Delete</button>
</template>
<script>
export default {
    name: 'deleteButton',
    props: {
        record: Object,
        pageType: String,
        title: String,
        saveid: String,
    },
}
</script>