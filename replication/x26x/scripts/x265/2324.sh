#!/bin/sh

numb='2325'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --intra-refresh --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 4.8 --qblur 0.4 --qcomp 0.7 --vbv-init 0.5 --aq-mode 2 --b-adapt 1 --bframes 16 --crf 25 --keyint 280 --lookahead-threads 1 --min-keyint 28 --qp 10 --qpstep 4 --qpmin 2 --qpmax 69 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset faster --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,--intra-refresh,None,--slow-firstpass,--weightb,1.0,1.0,1.3,4.8,0.4,0.7,0.5,2,1,16,25,280,1,28,10,4,2,69,48,1,1000,-1:-1,umh,crop,faster,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"