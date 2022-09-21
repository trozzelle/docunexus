function getElectionYears() {
    var d = new Date();
    var n = d.getFullYear();
    var out = [];
    for (var i = 1999; i <= n; i++) {
        out.push({display: i, val: i});
    }
    return out;
}

const electionYears = getElectionYears();

const filingKey = [
    {val: 'J', display: 'JANUARY PERIODIC'},
    {val: 'A', display: '32-DAY PRE-PRIMARY'},
    {val: 'B', display: '11-DAY PRE-PRIMARY'},
    {val: 'C', display: '10-DAY POST-PRIMARY'},
    {val: 'K', display: 'JULY PERIODIC'},
    {val: 'D', display: '32-DAY PRE-GENERAL'},
    {val: 'E', display: '11-DAY PRE-GENERAL'},
    {val: 'F', display: '27-DAY POST-GENERAL'},
    {val: 'G', display: '32-DAY PRE-SPECIAL'},
    {val: 'H', display: '11-DAY PRE-SPECIAL'},
    {val: 'I', display: '27-DAY POST-SPECIAL'},
    {val: 'L', display: 'OFF CYCLE'},
];

const filingScheduleKey = [
    {val: 'A', display: 'MONETARY CONTRIBUTIONS RECEIVED FROM IND. & PART.', short: 'Individual'},
    {val: 'B', display: 'MONETARY CONTRIBUTIONS RECEIVED FROM CORPORATION', short: 'Corporate'},
    {val: 'C', display: 'MONETARY CONTRIBUTIONS RECEIVED FROM ALL OTHER', short: 'PAC'},
    {val: 'D', display: 'IN-KIND (NON-MONETARY) CONTRIBUTIONS RECEIVED', short: 'In-Kind'},
    {val: 'E', display: 'OTHER RECEIPTS RECEIVED', short: 'Other Receipts'},
    {val: 'F', display: 'EXPENDITURES/ PAYMENTS', short: 'Expenditures'},
    {val: 'G', display: 'TRANSFERS IN', short: 'Transfers In'},
    {val: 'H', display: 'TRANSFERS OUT', short: 'Transfers Out'},
    {val: 'I', display: 'LOANS RECEIVED', short: 'Loans Received'},
    {val: 'J', display: 'LOAN REPAYMENTS', short: 'Loan Repayment'},
    {val: 'K', display: 'LIABILITIES/LOANS FORGIVEN', short: 'Liabilities'},
    {val: 'L', display: 'EXPENDITURE REFUNDS (INCREASES BALANCE)', short: 'Expense Refunds'},
    {val: 'M', display: 'CONTRIBUTIONS REFUNDED (DECREASES BALANCE)', short: 'Donation Refund'},
    {val: 'N', display: 'OUTSTANDING LIABILITIES/LOANS', short: 'Outstanding Debt'},
    {val: 'O', display: 'LLCS/PARTNERSHIP/SUBCONTRACTOR', short: 'Vendor Payments'},
    {val: 'P', display: 'NON-CAMPAIGN HOUSEKEEPING RECEIPTS', short: 'Housekeeping Receipts'},
    {val: 'Q', display: 'NON-CAMPAIGN HOUSEKEEPING EXPENSES', short: 'Housekeeping Expenses'},
    {val: 'R', display: 'EXPENSE ALLOCATION AMONG CANDIDATES', short: 'Expense Allocation'},

];

const filerStatuses = [
    {val: 'Active', display: 'Active'},
    {val: 'Inactive', display: 'Active'}
];

const filerTypes = [
    {val: 'County', display: 'County'},
    {val: 'State', display: 'State'}
];

const complianceTypes = [
    {val: 'Committee', display: 'Committee'},
    {val: 'Candidate', display: 'Candidate'}
];

