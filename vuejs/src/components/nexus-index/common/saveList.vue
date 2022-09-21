<template>
    <b-dropdown id="save-list-dropdown" ref="dropdown" :text="dropdownText" :disabled="dropdownDisabled" size="sm" variant="warning" toggle-class="mt-1 ml-1 .btn-save-list">
        <b-dropdown-form inline class="mt-1 ml-1">
            <b-form-input id="save-list-name" v-model="savedListName" size="sm" placeholder="Search Name">
            </b-form-input>
            <b-button variant="success" size="sm" class="mt-1" @click="saveList">Save</b-button>
            <b-button variant="danger" size="sm" class="mt-1 ml-1" @click="hideDropdown">Cancel</b-button>
        </b-dropdown-form>
    </b-dropdown>
</template>
<script>
export default {
    props: [
        'queryParameters',
        'queryCount',
        'rowIDs',
        'searchType',
        'routeName',
        'timeRan',
        'disabled',
    ],
    data: function () {
        return {
            savedListName: this.$root.user.display_name.split('+').join(' ') + ' ' + this.$dayjs(new Date()).format('YYYY-MM-DD HH:mm:ss'), 
            dropdownText: 'Save list', 
            dropdownDisabled: false
        }
    },
    watch: {},
    mounted: function () {
        if (this.disabled) {
            this.dropdownDisabled = true;
        }
    },
    methods: {
        saveList: function () {
            var _this = this;
            var query = {
                userid: this.$root.user.userid,
                queryparameters: JSON.stringify(this.queryParameters),
                savedlistname: this.savedListName.replace(/[^a-zA-Z0-9 \-:]/g, ''),
                rowids: this.rowIDs,
                recordcount: this.queryCount,
                searchtype: this.searchType,
                routename: this.routeName,
                timeran: this.timeRan,
                timesaved: this.formattedNow(),
            };
            var saveListRoute = '/user-favorites/saved-list.save';
            this.dropdownDisabled = true;
            this.getRequestAsync(saveListRoute, query)
            .then(function () {
                _this.dropdownText = 'List saved!';
                _this.dropdownDisabled = true;
            })
            .catch(() => {
                _this.dropdownText = 'Error saving';
                _this.dropdownDisabled = false;
            });
        },
        hideDropdown: function () {
            this.$refs.dropdown.hide();
        },
    },
    computed: {
        dtaeStr: function() {
            var d = new Date();
            var out = [d.getFullYear(), 
            (d.getMonth()+1).padLeft(), 
            d.getDate.padLeft()].join('-') 
            + ' ' + 
            [d.getHours().padLeft(),
            d.getMinutes().padLeft(),
            d.getSeconds().padLeft()].join(':');
            return out;
        }
    }
}
</script>
<style scoped>
.btn-save-list {
    background-color: #17a2b8;
    border-color: #17a2b8;
}

.btn-warning {
    color: #f8f9fa;
}

.btn-warning:hover {
    color: #f8f9fa;
}
</style>