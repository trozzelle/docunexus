<template>
    <transition name="slide" v-on:after-enter="afterEnter">
        <div class="dcnxs-global-alert text-center" v-if="alert.display" :class="{'show': alert.display}">
            <div class="alert alert-dismissable show w-50" :class="alert.class" >
                <i class="fas fa-lg" :class="alertIcon()"></i> 
                <span class="alert-message">{{alert.message}}</span>
                <button type="button" class="close" aria-label="Close">
                <i v-on:click="clearAlert()"  class="fas fa-times"></i>
            </button>
            </div>
        </div>
    </transition>
</template>
<script>
export default {
    props: ['alert'],
    methods: {
        clearAlert: function() {
            this.$root.clearAlert();            
        },
        afterEnter: function () {                        
            if (this.alert.class != 'alert-danger') {
                var t = this;               
                t.alert.timeout = setTimeout(function() {
                    t.$root.clearAlert();
                }, 3000);
            }
        },
        alertIcon: function() {
            var out = 'fa-info';
            switch (this.alert.class) {
                case 'alert-danger':
                    out = 'fa-ban';
                break;
                case 'alert-warning':
                    out = 'fa-exclamation';
                break;
                case 'alert-success':
                    out = 'fa-check';
                break;
            }
            return out;
        }
    }
}
</script>
<style scoped>
.dcnxs-global-alert {
/* fixed position a zero-height full width container */
position: fixed;
top: 0;
left: 0;
right: 0;
height: 0;
top: 0px;

/* center all inline content */
text-align: center;
z-index: 9999;
}

.dcnxs-global-alert > .alert {
border-top-right-radius: 0px;
border-top-left-radius: 0px;
display: inline-block;
text-align: left;
}

.slide-enter-active {
  transition: all .3s ease;
}
.slide-leave-active {
  transition: all .3s ease;
}
.slide-enter, .slide-leave-to
/* .slide-fade-leave-active below version 2.1.8 */ {
  transform: translateY(-55px);
  opacity: 0;
}

</style>