const committeeTypes = [
    {val: 1, display: 'Authorized Multi-Candidate Committee'},
    {val: 2, display: 'Authorized Single Candidate Committee'},
    {val: 3, display: 'Ballot Issue Committee'},
    {val: 4, display: 'Constituted County Committee'},
    {val: 5, display: 'Constituted County House Keeping Committee'},
    {val: 6, display: 'Constituted State Committee'},
    {val: 7, display: 'Constituted State House Keeping Committee'},
    {val: 8, display: 'Duly Constituted Sub-Committee of a County Committee'},
    {val: 9, display: 'Duly Constituted Sub-Committee of a County Committee - House Keeping'},
    {val: 10, display: 'Duly Constituted Sub-Committee of a County Committee - House Keeping - Town'},
    {val: 11, display: 'Duly Constituted Sub-Committee of a County Committee - House Keeping - Village'},
    {val: 12, display: 'Duly Constituted Sub-Committee of a County Committee - Town'},
    {val: 13, display: 'Duly Constituted Sub-Committee of a County Committee - Village'},
    {val: 14, display: 'Duly Constituted Sub-Committee of a County Committee-City'},
    {val: 15, display: 'Independent Expenditure Committee'},
    {val: 16, display: 'Party County Committee'},
    {val: 17, display: 'Party County House Keeping Committee'},
    {val: 18, display: 'Party State Committee'},
    {val: 19, display: 'Party State House Keeping Committee'},
    {val: 20, display: 'Political Action Committee'},

];

