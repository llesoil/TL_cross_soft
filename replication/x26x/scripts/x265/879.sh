#!/bin/sh

numb='880'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.2 --psy-rd 4.6 --qblur 0.2 --qcomp 0.9 --vbv-init 0.0 --aq-mode 3 --b-adapt 0 --bframes 4 --crf 40 --keyint 210 --lookahead-threads 0 --min-keyint 25 --qp 20 --qpstep 3 --qpmin 4 --qpmax 60 --rc-lookahead 18 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset slow --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,3.0,1.1,1.2,4.6,0.2,0.9,0.0,3,0,4,40,210,0,25,20,3,4,60,18,1,2000,-1:-1,hex,crop,slow,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"