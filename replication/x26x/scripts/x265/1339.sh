#!/bin/sh

numb='1340'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 4.2 --qblur 0.6 --qcomp 0.9 --vbv-init 0.5 --aq-mode 1 --b-adapt 2 --bframes 6 --crf 0 --keyint 300 --lookahead-threads 1 --min-keyint 25 --qp 30 --qpstep 3 --qpmin 1 --qpmax 64 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset placebo --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,0.0,1.5,1.2,4.2,0.6,0.9,0.5,1,2,6,0,300,1,25,30,3,1,64,48,6,1000,1:1,dia,show,placebo,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"