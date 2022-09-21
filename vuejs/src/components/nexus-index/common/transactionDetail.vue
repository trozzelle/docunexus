<template>
    <b-container fluid>
        <b-row class="my-3 text-center">
            <b-col cols="2">
                <span id="transaction-detail-value" class="d-block">{{ currentRecord.election_year || "--" }}</span>
                <span id="transaction-detail-label">Election Year</span>
            </b-col>
            <b-col cols="2">
                <span id="transaction-detail-value" class="d-block">{{ currentRecord.election_type || "--" }}</span>
                <span id="transaction-detail-label">Election Type</span>
            </b-col>
            <b-col cols="2">
                <span id="transaction-detail-value" class="d-block">{{ currentRecord.filing_description || "--" }}</span>
                <span id="transaction-detail-label">Filing</span>
            </b-col>
            <b-col cols="4">
                <span id="transaction-detail-value" class="d-block">{{ currentRecord.committee_type || "--" }}</span>
                <span id="transaction-detail-label">Committee Type</span>
            </b-col>
        </b-row>
            <b-row class="my-3 text-center">
                <b-col cols="4">
                    <span id="transaction-detail-value" class="d-block">{{ currentRecord.filing_schedule_description || "--" }}</span>
                    <span id="transaction-detail-label">Schedule</span>
                </b-col>
            <b-col cols="4" offset-md="2">
                <span id="transaction-detail-value" class="d-block">{{ formatCurrency(currentRecord.original_amount) || "--" }}</span>
                <span id="transaction-detail-label">Amount</span>
            </b-col>
            <b-col cols="1">
                <span id="transaction-detail-value" class="d-block">{{ (currentRecord.payment_type + " " + currentRecord.payment_number) || "--" }}</span>
                <span id="transaction-detail-label">Pay Info</span>
            </b-col>
        </b-row>
        <b-row class="my-3 text-center">
            <b-col cols="4">
                <span id="transaction-detail-value" class="d-block">{{ formatDonorName(currentRecord) || "--" }}</span>
                <span id="transaction-detail-label">Donor</span>
            </b-col>
            <b-col cols="4" offset-md="2">
                <span id="transaction-detail-value" class="d-block">{{ currentRecord.transaction_explanation || "--" }}</span>
                <span id="transaction-detail-label">Transaction Explanation</span>
            </b-col>
            <b-col cols="1">
                <span id="transaction-detail-value" class="d-block">{{ currentRecord.contribution_type || "--" }}</span>
                <span id="transaction-detail-label">Type</span>
            </b-col>
        </b-row>
        <b-row class="my-3 text-center">
            <b-col cols="4">
                <span id="transaction-detail-value" class="d-block">{{ formatDonorAddress(currentRecord) || "--" }}</span>
                <span id="transaction-detail-label">Address</span>
            </b-col>
            <b-col cols="2">
                <span id="transaction-detail-value" class="d-block">{{ currentRecord.contributor_type || "--" }}</span>
                <span id="transaction-detail-label">Contributor Type</span>
            </b-col>
            <b-col cols="2" offset-md="1">
                <b-list-group horizontal>
                    <b-list-group-item id="transaction-detail-check" class="flex-fill">
                        <span id="transaction-detail-value" class="d-block">
                            <span v-if="currentRecord.is_itemized == 'Y'"><i class="fas fa-check"></i></span>
                            <span v-if="currentRecord.is_itemized == 'N' || !currentRecord.is_itemized"><i class="fas fa-times"></i></span>
                        </span>
                        <span id="transaction-detail-label">Is Itemized</span>
                    </b-list-group-item>
                    <b-list-group-item id="transaction-detail-check" class="flex-fill">
                        <span id="transaction-detail-value" class="d-block">
                            <span v-if="currentRecord.is_liability == 'Y'"><i class="fas fa-check"></i></span>
                            <span v-if="currentRecord.is_liability == 'N' || !currentRecord.is_liability"><i class="fas fa-times"></i></span>
                        </span>
                        <span id="transaction-detail-label">Is Liability</span>
                    </b-list-group-item>
                    <b-list-group-item id="transaction-detail-check" class="flex-fill">
                        <span id="transaction-detail-value" class="d-block">
                            <span v-if="currentRecord.is_amended == 'Y'"><i class="fas fa-check"></i></span>
                            <span v-if="currentRecord.is_amended == 'N' || !currentRecord.is_amended"><i class="fas fa-times"></i></span>
                        </span>
                        <span id="transaction-detail-label">Is Amended</span>
                    </b-list-group-item>
                </b-list-group>
            </b-col>
        </b-row>
    </b-container>
</template>

<script>
export default {
    data: function () {
        return {
            currentRecord: {},
            inRecord: {},
        }
    },
    computed: {},
    beforeMount() {},
    mounted() {
        this.currentRecord = Object.freeze(this.params.data);
    },
    methods: {
        // called when the cell is refreshed
        refresh() {
            return false
        },
        formatDonorName: function (record) {
            var out = '';

            if (record.donor_organization_name) {
                out = record.donor_organization_name;
            }

            if (record.donor_first_name && record.donor_last_name) {
                if (record.donor_organization_name) {
                    out += ' | ';
                }
                out += record.donor_first_name + ' ' + (record.donor_middle_name ? record.donor_middle_name + ' ' : '') + record.donor_last_name;
            }
            return out.trim();
        },
        formatDonorAddress: function (record) {
            var arr = [record.donor_address, record.donor_city, record.donor_state, record.donor_zip];
            var out = '';

            for (var i = 0; i < arr.length; i++) {
                out += (arr[i] || '') + ' ';
            }
            
            return out.trim();
        },
    },
}
</script>
<style scoped>

#transaction-detail-value {
    font-size: .9rem;
}

#transaction-detail-label {
    font-style: italic;
}

#transaction-detail-check {
    border: 0 !important;
    /* padding:0 !important; */
    padding-left: 0;
    padding-right: 10px;
    background-color: inherit !important;
}
</style>
