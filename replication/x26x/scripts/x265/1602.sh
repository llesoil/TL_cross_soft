#!/bin/sh

numb='1603'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.4 --pbratio 1.3 --psy-rd 1.6 --qblur 0.3 --qcomp 0.6 --vbv-init 0.4 --aq-mode 3 --b-adapt 2 --bframes 16 --crf 20 --keyint 250 --lookahead-threads 3 --min-keyint 26 --qp 50 --qpstep 5 --qpmin 3 --qpmax 61 --rc-lookahead 48 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset medium --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,2.0,1.4,1.3,1.6,0.3,0.6,0.4,3,2,16,20,250,3,26,50,5,3,61,48,2,2000,-2:-2,hex,show,medium,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"