#!/bin/sh

numb='1395'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.5 --pbratio 1.0 --psy-rd 4.2 --qblur 0.4 --qcomp 0.6 --vbv-init 0.0 --aq-mode 3 --b-adapt 0 --bframes 6 --crf 30 --keyint 260 --lookahead-threads 2 --min-keyint 26 --qp 30 --qpstep 3 --qpmin 4 --qpmax 62 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan crop --preset faster --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,1.0,1.5,1.0,4.2,0.4,0.6,0.0,3,0,6,30,260,2,26,30,3,4,62,28,5,1000,-1:-1,hex,crop,faster,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"