const officeTypes = [
    {val: "'1','2','3'", display: 'Alderperson'},
    {val: "'4'", display: 'Alt Judicial Del.'},
    {val: "'5'", display: 'Alt National Del.'},
    {val: "'6'", display: 'Assessor'},
    {val: "'7'", display: 'Attorney General'},
    {val: "'8'", display: 'Borough President'},
    {val: "'9'", display: 'Chairperson'},
    {val: "'10'", display: 'City Attorney'},
    {val: "'11'", display: 'City Auditor'},
    {val: "'12'", display: 'City Chamberlain'},
    {val: "'13'", display: 'City Constable'},
    {val: "'14','16'", display: 'City Council'},
    {val: "'15'", display: 'City Council President'},
    {val: "'17','56'", display: 'City Court Judge'},
    {val: "'19'", display: 'City School Board'},
    {val: "'20'", display: 'City Treasurer'},
    {val: "'21'", display: 'Civil Court Judge'},
    {val: "'22'", display: 'Clerk'},
    {val: "'23','24'", display: 'Clerk/Collector'},
    {val: "'25'", display: 'Collector'},
    {val: "'26'", display: 'Commissioner of Accounts'},
    {val: "'27'", display: 'Commissioner of Education'},
    {val: "'28'", display: 'Commissioner of Finance'},
    {val: "'29'", display: 'Commissioner of Public Safety'},
    {val: "'30'", display: 'Commissioner of Public Works'},
    {val: "'31'", display: 'Commissioner of Schools'},
    {val: "'32'", display: 'Common Council'},
    {val: "'33','34'", display: 'Comptroller'},
    {val: "'33','34'", display: 'Controller'},
    {val: "'35'", display: 'Coroner'},
    {val: "'39'", display: 'Council President'},
    {val: "'38','40','42','45'", display: 'Councilman'},
    {val: "'41'", display: 'Councilman at Large'},
    {val: "'46'", display: 'County Clerk'},
    {val: "'47'", display: 'County Committee'},
    {val: "'50','56'", display: 'County Court Judge'},
    {val: "'49',' 50'", display: 'County Executive'},
    {val: "'51'", display: 'County Legislator'},
    {val: "'52'", display: 'County Representative'},
    {val: "'55'", display: 'County Treasurer'},
    {val: "'57'", display: 'District Attorney'},
    {val: "'58'", display: 'District Court Judge'},
    {val: "'59'", display: 'District Leader'},
    {val: "'60'", display: 'Family Court Judge'},
    {val: "'61'", display: 'Governor'},
    {val: "'62'", display: 'Highway Superintendent'},
    {val: "'63'", display: 'Judicial Delegate'},
    {val: "'65'", display: 'Legislative District'},
    {val: "'66'", display: 'Legislator'},
    {val: "'67'", display: 'Lt. Governor'},
    {val: "'68'", display: 'Mayor'},
    {val: "'69'", display: 'Member of Assembly'},
    {val: "'71'", display: 'Municipal Court Judge'},
    {val: "'72'", display: 'National Delegate'},
    {val: "'73'", display: 'Party Committee Member'},
    {val: "'74'", display: 'Police Justice'},
    {val: "'75'", display: 'Pres. Common Council'},
    {val: "'76'", display: 'Public Advocate'},
    {val: "'77'", display: 'Receiver of Taxes'},
    {val: "'77','78'", display: 'Representative in Congress'},
    {val: "'81'", display: 'Sheriff'},
    {val: "'82'", display: 'State Committee'},
    {val: "'83'", display: 'State Senator'},
    {val: "'84'", display: 'Sup. Court Justice'},
    {val: "'86'", display: 'Supervisor'},
    {val: "'87'", display: 'Supervisor/Mayor'},
    {val: "'89'", display: 'Surrogate Court Judge'},
    {val: "'90'", display: 'Town Board'},
    {val: "'91'", display: 'Town Clerk'},
    {val: "'92'", display: 'Town Clerk/Tax Collector'},
    {val: "'93','94','95'", display: 'Town Council'},
    {val: "'96'", display: 'Town Justice'},
    {val: "'97'", display: 'Town Supervisor'},
    {val: "'98'", display: 'Town Tax Collector'},
    {val: "'99'", display: 'Treasurer'},
    {val: "'100'", display: 'Trustee'},
    {val: "'101'", display: 'Undeclared'},
    {val: "'102'", display: 'Village Justice'},
    {val: "'104'", display: 'Village Treasurer'},
    {val: "'105'", display: 'Village Trustee'},


];
// { val: 'Alderperson', display: 'Alderperson' },
// { val: 'Alt Judicial Del.', display: 'Alt Judicial Del.' },
// { val: 'Alt National Del.', display: 'Alt National Del.' },
// { val: 'Assessor', display: 'Assessor' },
// { val: 'Attorney General', display: 'Attorney General' },
// { val: 'Borough President', display: 'Borough President' },
// { val: 'Chairperson', display: 'Chairperson' },
// { val: 'City Attorney', display: 'City Attorney' },
// { val: 'City Auditor', display: 'City Auditor' },
// { val: 'City Chamberlain', display: 'City Chamberlain' },
// { val: 'City Constable', display: 'City Constable' },
// { val: 'City Council', display: 'City Council' },
// { val: 'City Council President', display: 'City Council President' },
// { val: 'City Court Judge', display: 'City Court Judge' },
// { val: 'City School Board', display: 'City School Board' },
// { val: 'City Treasurer', display: 'City Treasurer' },
// { val: 'Civil Court Judge', display: 'Civil Court Judge' },
// { val: 'Clerk', display: 'Clerk' },
// { val: 'Clerk/Collector', display: 'Clerk/Collector' },
// { val: 'Collector', display: 'Collector' },
// { val: 'Commissioner of Accounts', display: 'Commissioner of Accounts' },
// { val: 'Commissioner of Education', display: 'Commissioner of Education' },
// { val: 'Commissioner of Finance', display: 'Commissioner of Finance' },
// { val: 'Commissioner of Public Safety', display: 'Commissioner of Public Safety' },
// { val: 'Commissioner of Public Works', display: 'Commissioner of Public Works' },
// { val: 'Commissioner of Schools', display: 'Commissioner of Schools' },
// { val: 'Common Council', display: 'Common Council' },
// { val: 'Comptroller', display: 'Comptroller' },
// { val: 'Controller', display: 'Controller' },
// { val: 'Coroner', display: 'Coroner' },
// { val: 'Council President', display: 'Council President' },
// { val: 'Councilman', display: 'Councilman' },
// { val: 'Councilman at Large', display: 'Councilman at Large' },
// { val: 'County Clerk', display: 'County Clerk' },
// { val: 'County Committee', display: 'County Committee' },
// { val: 'County Court Judge', display: 'County Court Judge' },
// { val: 'County Executive', display: 'County Executive' },
// { val: 'County Legislator', display: 'County Legislator' },
// { val: 'County Representative', display: 'County Representative' },
// { val: 'County Treasurer', display: 'County Treasurer' },
// { val: 'District Attorney', display: 'District Attorney' },
// { val: 'District Court Judge', display: 'District Court Judge' },
// { val: 'District Leader', display: 'District Leader' },
// { val: 'Family Court Judge', display: 'Family Court Judge' },
// { val: 'Governor', display: 'Governor' },
// { val: 'Highway Superintendent', display: 'Highway Superintendent' },
// { val: 'Judicial Delegate', display: 'Judicial Delegate' },
// { val: 'Legislative District', display: 'Legislative District' },
// { val: 'Legislator', display: 'Legislator' },
// { val: 'Lt. Governor', display: 'Lt. Governor' },
// { val: 'Mayor', display: 'Mayor' },
// { val: 'Member of Assembly', display: 'Member of Assembly' },
// { val: 'Municipal Court Judge', display: 'Municipal Court Judge' },
// { val: 'National Delegate', display: 'National Delegate' },
// { val: 'Party Committee Member', display: 'Party Committee Member' },
// { val: 'Police Justice', display: 'Police Justice' },
// { val: 'Pres. Common Council', display: 'Pres. Common Council' },
// { val: 'Public Advocate', display: 'Public Advocate' },
// { val: 'Receiver of Taxes', display: 'Receiver of Taxes' },
// { val: 'Representative in Congress', display: 'Representative in Congress' },
// { val: 'Sheriff', display: 'Sheriff' },
// { val: 'State Committee', display: 'State Committee' },
// { val: 'State Senator', display: 'State Senator' },
// { val: 'Sup. Court Justice', display: 'Sup. Court Justice' },
// { val: 'Supervisor', display: 'Supervisor' },
// { val: 'Supervisor/Mayor', display: 'Supervisor/Mayor' },
// { val: 'Surrogate Court Judge', display: 'Surrogate Court Judge' },
// { val: 'Town Board', display: 'Town Board' },
// { val: 'Town Clerk', display: 'Town Clerk' },
// { val: 'Town Clerk/Tax Collector', display: 'Town Clerk/Tax Collector' },
// { val: 'Town Council', display: 'Town Council' },
// { val: 'Town Justice', display: 'Town Justice' },
// { val: 'Town Supervisor', display: 'Town Supervisor' },
// { val: 'Town Tax Collector', display: 'Town Tax Collector' },
// { val: 'Treasurer', display: 'Treasurer' },
// { val: 'Trustee', display: 'Trustee' },
// { val: 'Undeclared', display: 'Undeclared' },
// { val: 'Village Justice', display: 'Village Justice' },
// { val: 'Village Treasurer', display: 'Village Treasurer' },
// { val: 'Village Trustee', display: 'Village Trustee' },
// ];

