#!/bin/sh

numb='181'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.3 --psy-rd 1.8 --qblur 0.3 --qcomp 0.9 --vbv-init 0.2 --aq-mode 0 --b-adapt 0 --bframes 2 --crf 45 --keyint 220 --lookahead-threads 2 --min-keyint 25 --qp 0 --qpstep 3 --qpmin 0 --qpmax 68 --rc-lookahead 18 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset medium --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,3.0,1.3,1.3,1.8,0.3,0.9,0.2,0,0,2,45,220,2,25,0,3,0,68,18,5,2000,-1:-1,hex,crop,medium,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"