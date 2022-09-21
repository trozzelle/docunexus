<template>
    <div class="row navbar footer fixed-bottom" :class="className">
        <div class="col-md-6 col-12">
            <div class="text-md-left text-center">                
                <div class="small">
                    &copy; Copyright {{currentYear}} | docunexus.net
                </div>
            </div>
        </div>
        <div class="col-md-6 icons col-12">
            <div class="text-md-right text-center">                
            </div>            
        </div>
    </div>
</template>

<script>
export default {  
    computed: {
        currentYear: function() {
            return new Date().getFullYear();
        },
        className: function() {
            var out = '';
            var p = this.$route.path;
            if (p.indexOf("nexus-index") != -1) {
                out = "nexus-index";
            }
            if (p.indexOf("voter-nexus") != -1) {
                out = "voter-nexus";
            }
            return out;
        }
    }
}
</script>
<style scoped>
.row.footer {
    background-color: #23b5d3;
    border-top: 1px solid #1f9cb6;
    padding: 20px;    
    color: #FFF;    
}

.row.footer.nexus-index {
    background-color: #1a2d50;
    border-top: 1px solid #1a2d50;
}
.row.footer.voter-nexus {
    background-color: #43aa8b;
    border-top: 1px solid #43aa8b;
}

.icons a {
    color: #FFF;
    padding: 0px 5px;
}

.icons a:hover {
    opacity: 0.8;
}
</style>