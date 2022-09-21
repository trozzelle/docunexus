<template>
    <span class="mr-2 badge" :class="statusClass"><i class="fas" :class="statusIcon"></i> {{statusText}}</span>
</template>
<script>
export default {
    props: {
        data: {
            type: Object,
            required: true
        }
    },
    data() {
        return {
            status: ''            
        }
    },
    methods: {
        
    },
    computed: { 
        statusIcon: function() {
            var out = 'fa-empty-set';
            switch (this.status) {
                case 'ACTIVE':
                case 'PREREG':
                    out = 'fa-check';
                break;
                case 'INACTIVE':
                    out = 'fa-exclamation';
                break;
                case 'PURGED':
                    out = 'fa-times';
                break;                
            }
            return out;

        },
        statusClass: function() {
            var out = 'badge-secondary text-white';
            switch (this.status) {
                case 'ACTIVE':
                case 'PREREG':
                    out = 'badge-primary text-white';
                break;
                case 'INACTIVE':                
                    out = 'badge-warning';
                break
                case 'PURGED':
                    out = 'badge-danger';
                break;
            }
            return out;
        },
        statusText: function() {
            var out = '';
             switch (this.status) {
                case 'ACTIVE':
                    out = 'Active';
                break;
                case 'PREREG':
                    out = 'Pre-registered';
                break;
                case 'INACTIVE':
                    out = 'Inactive';
                break;
                case 'PURGED':
                    out = 'Purged';
                break;                
            }
            return out;
        }        
    },
    created() {          
        var vid = this.data.matched_voter_id;
        var match = this.data.potentials.filter(r => {
            return r.nys_voter_id == vid;
        })[0];
        this.status = match.voter_status;        
    }
}
</script>