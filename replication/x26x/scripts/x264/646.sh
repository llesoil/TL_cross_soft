#!/bin/sh

numb='647'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.0 --psy-rd 1.4 --qblur 0.6 --qcomp 0.6 --vbv-init 0.5 --aq-mode 0 --b-adapt 0 --bframes 6 --crf 20 --keyint 260 --lookahead-threads 1 --min-keyint 30 --qp 40 --qpstep 5 --qpmin 2 --qpmax 62 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset faster --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,0.0,1.4,1.0,1.4,0.6,0.6,0.5,0,0,6,20,260,1,30,40,5,2,62,38,4,2000,1:1,dia,crop,faster,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"