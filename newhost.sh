rm *.txt

for k in {1..3}
do
sudo curl 'https://platform.synack.com/api/targets?filter%5Bprimary%5D=registered&filter%5Bsecondary%5D=all&filter%5Bcategory%5D=2&filter%5Bindustry%5D=all&sorting%5Bfield%5D=dateUpdated&sorting%5Bdirection%5D=desc&pagination%5Bpage%5D='$k''   -H 'Connection: keep-alive'   -H 'Authorization: Bearer '$1''   --compressed | jq -r '.[]|.slug' >> id.txt

curl 'https://platform.synack.com/api/targets?filter%5Bprimary%5D=registered&filter%5Bsecondary%5D=all&filter%5Bcategory%5D=2&filter%5Bindustry%5D=all&sorting%5Bfield%5D=dateUpdated&sorting%5Bdirection%5D=desc&pagination%5Bpage%5D=1'   -H 'Connection: keep-alive'   -H 'Authorization: Bearer '$1''   --compressed | jq '.[].organization.slug' | tee org.txt
done

paste id.txt  org.txt | while read l k
     do
      curl 'https://platform.synack.com/api/targets/'$l''   -H 'authority: platform.synack.com'   -H 'authorization: Bearer '$1''  --compressed | jq '.codename' >> hostscopenew.txt #targetnames
i=1
while [ $i -le 10 ]
do
curl 'https://platform.synack.com/api/asset/v2/assets?listingUid%5B%5D='$l'&organizationUid%5B%5D='$k'&assetType%5B%5D=host&hostType%5B%5D=cidr&active=true&scope%5B%5D=in&scope%5B%5D=discovered&sort=location&sortDir=asc&page='$i''   -H 'authority: platform.synack.com'   -H 'authorization: Bearer '$1''   --compressed  | jq '.[] | select(.listings[].scope == "in") | .host.cidr' |sort -u >> hostscopenew.txt
let "i+=1"
done
done    
