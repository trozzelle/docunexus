<template>
    <span class="mr-2 badge" :class="statusClass"><i class="fas" :class="statusIcon"></i> {{statusText}}</span>
</template>
<script>
export default {
    props: {
        status: {
            type: String,
            required: true
        }
    },
    data() {
        return {
            
        }
    },
    methods: {
      
    },
    computed: {
        statusIcon: function() {
            var out = 'fa-empty-set';
            switch (this.status) {
                case 'LOADED':
                    out = 'fa-file-upload';
                break;
                case 'QUEUED':
                    out = 'fa-hourglass-start';
                break;
                case 'MATCHING':
                case 'PASS1':
                    out = 'fa-circle-notch fa-spin';
                break;
                case 'COMPLETE':
                    out = 'fa-check';
                break;
                case 'ABORTED':
                    out = 'fa-times';
                break;
            }
            return out;

        },
        statusClass: function() {
            var out = 'badge-secondary text-white';
            switch (this.status) {
                case 'LOADED':
                    out = 'badge-warning text-white';
                break;
                case 'QUEUED':                
                    out = 'badge-info';
                break;
                case 'MATCHING':
                case 'PASS1':
                    out = 'badge-warning';
                break;                
                case 'COMPLETE':
                    out = 'badge-success';
                break;
                case 'ABORTED':
                    out = 'badge-danger';
                break;
            }
            return out;
        },
        statusText: function() {
            var out = this.status.charAt(0)+(this.status.slice(1)).toLowerCase();
            if (this.status == 'PASS1') {
                out = 'Deep matching';
            }
            return out;
        }
        
    }
}
</script>