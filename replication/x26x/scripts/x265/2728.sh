#!/bin/sh

numb='2729'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.1 --psy-rd 2.2 --qblur 0.4 --qcomp 0.9 --vbv-init 0.2 --aq-mode 2 --b-adapt 2 --bframes 6 --crf 20 --keyint 280 --lookahead-threads 0 --min-keyint 21 --qp 0 --qpstep 5 --qpmin 4 --qpmax 67 --rc-lookahead 28 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset placebo --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.2,1.1,2.2,0.4,0.9,0.2,2,2,6,20,280,0,21,0,5,4,67,28,6,1000,1:1,umh,show,placebo,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"