#!/bin/sh

numb='1295'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --no-asm --weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.1 --psy-rd 1.4 --qblur 0.2 --qcomp 0.8 --vbv-init 0.9 --aq-mode 2 --b-adapt 2 --bframes 10 --crf 15 --keyint 280 --lookahead-threads 3 --min-keyint 27 --qp 0 --qpstep 4 --qpmin 2 --qpmax 63 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me dia --overscan crop --preset faster --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,None,None,--no-asm,None,--weightb,1.0,1.0,1.1,1.4,0.2,0.8,0.9,2,2,10,15,280,3,27,0,4,2,63,28,4,2000,-2:-2,dia,crop,faster,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"