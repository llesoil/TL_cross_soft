#!/bin/sh

numb='2639'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 4.4 --qblur 0.5 --qcomp 0.9 --vbv-init 0.5 --aq-mode 0 --b-adapt 2 --bframes 8 --crf 15 --keyint 260 --lookahead-threads 2 --min-keyint 30 --qp 20 --qpstep 3 --qpmin 1 --qpmax 62 --rc-lookahead 38 --ref 6 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset medium --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.0,1.4,1.1,4.4,0.5,0.9,0.5,0,2,8,15,260,2,30,20,3,1,62,38,6,2000,-2:-2,umh,show,medium,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"