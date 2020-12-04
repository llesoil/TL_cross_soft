#!/bin/sh

numb='2175'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 1.4 --qblur 0.5 --qcomp 0.9 --vbv-init 0.4 --aq-mode 3 --b-adapt 0 --bframes 0 --crf 0 --keyint 280 --lookahead-threads 3 --min-keyint 26 --qp 20 --qpstep 3 --qpmin 4 --qpmax 67 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset medium --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,None,--slow-firstpass,--weightb,0.0,1.0,1.2,1.4,0.5,0.9,0.4,3,0,0,0,280,3,26,20,3,4,67,18,3,1000,1:1,umh,show,medium,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"