const countyList = [
    {val: 'Albany', display: 'Albany'},
    {val: 'Allegany', display: 'Allegany'},
    {val: 'Bronx', display: 'Bronx'},
    {val: 'Broome', display: 'Broome'},
    {val: 'Cattaraugus', display: 'Cattaraugus'},
    {val: 'Cayuga', display: 'Cayuga'},
    {val: 'Chautauqua', display: 'Chautauqua'},
    {val: 'Chemung', display: 'Chemung'},
    {val: 'Chenango', display: 'Chenango'},
    {val: 'Clinton', display: 'Clinton'},
    {val: 'Columbia', display: 'Columbia'},
    {val: 'Cortland', display: 'Cortland'},
    {val: 'Delaware', display: 'Delaware'},
    {val: 'Dutchess', display: 'Dutchess'},
    {val: 'Erie', display: 'Erie'},
    {val: 'Essex', display: 'Essex'},
    {val: 'Franklin', display: 'Franklin'},
    {val: 'Fulton', display: 'Fulton'},
    {val: 'Genesee', display: 'Genesee'},
    {val: 'Greene', display: 'Greene'},
    {val: 'Hamilton', display: 'Hamilton'},
    {val: 'Herkimer', display: 'Herkimer'},
    {val: 'Jefferson', display: 'Jefferson'},
    {val: 'Kings', display: 'Kings'},
    {val: 'Lewis', display: 'Lewis'},
    {val: 'Livingston', display: 'Livingston'},
    {val: 'Madison', display: 'Madison'},
    {val: 'Monroe', display: 'Madison'},
    {val: 'Montgomery', display: 'Montgomery'},
    {val: 'Nassau', display: 'Nassau'},
    {val: 'New York', display: 'New York'},
    {val: 'Niagara', display: 'Niagara'},
    {val: 'Oneida', display: 'Oneida'},
    {val: 'Onondaga', display: 'Onondaga'},
    {val: 'Ontario', display: 'Ontario'},
    {val: 'Orange', display: 'Orange'},
    {val: 'Orleans', display: 'Orleans'},
    {val: 'Oswego', display: 'Oswego'},
    {val: 'Otsego', display: 'Otsego'},
    {val: 'Putnam', display: 'Putnam'},
    {val: 'Queens', display: 'Queens'},
    {val: 'Rensselaer', display: 'Rensselaer'},
    {val: 'Richmond', display: 'Richmond'},
    {val: 'Rockland', display: 'Rockland'},
    {val: 'Saratoga', display: 'Saratoga'},
    {val: 'Schenectady', display: 'Schenectady'},
    {val: 'Schoharie', display: 'Schoharie'},
    {val: 'Schuyler', display: 'Schuyler'},
    {val: 'Seneca', display: 'Seneca'},
    {val: 'St.Lawrence', display: 'St. Lawrence'},
    {val: 'Steuben', display: 'Steuben'},
    {val: 'Suffolk', display: 'Suffolk'},
    {val: 'Sullivan', display: 'Sullivan'},
    {val: 'Tioga', display: 'Tioga'},
    {val: 'Tompkins', display: 'Tompkins'},
    {val: 'Ulster', display: 'Ulster'},
    {val: 'Warren', display: 'Warren'},
    {val: 'Washington', display: 'Washington'},
    {val: 'Wayne', display: 'Wayne'},
    {val: 'Westchester', display: 'Westchester'},
    {val: 'Wyoming', display: 'Wyoming'},
    {val: 'Yates', display: 'Yates'},
];

