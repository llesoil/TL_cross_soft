#!/bin/sh

numb='1643'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --intra-refresh --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.2 --pbratio 1.4 --psy-rd 4.0 --qblur 0.3 --qcomp 0.9 --vbv-init 0.3 --aq-mode 1 --b-adapt 1 --bframes 10 --crf 50 --keyint 200 --lookahead-threads 2 --min-keyint 24 --qp 10 --qpstep 3 --qpmin 1 --qpmax 64 --rc-lookahead 18 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset faster --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,--intra-refresh,--no-asm,--slow-firstpass,--weightb,2.5,1.2,1.4,4.0,0.3,0.9,0.3,1,1,10,50,200,2,24,10,3,1,64,18,1,1000,-2:-2,umh,show,faster,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"