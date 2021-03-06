#!/bin/sh

numb='1155'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-weightb --aq-strength 2.0 --ipratio 1.6 --pbratio 1.3 --psy-rd 3.6 --qblur 0.6 --qcomp 0.9 --vbv-init 0.4 --aq-mode 2 --b-adapt 0 --bframes 0 --crf 40 --keyint 270 --lookahead-threads 1 --min-keyint 22 --qp 30 --qpstep 3 --qpmin 3 --qpmax 65 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset slow --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,2.0,1.6,1.3,3.6,0.6,0.9,0.4,2,0,0,40,270,1,22,30,3,3,65,28,1,1000,1:1,dia,crop,slow,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"