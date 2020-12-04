#!/bin/sh

numb='1131'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.0 --psy-rd 1.0 --qblur 0.3 --qcomp 0.9 --vbv-init 0.6 --aq-mode 3 --b-adapt 2 --bframes 8 --crf 45 --keyint 300 --lookahead-threads 3 --min-keyint 27 --qp 0 --qpstep 5 --qpmin 3 --qpmax 69 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me dia --overscan crop --preset placebo --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,1.5,1.3,1.0,1.0,0.3,0.9,0.6,3,2,8,45,300,3,27,0,5,3,69,38,2,2000,-1:-1,dia,crop,placebo,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"