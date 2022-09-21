<template>
    <b-dropdown
        id="save-search-dropdown"
        ref="dropdown"
        :text="dropdownText"
        :disabled="dropdownDisabled"
        size="sm"
        variant="info"
        toggle-class="mt-1 ml-1"
    >
        <b-dropdown-form inline class="mt-1 ml-1">
            <b-form-input id="save-search-name" v-model="savedSearchName" size="sm" placeholder="Search Name">
            </b-form-input>
            <b-button variant="success" size="sm" class="mt-1" @click="saveSearch">Save</b-button>
            <b-button variant="danger" size="sm" class="mt-1 ml-1" @click="hideDropdown">Cancel</b-button>
        </b-dropdown-form>
    </b-dropdown>
</template>
<script>
export default {
    props: ['queryParameters', 'queryCount', 'searchType', 'routeName', 'timeRan'],
    data: function () {
        return {
            savedSearchName: this.$root.user.display_name.split('+').join(' ') + ' ' + this.$dayjs(new Date()).format('YYYY-MM-DD HH:mm:ss'),
            dropdownText: 'Save search',
            dropdownDisabled: false,
        }
    },
    methods: {
        saveSearch: function () {
            var _this = this;
            var query = {
                userid: this.$root.user.userid,
                queryparameters: JSON.stringify(this.queryParameters),
                savedsearchname: this.savedSearchName.replace(/[^a-zA-Z0-9 \-:]/g, ''),
                rowids: this.rowIDs,
                recordcount: this.queryCount,
                routename: this.routeName,
                searchtype: this.searchType,
                timeran: this.timeRan,
                timesaved: this.formattedNow(),
            };

            var saveSearchRoute = this.$root.baseURI+'/user-favorites/saved-search.save';
            this.dropdownDisabled = true;
            this.getRequestAsync(saveSearchRoute, query)
            .then(() => {
                _this.dropdownText = 'Search saved!';
                _this.dropdownDisabled = true;
            })
            .catch(() => {
                _this.dropdownText = 'Error saving'
                _this.dropdownDisabled = false;
            });
        },
        hideDropdown: function () {
            this.$refs.dropdown.hide();
        }
    },
}
</script>
<style scoped>
.btn-info {
    background-color: #244880 !important;
    border-color: #244880 !important;
}
</style>