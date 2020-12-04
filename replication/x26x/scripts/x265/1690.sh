#!/bin/sh

numb='1691'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --intra-refresh --weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.3 --psy-rd 3.8 --qblur 0.4 --qcomp 0.9 --vbv-init 0.5 --aq-mode 3 --b-adapt 1 --bframes 10 --crf 35 --keyint 210 --lookahead-threads 4 --min-keyint 21 --qp 20 --qpstep 4 --qpmin 0 --qpmax 65 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan crop --preset medium --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,--intra-refresh,None,None,--weightb,1.5,1.1,1.3,3.8,0.4,0.9,0.5,3,1,10,35,210,4,21,20,4,0,65,38,1,2000,-1:-1,umh,crop,medium,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"