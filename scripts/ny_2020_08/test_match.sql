
/*
create table dcnxs_ny.voter_match_data
as
SELECT v.nys_voter_id
	,u.PreferredEmail as email
	,REGEXP_REPLACE(u.`Preferred Phone`, '[\\D]+', '') as phone
	,u.LastName as last_name
	,u.Zip5 as zip5
    ,replace(replace(replace(replace(concat(
    ifnull(u.FirstName,''),' '
    ,ifnull(u.MiddleName,''),' '
    ,ifnull(u.LastName,''),' '
    ,ifnull(u.Suffix,'')
    ),'  ',' '),'  ',' '),'  ',' '),'  ',' ') full_name
    ,replace(replace(replace(replace(concat(
    ifnull(u.Address,''),' '
    ,ifnull(u.City,''),' '
    ,ifnull(u.State,''),' '
    ,ifnull(u.Zip5,'')
    ),'  ',' '),'  ',' '),'  ',' '),'  ',' ') mailing_address
FROM dcnxs_ny.1_7_match u
order by u.Address, u.mAddress;

*/

select concat('python3 -c"import sys;sys.path.insert(0,\"../python-mysql\");import dcnxs_fuzzy; dcnxs_fuzzy.get_potential_matches({',
   '''email'':''',email,''','
   '''phone'':''',phone,''','
   '''zip5'':''',zip5,''','
   '''last_name'':''',last_name,''','
   '''first_name'':''',first_name,''','
   '''full_name'':''',full_name,''','
   '''mailing_address'':''',mailing_address,''','
'})"') as json
from (
SELECT queueid
, trim(replace(replace(PreferredEmail,'\n',' '),'\t',' ')) as email
, REGEXP_REPLACE(`Preferred Phone`, '[\\D]+', '') as phone
, left(REGEXP_REPLACE(Zip5, '[\\D]+', ''),5) as zip5
, trim(replace(replace(replace(replace(replace(replace(upper(LastName),'\n',' '),'\t',' '),'  ',' '),'  ',' '),'  ',' '),'  ',' ')) as last_name
, trim(replace(replace(replace(replace(replace(replace(upper(FirstName),'\n',' '),'\t',' '),'  ',' '),'  ',' '),'  ',' '),'  ',' ')) as first_name
, trim(replace(replace(replace(replace(replace(replace(upper(
concat(
    ifnull(Address,''),' '
    ,ifnull(City,''),' '
    ,ifnull(State,''),' '
    ,ifnull(Zip5,'')
    )
),'\n',' '),'\t',' '),'  ',' '),'  ',' '),'  ',' '),'  ',' ')) as mailing_address
, trim(replace(replace(replace(replace(replace(replace(upper(
concat(
    ifnull(FirstName,''),' '
    ,ifnull(MiddleName,''),' '
    ,ifnull(LastName,''),' '
    ,ifnull(Suffix,'')
    )
),'\n',' '),'\t',' '),'  ',' '),'  ',' '),'  ',' '),'  ',' ')) as full_name
FROM dcnxs_ny.test_match_data 
) x