// Filer Rankings constants
const filingOrder = [
    {abbrev: 'J', display: 'JANUARY PERIODIC'},
    {abbrev: 'G', display: '32-DAY PRE-SPECIAL'},
    {abbrev: 'H', display: '11-DAY PRE-SPECIAL'},
    {abbrev: 'I', display: '27-DAY POST-SPECIAL'},
    {abbrev: 'A', display: '32-DAY PRE-PRIMARY'},
    {abbrev: 'B', display: '11-DAY PRE-PRIMARY'},
    {abbrev: 'C', display: '10-DAY POST-PRIMARY'},
    {abbrev: 'K', display: 'JULY PERIODIC'},
    {abbrev: 'D', display: '32-DAY PRE-GENERAL'},
    {abbrev: 'E', display: '11-DAY PRE-GENERAL'},
    {abbrev: 'F', display: '27-DAY POST-GENERAL'},
    {abbrev: 'L', display: 'OFF CYCLE'},
];

const candidateCommitteeType = [
    {val: 'Authorized Single Candidate Committee'}

];

const multiCandidateCommitteeType = [
    {val: 'Authorized Multi-Candidate Committee'}
]

const independentExpenditureCommitteeTypes = [
    {val: 'Independent Expenditure Committee'},
];

const pacCommitteeTypes = [
    {val: 'Political Action Committee'},
];

const partyCommitteeTypes = [
    {val: 'Constituted County Committee'},
    {val: 'Constituted State Committee'},
    {val: 'Party County Committee'},
    {val: 'Party State Committee'},
];

export const donorSearchDefault = Object.freeze({
    ELECTION_YEARS: electionYears,
    FILING_KEY: filingKey,
    FILING_SCHEDULE_KEY: filingScheduleKey,
});

export const filerSummaryDefault = Object.freeze({
        FILING_SCHEDULE_KEY: filingScheduleKey
    }
);

export const filerSearchDefault = Object.freeze({
    FILER_STATUSES: filerStatuses,
    FILER_TYPES: filerTypes,
    COMPLIANCE_TYPES: complianceTypes,
    COMMITTEE_TYPES: committeeTypes,
    OFFICE_TYPES: officeTypes,
    COUNTY_LIST: countyList,
});

export const filerRankingsDefault = Object.freeze({
    CANDIDATE_TYPE: candidateCommitteeType,
    MULTI_CANDIDATE_TYPE: multiCandidateCommitteeType,
    IND_EXPEND_TYPES: independentExpenditureCommitteeTypes,
    PAC_TYPES: pacCommitteeTypes,
    PARTY_TYPES: partyCommitteeTypes,
    FILING_KEY: filingKey,
    FILING_ORDER: filingOrder
});
