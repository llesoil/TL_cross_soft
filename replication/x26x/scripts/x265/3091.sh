#!/bin/sh

numb='3092'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.0 --psy-rd 2.2 --qblur 0.2 --qcomp 0.9 --vbv-init 0.3 --aq-mode 3 --b-adapt 1 --bframes 10 --crf 10 --keyint 220 --lookahead-threads 1 --min-keyint 20 --qp 40 --qpstep 3 --qpmin 0 --qpmax 66 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan show --preset veryfast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,0.5,1.5,1.0,2.2,0.2,0.9,0.3,3,1,10,10,220,1,20,40,3,0,66,38,2,2000,-2:-2,dia,show,veryfast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"