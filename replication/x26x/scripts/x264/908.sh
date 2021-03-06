#!/bin/sh

numb='909'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-weightb --aq-strength 0.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 0.6 --qblur 0.3 --qcomp 0.6 --vbv-init 0.4 --aq-mode 1 --b-adapt 1 --bframes 16 --crf 25 --keyint 300 --lookahead-threads 3 --min-keyint 24 --qp 50 --qpstep 4 --qpmin 2 --qpmax 66 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset slow --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,0.0,1.6,1.0,0.6,0.3,0.6,0.4,1,1,16,25,300,3,24,50,4,2,66,38,3,1000,1:1,hex,show,slow,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"