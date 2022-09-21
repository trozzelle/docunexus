<template>
    <!-- <button type="button" :disabled="downloading" class="mt-1 ml-1 btn btn-sm btn-success" v-on:click="downloadResults()"> -->
    <button type="button" disabled="disabled" class="mt-1 ml-1 btn btn-sm btn-success">
        <span v-if="!downloading"><i class="fas fa-arrow-down"></i> Download results</span>
        <span v-if="downloading"><i class="fas fa-circle-notch fa-spin"></i> Downloading</span>
    </button>
</template>
<script>
export default {
    props: ['query', 'queryRoute', 'searchType'],
    data: function () {
        return {
            downloading: false,
        }
    },
    watch: {},
    mounted: function () {},
    methods: {
        downloadResults: function () {
            this.downloading = true;
            var _this = this;
            this.query.action = 'download';
            var formData = new FormData();

            formData.append('query', JSON.stringify(this.query));
            formData.append('token', JSON.stringify([{ userid: this.$root.user.userid, token: this.$root.user.auth_token }]));
            
            this.axios.post(this.$root.baseURI+_this.queryRoute, formData, {
                headers: { 'Content-Type': 'multipart/form-data' },
                responseType: 'blob',
            }).then((response) => {
                if (response.data.type == 'text/html') {
                    var d = new Blob([response.data]);
                    var r = new FileReader();
                    r.addEventListener('loadend', (e) => {
                        const err = e.target.result;
                        _this.$root.handleTokenError(err);
                        _this.$root.setAlert(true, err, 'alert-danger');
                    });
                    r.readAsText(d);
                    _this.downloading = false;
                    return;
                }
                if (response.data.error) {
                    _this.$root.setAlert(true, response.data.error, 'alert-danger');
                    _this.downloading = false;
                    return;
                } else {
                    const url = window.URL.createObjectURL(new Blob([response.data]));
                    const link = document.createElement('a');
                    link.href = url;
                    link.setAttribute('download', _this.$root.user.display_name + ' ' + _this.searchType + ' ' + dayjs.format('YYYY-MM-DD') +'.csv');
                    document.body.appendChild(link);
                    link.click();
                    _this.downloading = false;
                }
            }).catch((error) => {
                _this.$root.setAlert(true, error, 'alert-danger');
                _this.downloading = false;
                return;
            });
        }
    }
}
</script>





















<style scoped></style>
