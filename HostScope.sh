rm id.txt org.txt synackscopr.txt Allscopenew.txt page.txt

for k in {1..3}
do
sudo curl 'https://platform.synack.com/api/targets?filter%5Bprimary%5D=registered&filter%5Bsecondary%5D=all&filter%5Bcategory%5D=2&filter%5Bindustry%5D=all&sorting%5Bfield%5D=dateUpdated&sorting%5Bdirection%5D=desc&pagination%5Bpage%5D='$k''   -H 'Connection: keep-alive'   -H 'Authorization: Bearer '$1''   --compressed | jq -r '.[]|.slug' >> id.txt

#curl 'https://platform.synack.com/api/targets?filter%5Bprimary%5D=registered&filter%5Bsecondary%5D=all&filter%5Bcategory%5D=2&filter%5Bindustry%5D=all&sorting%5Bfield%5D=dateUpdated&sorting%5Bdirection%5D=desc&pagination%5Bpage%5D=1'   -H 'Connection: keep-alive'   -H 'Authorization: Bearer '$1''   --compressed | jq -r '.[]|.codename'' | tee org.txt
done

paste id.txt  | while read l 
     do
      curl 'https://platform.synack.com/api/targets/'$l''   -H 'authority: platform.synack.com'   -H 'authorization: Bearer '$1''  --compressed | jq '.codename' >> Allscopenew.txt #targetnames
i=1
while [ $i -le 52 ]
do
curl 'https://platform.synack.com/api/targets/'$l'/cidrs?page='$i''   -H 'authority: platform.synack.com'   -H 'authorization: Bearer '$1''   --compressed  | jq -r '.cidrs[]' |sort -u >> Allscopenew.txt
let "i+=1"
done
done    
 
