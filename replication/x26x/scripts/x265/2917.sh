#!/bin/sh

numb='2918'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.1 --psy-rd 1.8 --qblur 0.3 --qcomp 0.7 --vbv-init 0.7 --aq-mode 2 --b-adapt 2 --bframes 6 --crf 45 --keyint 260 --lookahead-threads 1 --min-keyint 20 --qp 10 --qpstep 4 --qpmin 4 --qpmax 67 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset slow --scenecut 0 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,--slow-firstpass,--no-weightb,0.5,1.3,1.1,1.8,0.3,0.7,0.7,2,2,6,45,260,1,20,10,4,4,67,48,4,2000,-2:-2,hex,show,slow,0,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"